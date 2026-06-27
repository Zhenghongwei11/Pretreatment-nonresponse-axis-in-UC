#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(limma)
})

args <- commandArgs(trailingOnly = TRUE)

get_arg <- function(flag) {
  idx <- match(flag, args)
  if (is.na(idx) || idx == length(args)) {
    return(NA_character_)
  }
  args[[idx + 1]]
}

expr_path <- get_arg("--expr")
pheno_path <- get_arg("--pheno")
out_path <- get_arg("--out")
dataset_id <- get_arg("--dataset")

if (is.na(expr_path) || is.na(pheno_path) || is.na(out_path) || is.na(dataset_id)) {
  stop("Usage: run_limma_one_bulk.R --dataset <ID> --expr <expr.tsv> --pheno <pheno.tsv> --out <deg.tsv>")
}

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

expr <- read_expr(expr_path)
pheno <- read.delim(pheno_path, stringsAsFactors = FALSE, check.names = FALSE)

sample_ids <- pheno$geo_accession
if (!identical(colnames(expr), sample_ids)) {
  stop(sprintf("%s column order mismatch between expression and phenotype", dataset_id))
}

if (should_log2(expr)) {
  expr[expr <= 0] <- NA
  expr <- log2(expr)
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

dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
write.table(tt, out_path, sep = "\t", quote = FALSE, row.names = FALSE)
message("[ok] wrote limma DEG table for ", dataset_id, " to ", out_path)

