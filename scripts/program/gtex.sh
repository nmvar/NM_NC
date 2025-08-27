cd /home/tigs/noncod/nmgd_run/out

awk 'BEGIN {OFS = "\t"} {print $1"_"$2"_"$3"_"$4}' intron2.tsv > gt_intron.tsv 
awk 'BEGIN {OFS = "\t"} {print $1"_b38"}' gt_intron.tsv > g_intron.tsv

awk 'BEGIN {OFS = "\t"} {print $1"_"$2"_"$3"_"$4}' splice2.tsv > gt_splice.tsv 
awk 'BEGIN {OFS = "\t"} {print $1"_b38"}' gt_splice.tsv > g_splice.tsv

awk 'BEGIN {OFS = "\t"} {print $1"_"$2"_"$3"_"$4}' utr2.tsv > gt_utr.tsv 
awk 'BEGIN {OFS = "\t"} {print $1"_b38"}' gt_utr.tsv > g_utr.tsv

/home/tigs/noncod/nmgd_run/program/gtexall.r g_intron.tsv intron_gt.tsv
/home/tigs/noncod/nmgd_run/program/gtexall.r g_splice.tsv splice_gt.tsv
/home/tigs/noncod/nmgd_run/program/gtexall.r g_utr.tsv utr_gt.tsv

csvtk cut -t -f variantId,geneSymbol,tissueSiteDetailId,nes,pValue intron_gt.tsv > intron_gtex.tsv 
sed '1!s/\(^[^\t]*\)_b38/\1/' intron_gtex.tsv > intron_gtex_final.tsv

#csvtk sort -t -k tissueSiteDetailId,pValue:nr small_exp2.tsv | csvtk uniq -t -f tissueSiteDetailId -n 5 > top_variants_by_pvalue.tsv 

csvtk cut -t -f variantId,geneSymbol,tissueSiteDetailId,nes,pValue splice_gt.tsv > splice_gtex.tsv 
sed '1!s/\(^[^\t]*\)_b38/\1/' splice_gtex.tsv  > splice_gtex_final.tsv 

#csvtk sort -t -k tissueSiteDetailId,pValue:nr small_exp2.tsv | csvtk uniq -t -f tissueSiteDetailId -n 5 > top_variants_by_pvalue.tsv 

csvtk cut -t -f variantId,geneSymbol,tissueSiteDetailId,nes,pValue utr_gt.tsv > utr_gtex.tsv 
sed '1!s/\(^[^\t]*\)_b38/\1/' utr_gtex.tsv > utr_gtex_final.tsv

#csvtk sort -t -k tissueSiteDetailId,pValue:nr small_exp2.tsv | csvtk uniq -t -f tissueSiteDetailId -n 5 > top_variants_by_pvalue.tsv 
