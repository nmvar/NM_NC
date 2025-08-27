cd /home/tigs/noncod/nmgd_run/out

bcftools convert --tsv2vcf /home/tigs/noncod/nmgd_run/out/splice.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > splice.vcf
bcftools convert --tsv2vcf /home/tigs/noncod/nmgd_run/out/intron.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > intron.vcf
bcftools convert --tsv2vcf /home/tigs/noncod/nmgd_run/out/utr.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT,INFO > utr.vcf

