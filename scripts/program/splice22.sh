#!/bin/bash

source $(conda info --base)/etc/profile.d/conda.sh
conda activate splice

cd /home/tigs/noncod/nmgd_run/out

bcftools convert --tsv2vcf splice2.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > splice2.vcf
bcftools convert --tsv2vcf intron2.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > intron2.vcf
bcftools convert --tsv2vcf utr2.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > utr2.vcf

cd /home/tigs/noncod/nmgd_run/req/SpliceAI

spliceai -I /home/tigs/noncod/nmgd_run/out/intron2.vcf -O /home/tigs/noncod/nmgd_run/out/splice_intron.vcf -R /home/tigs/noncod/nmgd_run/req/hg38.fa -A grch38
spliceai -I /home/tigs/noncod/nmgd_run/out/splice2.vcf -O /home/tigs/noncod/nmgd_run/out/splice_splice.vcf -R /home/tigs/noncod/nmgd_run/req/hg38.fa -A grch38
spliceai -I /home/tigs/noncod/nmgd_run/out/utr2.vcf -O /home/tigs/noncod/nmgd_run/out/splice_utr.vcf -R /home/tigs/noncod/nmgd_run/req/hg38.fa -A grch38

cd /home/tigs/noncod/nmgd_run/out

echo -e 'CHROM\tPOS\tREF\tALT\tINFO' > intron_splice.tsv 
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO\n' splice_intron.vcf >> intron_splice.tsv
echo -e 'CHROM\tPOS\tREF\tALT\tINFO' > splice_splice.tsv 
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO\n' splice_splice.vcf >> splice_splice.tsv
echo -e 'CHROM\tPOS\tREF\tALT\tINFO' > utr_splice.tsv
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO\n' splice_utr.vcf >> utr_splice.tsv 


