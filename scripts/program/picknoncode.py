setwd = "/home/tigs/noncod/nmgd_run/out"

import pandas as pd


file = "/home/tigs/noncod/nmgd_run/out/csq_annotated.tsv"
df = pd.read_csv(file, sep = "\t")
#df

not_req = ["missense","synonymous","frameshift","inframe_deletion","inframe_insertion"]
required = ["intron","non_coding","splice_region","splice_acceptor","splice_donor","5_prime_utr","3_prime_utr","intergenic","feature_elongation","start_retained","stop_retained"]

filtered_df = df[df["INFO"].isin(required)]

intron_df = filtered_df[filtered_df["INFO"].isin(["intron","non_coding","intergenic","start_retained","stop_retained"])]
#intron_df
utr_df = filtered_df[filtered_df["INFO"].isin(["5_prime_utr","3_prime_utr","feature_elongation"])]
#utr_df
splice_df = filtered_df[filtered_df["INFO"].isin(["splice_region","splice_acceptor","splice_donor"])]
#splice_df


intron_df.to_csv("intron.tsv", sep="\t", index=False)
utr_df.to_csv("utr.tsv", sep="\t", index=False)
splice_df.to_csv("splice.tsv", sep="\t", index=False)


