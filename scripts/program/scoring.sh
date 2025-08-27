#!/bin/bash

cd /home/tigs/noncod/nmgd_run/out

##coverting the tsv into favor readable format (variants with hyphen)
awk 'BEGIN {OFS = "\t"} NR==1 {print "CHROM-POS-REF-ALT"; next} {gsub(/^chr/, "", $1); print $1"-"$2"-"$3"-"$4}' intron.tsv > intron-hyphen.tsv
awk 'BEGIN {OFS = "\t"} NR==1 {print "CHROM-POS-REF-ALT"; next} {gsub(/^chr/, "", $1); print $1"-"$2"-"$3"-"$4}' splice.tsv > splice-hyphen.tsv
awk 'BEGIN {OFS = "\t"} NR==1 {print "CHROM-POS-REF-ALT"; next} {gsub(/^chr/, "", $1); print $1"-"$2"-"$3"-"$4}' utr.tsv > utr-hyphen.tsv

#Annotating variants using favor api in batches


INPUT_FILE="intro-hyphen.tsv"
OUTPUT_FILE="genohub_results.tsv"
BATCH_SIZE=100
PARALLEL_JOBS=15  # Number of parallel curl jobs

# Temporary working dir
TMP_DIR="tmp_genohub"
mkdir -p "$TMP_DIR"
rm -f "$TMP_DIR"/*

# Split input into batches
split -l $BATCH_SIZE "$INPUT_FILE" "$TMP_DIR/batch_"

# Function to query a variant and write JSON as TSV-style
query_variant() {
    variant="$1"
    response=$(curl -s -G "https://api.genohub.org/v1/variants/$variant")
    
    # Extract all fields (you can keep as raw JSON or TSV; here we output as JSONL per line)
    if echo "$response" | jq empty 2>/dev/null; then
        echo -e "${variant}\t$response"
    else
        echo -e "${variant}\tERROR"
    fi
}

export -f query_variant

# Process each batch in parallel
for batch_file in "$TMP_DIR"/batch_*; do
    echo "Processing batch: $batch_file"
    cat "$batch_file" | xargs -P $PARALLEL_JOBS -I{} bash -c 'query_variant "$@"' _ {} >> "$TMP_DIR/results.tsv"
done

# Combine results
cat "$TMP_DIR/results.tsv" > "$OUTPUT_FILE"
echo "Saved results to $OUTPUT_FILE"

# Optional cleanup
# rm -r "$TMP_DIR"

echo -e "variant_vcf\tcadd_rawscore\tlinsight\tfathmm_xf\tgerp_n" > favor_req2.tsv

awk -F'\t' 'NF==2 && $2 ~ /^\{/' "$OUTPUT_FILE" \
  | while IFS=$'\t' read -r variant json; do
      echo "$json" | jq -r --arg v "$variant" '[
        $v,
        .cadd_rawscore // "NA",
        .linsight // "NA",
        .fathmm_xf // "NA",
        .gerp_n // "NA"
      ] | @tsv'
    done >> favor_req2.tsv

awk 'BEGIN{FS=OFS="\t"} NR==1 || !($2 == "NA" && $3 == "NA" && $4 == "NA" && $5 == "NA")' favor_req2.tsv > favor_req2_clean.tsv

##YOUR FAVOR ANNOTATED FILE IS FAVOR_REQ2_CLEAN.TSV
