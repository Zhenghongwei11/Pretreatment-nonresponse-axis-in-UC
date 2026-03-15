#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(AnnotationDbi)
  library(hgu133plus2.db)
})

arg_file <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(arg_file) > 0) {
  script_path <- normalizePath(sub("^--file=", "", arg_file[1]))
  root_dir <- normalizePath(file.path(dirname(script_path), ".."))
} else {
  root_dir <- getwd()
}

deg_dir <- file.path(root_dir, "results", "deg")
datasets <- c("GSE12251", "GSE16879", "GSE23597")

map_probe_annotations <- function(probes) {
  symbols <- mapIds(
    hgu133plus2.db,
    keys = probes,
    column = "SYMBOL",
    keytype = "PROBEID",
    multiVals = "first"
  )
  entrez <- mapIds(
    hgu133plus2.db,
    keys = probes,
    column = "ENTREZID",
    keytype = "PROBEID",
    multiVals = "first"
  )
  data.frame(
    ID_REF = probes,
    SYMBOL = unname(symbols),
    ENTREZID = unname(entrez),
    stringsAsFactors = FALSE
  )
}

gene_tables <- list()

for (acc in datasets) {
  in_path <- file.path(deg_dir, paste0(acc, "_deg.tsv"))
  dat <- read.delim(in_path, stringsAsFactors = FALSE, check.names = FALSE)
  ann <- map_probe_annotations(dat$ID_REF)
  dat <- merge(dat, ann, by = "ID_REF", all.x = TRUE, sort = FALSE)
  dat <- dat[!is.na(dat$SYMBOL) & dat$SYMBOL != "", ]
  dat <- dat[order(dat$P.Value, -abs(dat$logFC)), ]
  dat_gene <- dat[!duplicated(dat$SYMBOL), ]
  out_path <- file.path(deg_dir, paste0(acc, "_deg_gene.tsv"))
  write.table(dat_gene, out_path, sep = "\t", quote = FALSE, row.names = FALSE)
  gene_tables[[acc]] <- dat_gene
}

all_symbols <- sort(unique(unlist(lapply(gene_tables, function(x) x$SYMBOL))))
summary_df <- data.frame(SYMBOL = all_symbols, stringsAsFactors = FALSE)

for (acc in datasets) {
  dat <- gene_tables[[acc]]
  sub <- dat[, c("SYMBOL", "logFC", "P.Value", "adj.P.Val")]
  colnames(sub) <- c(
    "SYMBOL",
    paste0(acc, "_logFC"),
    paste0(acc, "_PValue"),
    paste0(acc, "_adjP")
  )
  summary_df <- merge(summary_df, sub, by = "SYMBOL", all.x = TRUE, sort = FALSE)
}

direction_cols <- character()
for (acc in datasets) {
  logfc_col <- paste0(acc, "_logFC")
  dir_col <- paste0(acc, "_direction")
  summary_df[[dir_col]] <- ifelse(
    is.na(summary_df[[logfc_col]]),
    NA,
    ifelse(summary_df[[logfc_col]] > 0, "up_in_responders", "up_in_nonresponders")
  )
  direction_cols <- c(direction_cols, dir_col)
}

same_direction_count <- apply(summary_df[, direction_cols], 1, function(x) {
  x <- na.omit(x)
  if (length(x) == 0) {
    return(0)
  }
  max(sum(x == "up_in_nonresponders"), sum(x == "up_in_responders"))
})
summary_df$max_same_direction_cohorts <- same_direction_count

# Count how many cohorts meet nominal P < 0.05 (used for strict consensus module definition).
p_cols <- paste0(datasets, "_PValue")
summary_df$nominal_p_lt_0_05_cohorts <- apply(summary_df[, p_cols], 1, function(x) {
  x <- suppressWarnings(as.numeric(x))
  x <- x[!is.na(x)]
  sum(x < 0.05)
})

summary_df <- summary_df[order(-summary_df$max_same_direction_cohorts, summary_df$GSE12251_PValue, summary_df$GSE16879_PValue, summary_df$GSE23597_PValue), ]

write.table(
  summary_df,
  file.path(deg_dir, "gene_direction_summary.tsv"),
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

# Convenience export: direction summary augmented with nominal-P cohort counts.
# This table is consumed by downstream module-scoring code.
write.table(
  summary_df,
  file.path(deg_dir, "gene_direction_filtered.tsv"),
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

message("[ok] wrote gene-level DEG tables and cross-cohort direction summary")
