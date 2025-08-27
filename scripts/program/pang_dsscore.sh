#!/bin/bash

cd /home/tigs/noncod/nmgd_run/out



awk -F'\t' '
BEGIN {
    OFS = "\t"
    print "CHROM", "POS", "REF", "ALT", "MIN_SCORE"
}
NR > 1 {
    chrom = $1
    pos   = $2
    ref   = $3
    alt   = $4
    info  = $6

    split(info, parts, "|")
    gene = parts[1]

    min_score = 0
    for (i = 2; i <= 3; i++) {
        split(parts[i], tmp, ":")
        score = tmp[2] + 0
        if (i == 2 || score < min_score) {
            min_score = score
        }
    }

    print chrom, pos, ref, alt, min_score
}
' pang_splice.tsv > splice_pangds.tsv


awk -F'\t' '
BEGIN {
    OFS = "\t"
    print "CHROM", "POS", "REF", "ALT", "MIN_SCORE"
}
NR > 1 {
    chrom = $1
    pos   = $2
    ref   = $3
    alt   = $4
    info  = $6

    split(info, parts, "|")
    gene = parts[1]

    min_score = 0
    for (i = 2; i <= 3; i++) {
        split(parts[i], tmp, ":")
        score = tmp[2] + 0
        if (i == 2 || score < min_score) {
            min_score = score
        }
    }

    print chrom, pos, ref, alt, min_score
}
' pang_intron.tsv > intron_pangds.tsv


awk -F'\t' '
BEGIN {
    OFS = "\t"
    print "CHROM", "POS", "REF", "ALT", "MIN_SCORE"
}
NR > 1 {
    chrom = $1
    pos   = $2
    ref   = $3
    alt   = $4
    info  = $6

    split(info, parts, "|")
    gene = parts[1]

    min_score = 0
    for (i = 2; i <= 3; i++) {
        split(parts[i], tmp, ":")
        score = tmp[2] + 0
        if (i == 2 || score < min_score) {
            min_score = score
        }
    }

    print chrom, pos, ref, alt, min_score
}
' pang_utr.tsv > utr_pangds.tsv



