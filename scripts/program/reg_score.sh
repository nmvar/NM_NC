#!/bin/bash

cd /home/tigs/noncod/nmgd_run/out/reg



#mlr --tsv put '$CHR,$POS,$REF,$ALT,$INFO, $Remm*2, $Prom*2, (if $pValue<0.0.25; $nes*1.5), $linsight, $cadd_rawscore, $gerp_n, $fathmm_xf, $SpliceAI, $Pangolin, $geneSymbol, $geneSymbol' merged_utr_annotations.tsv > try_score.tsv

mlr --tsv put '
  $RemmW = is_numeric($ReMM) ? $ReMM * 2 : 0;
  $PromW = is_numeric($Prom) ? $Prom * 2: 0;
  $nesW = (is_numeric($pValue) && $pValue < 0.25) ? ($nes * 1.5) : 0;
  $SplicW = is_numeric($SpliceAI) ? $SpliceAI*0.5 : 0; 
  $PangW = is_numeric($Pangolin) ? $Pangolin*0.5 : 0;
  $Nc_score = (
    $RemmW + $PromW + $nesW +
    (is_numeric($linsight)     ? $linsight      : 0) +
    (is_numeric($cadd_rawscore)? $cadd_rawscore: 0) +
    (is_numeric($gerp_n)       ? $gerp_n        : 0) +
    (is_numeric($fathmm_xf)    ? $fathmm_xf     : 0) +
    $SplicW + $PangW
  )
' merged_utr_annotations.tsv > try_score.tsv


mlr --tsv cut -f CHROM,POS,REF,ALT,INFO,Nc_score try_score.tsv > nc_reg_score.tsv
mlr --tsv sort -nf Nc_score nc_reg_score.tsv > sorted_reg_nc.tsv



