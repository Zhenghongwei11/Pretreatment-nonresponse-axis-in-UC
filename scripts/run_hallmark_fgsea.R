#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(msigdbr)
  library(fgsea)
})

arg_file <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(arg_file) > 0) {
  script_path <- normalizePath(sub("^--file=", "", arg_file[1]))
  root_dir <- normalizePath(file.path(dirname(script_path), ".."))
} else {
  root_dir <- getwd()
}

deg_dir <- file.path(root_dir, "results", "deg")
pathway_dir <- file.path(root_dir, "results", "pathways")
dir.create(pathway_dir, recursive = TRUE, showWarnings = FALSE)

datasets <- c("GSE12251", "GSE16879", "GSE23597")

hallmark_df <- msigdbr(species = "Homo sapiens", category = "H")
hallmark_sets <- split(hallmark_df$gene_symbol, hallmark_df$gs_name)

all_rows <- list()

for (acc in datasets) {
  in_path <- file.path(deg_dir, paste0(acc, "_deg_gene.tsv"))
  dat <- read.delim(in_path, stringsAsFactors = FALSE, check.names = FALSE)
  dat <- dat[!is.na(dat$SYMBOL) & dat$SYMBOL != "", ]
  ranks <- dat$t
  names(ranks) <- dat$SYMBOL
  ranks <- ranks[!duplicated(names(ranks))]
  ranks <- sort(ranks, decreasing = TRUE)

  fg <- suppressWarnings(
    fgsea(pathways = hallmark_sets, stats = ranks, eps = 0)
  )
  fg$dataset_id <- acc
  fg$direction <- ifelse(fg$NES > 0, "up_in_responders", "up_in_nonresponders")
  fg$leadingEdge <- vapply(fg$leadingEdge, function(x) paste(x, collapse = "|"), character(1))
  fg <- fg[order(fg$padj, -abs(fg$NES)), ]
  out_path <- file.path(pathway_dir, paste0(acc, "_hallmark_fgsea.tsv"))
  write.table(fg, out_path, sep = "\t", quote = FALSE, row.names = FALSE)
  all_rows[[acc]] <- fg
}

combined <- do.call(rbind, all_rows)
write.table(
  combined,
  file.path(pathway_dir, "hallmark_fgsea_all.tsv"),
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

hallmarks <- sort(unique(combined$pathway))
summary_df <- data.frame(pathway = hallmarks, stringsAsFactors = FALSE)

for (acc in datasets) {
  sub <- combined[combined$dataset_id == acc, c("pathway", "NES", "pval", "padj", "direction")]
  colnames(sub) <- c(
    "pathway",
    paste0(acc, "_NES"),
    paste0(acc, "_pval"),
    paste0(acc, "_padj"),
    paste0(acc, "_direction")
  )
  summary_df <- merge(summary_df, sub, by = "pathway", all.x = TRUE, sort = FALSE)
}

summary_df$nominal_p_lt_0_05_cohorts <- rowSums(cbind(
  summary_df$GSE12251_pval < 0.05,
  summary_df$GSE16879_pval < 0.05,
  summary_df$GSE23597_pval < 0.05
), na.rm = TRUE)

summary_df$max_same_direction_cohorts <- apply(
  summary_df[, c("GSE12251_direction", "GSE16879_direction", "GSE23597_direction")],
  1,
  function(x) {
    x <- na.omit(x)
    if (length(x) == 0) return(0)
    max(sum(x == "up_in_nonresponders"), sum(x == "up_in_responders"))
  }
)

summary_df <- summary_df[order(-summary_df$nominal_p_lt_0_05_cohorts, -summary_df$max_same_direction_cohorts, summary_df$GSE12251_pval, summary_df$GSE16879_pval, summary_df$GSE23597_pval), ]

write.table(
  summary_df,
  file.path(pathway_dir, "hallmark_consistency_summary.tsv"),
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

message("[ok] wrote hallmark fgsea outputs to ", pathway_dir)
