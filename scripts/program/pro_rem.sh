#!/bin/bash

cd /home/tigs/noncod/nmgd_run/out

echo -e "In nmgd_run/out directory\n"

#mlr --tsv join -f utr2.tsv -l CHROM,POS,REF,ALT -j chrom,pos,ref,alt -r chrom,pos,ref,alt /home/tigs/noncod/req_data/promai_annotation_clean.tsv > prom_utr.tsv
#echo -e "promoter done\n"
#mlr --tsv join -f utr2.tsv -l CHROM,POS -j chrom,pos -r chr,pos /home/tigs/noncod/remmdata/new_rem.tsv > remm_utr.tsv 
#echo -e "remm done\n"

mlr --tsv join -f intron2.tsv -l CHROM,POS,REF,ALT -j chrom,pos,ref,alt -r chrom,pos,ref,alt /home/tigs/noncod/req_data/promai_annotation_clean.tsv > prom_intron.tsv
echo -e "promoter intron done\n"
mlr --tsv join -f intron2.tsv -l CHROM,POS -j chrom,pos -r chr,pos /home/tigs/noncod/remmdata/new_rem.tsv > remm_intron.tsv 
echo -e "remm intron done\n"

mlr --tsv join -f splice2.tsv -l CHROM,POS,REF,ALT -j chrom,pos,ref,alt -r chrom,pos,ref,alt /home/tigs/noncod/req_data/promai_annotation_clean.tsv > prom_splice.tsv
echo -e "promoter splice done\n"
mlr --tsv join -f splice2.tsv -l CHROM,POS -j chrom,pos -r chr,pos /home/tigs/noncod/remmdata/new_rem.tsv > remm_splice.tsv 
echo -e "remm splice done\n"
