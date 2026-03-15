#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(limma)
})

arg_file <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(arg_file) > 0) {
  script_path <- normalizePath(sub("^--file=", "", arg_file[1]))
  root_dir <- normalizePath(file.path(dirname(script_path), ".."))
} else {
  root_dir <- getwd()
}

core_dir <- file.path(root_dir, "data", "processed", "core_bulk")
deg_dir <- file.path(root_dir, "results", "deg")
qc_dir <- file.path(root_dir, "results", "qc")
dir.create(deg_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(qc_dir, recursive = TRUE, showWarnings = FALSE)

datasets <- c("GSE12251", "GSE16879", "GSE23597")

read_expr <- function(path) {
  dat <- read.delim(path, check.names = FALSE, stringsAsFactors = FALSE)
  probes <- dat[[1]]
  mat <- as.matrix(dat[, -1, drop = FALSE])
  storage.mode(mat) <- "numeric"
  rownames(mat) <- probes
  mat
}

should_log2 <- function(mat) {
  qx <- quantile(mat, probs = c(0, 0.25, 0.5, 0.75, 0.99, 1.0), na.rm = TRUE)
  (qx[5] > 100) || ((qx[6] - qx[1]) > 50 && qx[2] > 0)
}

qc_rows <- list()
summary_rows <- list()

for (acc in datasets) {
  message("[run] ", acc)
  expr_path <- file.path(core_dir, paste0(acc, "_expression.tsv"))
  pheno_path <- file.path(core_dir, paste0(acc, "_phenotype.tsv"))

  expr <- read_expr(expr_path)
  pheno <- read.delim(pheno_path, stringsAsFactors = FALSE, check.names = FALSE)

  sample_ids <- pheno$geo_accession
  if (!identical(colnames(expr), sample_ids)) {
    stop(sprintf("%s column order mismatch between expression and phenotype", acc))
  }

  log2_applied <- FALSE
  if (should_log2(expr)) {
    expr[expr <= 0] <- NA
    expr <- log2(expr)
    log2_applied <- TRUE
  }

  group <- factor(pheno$response_binary, levels = c("nonresponder", "responder"))
  design <- model.matrix(~ group)
  fit <- lmFit(expr, design)
  fit <- eBayes(fit)

  tt <- topTable(
    fit,
    coef = "groupresponder",
    number = nrow(expr),
    sort.by = "P"
  )
  tt$ID_REF <- rownames(tt)
  tt$response_reference <- "responder_vs_nonresponder"
  tt <- tt[, c("ID_REF", "logFC", "AveExpr", "t", "P.Value", "adj.P.Val", "B", "response_reference")]
  out_path <- file.path(deg_dir, paste0(acc, "_deg.tsv"))
  write.table(tt, out_path, sep = "\t", quote = FALSE, row.names = FALSE)

  qc_rows[[acc]] <- data.frame(
    dataset_id = acc,
    probes_n = nrow(expr),
    samples_n = ncol(expr),
    responder_n = sum(group == "responder"),
    nonresponder_n = sum(group == "nonresponder"),
    log2_applied = log2_applied,
    min_value = min(expr, na.rm = TRUE),
    median_value = median(expr, na.rm = TRUE),
    max_value = max(expr, na.rm = TRUE),
    stringsAsFactors = FALSE
  )

  summary_rows[[acc]] <- data.frame(
    dataset_id = acc,
    fdr_lt_0_05 = sum(tt$adj.P.Val < 0.05, na.rm = TRUE),
    fdr_lt_0_10 = sum(tt$adj.P.Val < 0.10, na.rm = TRUE),
    p_lt_0_05 = sum(tt$P.Value < 0.05, na.rm = TRUE),
    top_probe = tt$ID_REF[1],
    top_logFC = tt$logFC[1],
    top_adj_p = tt$adj.P.Val[1],
    stringsAsFactors = FALSE
  )
}

qc_df <- do.call(rbind, qc_rows)
summary_df <- do.call(rbind, summary_rows)

write.table(qc_df, file.path(qc_dir, "core_bulk_qc.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)
write.table(summary_df, file.path(deg_dir, "deg_summary.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)

message("[ok] wrote limma outputs to ", deg_dir)
