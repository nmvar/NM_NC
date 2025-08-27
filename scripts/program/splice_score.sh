#!/bin/bash

cd /home/tigs/noncod/nmgd_run/out/splice



#mlr --tsv put '$CHR,$POS,$REF,$ALT,$INFO, $Remm*2, $Prom*2, (if $pValue<0.0.25; $nes*1.5), $linsight, $cadd_rawscore, $gerp_n, $fathmm_xf, $SpliceAI, $Pangolin, $geneSymbol, $geneSymbol' merged_utr_annotations.tsv > try_score.tsv

mlr --tsv put '
  $SplicW = is_numeric($SpliceAI) ? $SpliceAI*2 : 0; 
  $PangW = is_numeric($Pangolin) ? $Pangolin*2 : 0;
  $LinW = is_numeric($linsight) ? $linsight * 1.5 : 0;
  $caddW = is_numeric($cadd_rawscore) ? $cadd_rawscore * 1.5: 0;
  $gerpW = is_numeric($gerp_n) ? $gerp_n * 1.5 : 0;
  $fathmW = is_numeric($fathmm_xf) ? $fathmm_xf * 1.5: 0;
  $nesW = (is_numeric($pValue) && $pValue < 0.25) ? ($nes * 0.5) : 0;
  $Nc_score = (
    $LinW + $caddW + $gerpW + $fathmW +
    (is_numeric($RemmW)     ? $RemmW      : 0) +
    (is_numeric($PromW)? $PromW: 0) +
    (is_numeric($nesW)       ? $nesW        : 0) +
    $SplicW + $PangW
  )
' merged_splice_annotations.tsv > splice_score.tsv


mlr --tsv cut -f CHROM,POS,REF,ALT,INFO,Nc_score splice_score.tsv > nc_splice_score.tsv
mlr --tsv sort -nf Nc_score nc_splice_score.tsv > sorted_splice_nc.tsv



