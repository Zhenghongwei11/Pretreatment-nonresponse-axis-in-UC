#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(AnnotationDbi)
  library(hgu133plus2.db)
})

args <- commandArgs(trailingOnly = TRUE)

get_arg <- function(flag) {
  idx <- match(flag, args)
  if (is.na(idx) || idx == length(args)) {
    return(NA_character_)
  }
  args[[idx + 1]]
}

deg_path <- get_arg("--deg")
out_path <- get_arg("--out")

if (is.na(deg_path) || is.na(out_path)) {
  stop("Usage: annotate_deg_gpl570_one.R --deg <deg.tsv> --out <deg_gene.tsv>")
}

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

dat <- read.delim(deg_path, stringsAsFactors = FALSE, check.names = FALSE)
probes_raw <- dat$ID_REF
probes_key <- ifelse(grepl("_PM_", probes_raw, fixed = TRUE), gsub("_PM_", "_", probes_raw, fixed = TRUE), probes_raw)
ann <- map_probe_annotations(probes_key)
ann$ID_REF <- probes_raw
dat <- merge(dat, ann, by = "ID_REF", all.x = TRUE, sort = FALSE)
dat <- dat[!is.na(dat$SYMBOL) & dat$SYMBOL != "", ]
dat <- dat[order(dat$P.Value, -abs(dat$logFC)), ]
dat_gene <- dat[!duplicated(dat$SYMBOL), ]

dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
write.table(dat_gene, out_path, sep = "\t", quote = FALSE, row.names = FALSE)
message("[ok] wrote gene-level DEG table to ", out_path)
