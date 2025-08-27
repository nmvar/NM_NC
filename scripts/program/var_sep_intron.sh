cd /home/tigs/noncod/nmgd_run/out/intron

awk 'BEGIN {
    FS="\t"; OFS="\t";
    print "chrom","pos","ref","alt","cadd_rawscore","linsight","fathmm_xf","gerp_n"
}
NR > 1 {
    split($1, a, "-");
    print "chr"a[1], a[2], a[3], a[4], $2, $3, $4, $5
}' intron_favor_clean_final.tsv > intron_favor_separated.tsv

awk 'BEGIN {
    FS="\t"; OFS="\t";
    print "chrom","pos","ref","alt", "geneSymbol", "tissueSiteDetailId", "nes",	"pValue"
}
NR > 1 {
    split($1, a, "_");
    print a[1], a[2], a[3], a[4], $2, $3, $4, $5
}' intron_gtex_final.tsv > intron_gtex_separated.tsv




