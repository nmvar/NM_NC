#!/bin/bash

cd /home/tigs/noncod/nmgd_run/out

awk -F'\t' '
BEGIN {
    OFS = "\t"
    print "CHROM", "POS", "REF", "ALT", "GENE", "MAX_DS"
}
!/^#/ {
    chrom = $1
    pos   = $2
    ref   = $3
    alt   = $4

    split($5, info, "=")
    if (info[1] == "SpliceAI") {
        split(info[2], fields, "|")
        gene = fields[2]
        ds_ag = fields[3] + 0
        ds_al = fields[4] + 0
        ds_dg = fields[5] + 0
        ds_dl = fields[6] + 0

        max_ds = ds_ag
        if (ds_al > max_ds) max_ds = ds_al
        if (ds_dg > max_ds) max_ds = ds_dg
        if (ds_dl > max_ds) max_ds = ds_dl

        print $1,$2,$3,$4, gene, max_ds
    }
}
' intron_splice.tsv > intron_spliceds.tsv

awk -F'\t' '
BEGIN {
    OFS = "\t"
    print "CHROM", "POS", "REF", "ALT", "GENE", "MAX_DS"
}
!/^#/ {
    chrom = $1
    pos   = $2
    ref   = $3
    alt   = $4

    split($5, info, "=")
    if (info[1] == "SpliceAI") {
        split(info[2], fields, "|")
        gene = fields[2]
        ds_ag = fields[3] + 0
        ds_al = fields[4] + 0
        ds_dg = fields[5] + 0
        ds_dl = fields[6] + 0

        max_ds = ds_ag
        if (ds_al > max_ds) max_ds = ds_al
        if (ds_dg > max_ds) max_ds = ds_dg
        if (ds_dl > max_ds) max_ds = ds_dl

        print $1,$2,$3,$4, gene, max_ds
    }
}
' splice_splice.tsv > splice_spliceds.tsv

awk -F'\t' '
BEGIN {
    OFS = "\t"
    print "CHROM", "POS", "REF", "ALT", "GENE", "MAX_DS"
}
!/^#/ {
    chrom = $1
    pos   = $2
    ref   = $3
    alt   = $4

    split($5, info, "=")
    if (info[1] == "SpliceAI") {
        split(info[2], fields, "|")
        gene = fields[2]
        ds_ag = fields[3] + 0
        ds_al = fields[4] + 0
        ds_dg = fields[5] + 0
        ds_dl = fields[6] + 0

        max_ds = ds_ag
        if (ds_al > max_ds) max_ds = ds_al
        if (ds_dg > max_ds) max_ds = ds_dg
        if (ds_dl > max_ds) max_ds = ds_dl

        print $1,$2,$3,$4, gene, max_ds
    }
}
' utr_splice.tsv > utr_spliceds.tsv
