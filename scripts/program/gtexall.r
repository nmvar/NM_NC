#!/usr/bin/env Rscript

# Load required package
# install.packages("gtexr")
library(gtexr)



# Accept input argument (TSV file)
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]


# Read variants
variants <- read.table(input_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)$CHROM_POS_REF_ALT
print(class(variants))


# Extract just the tissueSiteDetailId values
tissues <- c("Muscle_Skeletal","Nerve_Tibial","Brain_Spinal_cord_cervical_c-1")

# Set batch size
batch_size <- 100
num_variants <- length(variants)
num_batches <- ceiling(num_variants / batch_size)

# Empty list to collect results
all_results <- list()

for (i in seq_len(num_batches)) {
  start <- ((i - 1) * batch_size) + 1
  end <- min(i * batch_size, num_variants)
  batch <- variants[start:end]

  cat("Querying batch", i, "of", num_batches, "\n")

  result <- tryCatch({
    gtexr::get_significant_single_tissue_eqtls(
      variantIds = batch,
      tissueSiteDetailIds = tissues,
      datasetId = "gtex_v8",
      itemsPerPage = 100000
    )
  }, error = function(e) {
    message("Batch failed: ", e$message)
    NULL
  })

  if (!is.null(result)) {
    all_results[[i]] <- result
  }
}

# Combine results
if (length(all_results) > 0) {
  final_df <- do.call(rbind, all_results)
  write.table(final_df, output_file, sep = "\t", quote = FALSE, row.names = FALSE)
} else {
  message("No results to write.")
}
