#!/bin/bash

#source $(conda info --base)/etc/profile.d/conda.sh
#conda activate splice

#cd /home/tigs/noncod/nmgd_run/out

#bcftools convert --tsv2vcf splice2.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > splice2.vcf
#bcftools convert --tsv2vcf intron2.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > intron2.vcf
#bcftools convert --tsv2vcf utr2.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > utr2.vcf

#cd /home/tigs/noncod/nmgd_run/req/SpliceAI

#spliceai -I /home/tigs/noncod/nmgd_run/out/intron2.vcf -O /home/tigs/noncod/nmgd_run/out/splice_intron.vcf -R /home/tigs/noncod/nmgd_run/req/hg38.fa -A grch38
#spliceai -I /home/tigs/noncod/nmgd_run/out/splice2.vcf -O /home/tigs/noncod/nmgd_run/out/splice_splice.vcf -R /home/tigs/noncod/nmgd_run/req/hg38.fa -A grch38
#spliceai -I /home/tigs/noncod/nmgd_run/out/utr2.vcf -O /home/tigs/noncod/nmgd_run/out/splice_utr.vcf -R /home/tigs/noncod/nmgd_run/req/hg38.fa -A grch38


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
