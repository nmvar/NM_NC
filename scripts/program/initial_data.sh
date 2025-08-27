echo -e "enter you input file path"
read filepath

if [ -f "$filepath" ]; then
    echo "File exists!"
else
    echo "File does not exist."
fi

echo -e "CHROM\tPOS\tREF\tALT" > one_vcf.tsv
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' $filepath >> one_vcf.tsv 
#head -35 one_vcf.tsv
## take the input vcf and modify accordingly (remove ## and headers) 
## replace #chrom with chrom  
## take only chrom pos alt ref  ##input = barcode......vcf      ##outpuy = trvcf.tsv 


awk 'BEGIN {OFS = "\t"} NR==1 { print; next }  { if ( $1 !/^chr/ ) $1 = "chr"$1; print }' one_vcf.tsv > two_vcf.tsv

bcftools convert --tsv2vcf two_vcf.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c CHROM,POS,REF,ALT > convertOne.vcf 
#head -35 convertOne.vcf
###convertig the tsv to the vcf format that we need. 

bcftools csq -f /home/tigs/noncod/nmgd_run/req/hg38.fa -g /home/tigs/noncod/nmgd_run/req/Homo_sapiens.GRCh38.114.gff3 -o convert_annotated.vcf -Ov convertOne.vcf 
#head -35 convert_annotated.vcf
awk 'BEGIN { OFS = "\t"; print "chrom", "pos", "ref", "alt", "info";} !/^#/{ split($NF, info, "="); split(info[2], ann, "|"); print $1, $2, $4, $5, ann[1];}' convert_annotated.vcf > csq_annotated.vcf 
#head -35 csq_annotated.vcf
#echo -e "csq_annotated.vcf is the vcf file"


awk 'BEGIN {OFS = "\t" } !/^#/' csq_annotated.vcf > csq_annotated.tsv
#head csq_annotated.tsv
echo -e "csq_annotated.tsv is the tsv file"

bcftools convert --tsv2vcf /home/tigs/noncod/nmgd_run/out/csq_annotated.tsv -f /home/tigs/noncod/nmgd_run/req/hg38.fa -c chrom,pos,ref,alt,info > final_csq.vcf
echo -e "final_csq.vcf is your vcf file"

