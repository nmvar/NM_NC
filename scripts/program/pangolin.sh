#!/bin/bash

#source $(conda info --base)/etc/profile.d/conda.sh
#conda activate splice

#cd /home/tigs/noncod/nmgd_run/out

#sed 's/\t/,/g' /home/tigs/noncod/nmgd_run/out/splice2.tsv > /home/tigs/noncod/nmgd_run/out/splice2.csv
#sed 's/\t/,/g' /home/tigs/noncod/nmgd_run/out/intron2.tsv > /home/tigs/noncod/nmgd_run/out/intron2.csv
#sed 's/\t/,/g' /home/tigs/noncod/nmgd_run/out/utr2.tsv > /home/tigs/noncod/nmgd_run/out/utr2.csv

cd /home/tigs/noncod/nmgd_run/req/Pangolin
pangolin -m -c CHROM,POS,REF,ALT /home/tigs/noncod/nmgd_run/out/splice2.csv /home/tigs/noncod/nmgd_run/req/hg38.fa /home/tigs/noncod/nmgd_run/req/gencode.v38.annotation.db /home/tigs/noncod/nmgd_run/out/pang_splice.csv
pangolin -m -c CHROM,POS,REF,ALT /home/tigs/noncod/nmgd_run/out/intron2.csv /home/tigs/noncod/nmgd_run/req/hg38.fa /home/tigs/noncod/nmgd_run/req/gencode.v38.annotation.db /home/tigs/noncod/nmgd_run/out/pang_intron.csv 
pangolin -m -c CHROM,POS,REF,ALT /home/tigs/noncod/nmgd_run/out/utr2.csv /home/tigs/noncod/nmgd_run/req/hg38.fa /home/tigs/noncod/nmgd_run/req/gencode.v38.annotation.db /home/tigs/noncod/nmgd_run/out/pang_utr.csv 


cd /home/tigs/noncod/nmgd_run/out

sed 's/,/\t/g' /home/tigs/noncod/nmgd_run/out/pang_splice.csv  > /home/tigs/noncod/nmgd_run/out/pang_splice.tsv 
sed 's/,/\t/g' /home/tigs/noncod/nmgd_run/out/pang_intron.csv  > /home/tigs/noncod/nmgd_run/out/pang_intron.tsv 
sed 's/,/\t/g' /home/tigs/noncod/nmgd_run/out/pang_utr.csv  > /home/tigs/noncod/nmgd_run/out/pang_utr.tsv 
