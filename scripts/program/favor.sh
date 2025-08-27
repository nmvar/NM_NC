#!/bin/bash
cd /home/tigs/noncod/nmgd_run/out

# Converting the tsv into favor readable format (variants with hyphen)
awk 'BEGIN {OFS = "\t"} NR==1 {print "CHROM-POS-REF-ALT"; next} {gsub(/^chr/, "", $1); print $1"-"$2"-"$3"-"$4}' intron2.tsv > intron-hyphen.tsv
awk 'BEGIN {OFS = "\t"} NR==1 {print "CHROM-POS-REF-ALT"; next} {gsub(/^chr/, "", $1); print $1"-"$2"-"$3"-"$4}' splice2.tsv > splice-hyphen.tsv
awk 'BEGIN {OFS = "\t"} NR==1 {print "CHROM-POS-REF-ALT"; next} {gsub(/^chr/, "", $1); print $1"-"$2"-"$3"-"$4}' utr2.tsv > utr-hyphen.tsv

# Function to process a single file
process_favor_annotation() {
    local INPUT_FILE="$1"
    local OUTPUT_PREFIX="$2"
    
    OUTPUT_FILE="${OUTPUT_PREFIX}_favor.tsv"
    BATCH_SIZE=100
    PARALLEL_JOBS=12  # Number of parallel curl jobs
    
    echo "Processing $INPUT_FILE..."
    
    # Temporary working dir
    TMP_DIR="tmp_genohub_${OUTPUT_PREFIX}"
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
    
    # Process JSON to clean TSV
    CLEAN_OUTPUT="${OUTPUT_PREFIX}_favor_clean.tsv"
    echo -e "variant_vcf\tcadd_rawscore\tlinsight\tfathmm_xf\tgerp_n" > "$CLEAN_OUTPUT"
    
    awk -F'\t' 'NF==2 && $2 ~ /^\{/' "$OUTPUT_FILE" \
      | while IFS=$'\t' read -r variant json; do
          echo "$json" | jq -r --arg v "$variant" '[
            $v,
            .cadd_rawscore // "NA",
            .linsight // "NA",
            .fathmm_xf // "NA",
            .gerp_n // "NA"
          ] | @tsv'
        done >> "$CLEAN_OUTPUT"
    
    # Remove rows where all scores are NA
    awk 'BEGIN{FS=OFS="\t"} NR==1 || !($2 == "NA" && $3 == "NA" && $4 == "NA" && $5 == "NA")' "$CLEAN_OUTPUT" > "${CLEAN_OUTPUT%.tsv}_final.tsv"
    
    echo "Final clean file: ${CLEAN_OUTPUT%.tsv}_final.tsv"
    
    # Optional cleanup
    # rm -r "$TMP_DIR"
}

# Process each file sequentially
echo "=== Processing INTRON file ==="
process_favor_annotation "intron-hyphen.tsv" "intron"

echo "=== Processing SPLICE file ==="
process_favor_annotation "splice-hyphen.tsv" "splice"

echo "=== Processing UTR file ==="
process_favor_annotation "utr-hyphen.tsv" "utr"

echo "All files processed!"
echo "Final output files:"
echo "- intron_favor_clean_final.tsv"
echo "- splice_favor_clean_final.tsv"
echo "- utr_favor_clean_final.tsv"
