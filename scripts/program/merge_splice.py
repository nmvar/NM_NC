import os

# Set the working directory
os.chdir("/home/tigs/noncod/nmgd_run/out/splice")

import pandas as pd
from functools import reduce


# Load all files
df_base = pd.read_csv("splice2.tsv", sep="\t")
df_gtex = pd.read_csv("splice_gtex_separated.tsv", sep="\t")
df_favor = pd.read_csv("splice_favor_separated.tsv", sep="\t")
df_prom = pd.read_csv("prom_splice.tsv", sep="\t")
df_remm = pd.read_csv("remm_splice.tsv", sep="\t")
df_splice = pd.read_csv("splice_spliceds.tsv", sep="\t")
df_pang = pd.read_csv("splice_pangds.tsv", sep="\t")

# Standardize column names
df_prom.rename(columns={"chrom": "CHROM", "pos": "POS", "ref": "REF", "alt": "ALT", "promoterAI": "Prom"}, inplace=True)
df_remm.rename(columns={"chrom": "CHROM", "pos": "POS", "REF": "REF", "ALT": "ALT", "prob": "ReMM"}, inplace=True)
df_splice.rename(columns={"MAX_DS": "SpliceAI"}, inplace=True)
df_pang.rename(columns={"MIN_SCORE": "Pangolin"}, inplace=True)
df_gtex.rename(columns={"chrom": "CHROM", "pos": "POS", "ref": "REF", "alt": "ALT"}, inplace=True)
df_favor.rename(columns={"chrom": "CHROM", "pos": "POS", "ref": "REF", "alt": "ALT"}, inplace=True)

# List of dataframes to merge
dfs = [
    df_base,
    df_splice[["CHROM", "POS", "REF", "ALT", "SpliceAI"]],
    df_pang[["CHROM", "POS", "REF", "ALT", "Pangolin"]],
    df_favor,
    df_remm[["CHROM", "POS", "REF", "ALT", "ReMM"]],
    df_prom[["CHROM", "POS", "REF", "ALT", "Prom"]],
    df_gtex[["CHROM", "POS", "REF", "ALT", "nes", "pValue"]],
    df_gtex[["CHROM", "POS", "REF", "ALT", "geneSymbol", "tissueSiteDetailId"]],
]

# Merge all dataframes on chrom, pos, ref, alt using outer join
merged_df = reduce(lambda left, right: pd.merge(left, right, on=["CHROM", "POS", "REF", "ALT",], how="outer"), dfs)

# Fill missing values with NA
merged_df = merged_df.astype("object")
merged_df.fillna("NA", inplace=True)


# Save to file
merged_df.to_csv("merged_splice_annotations.tsv", sep="\t", index=False)

print("✅ Merged file saved as 'merged_splice_annotations.tsv'")

