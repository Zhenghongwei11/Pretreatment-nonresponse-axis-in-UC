#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(msigdbr)
})

arg_file <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(arg_file) > 0) {
  script_path <- normalizePath(sub("^--file=", "", arg_file[1]))
  root_dir <- normalizePath(file.path(dirname(script_path), ".."))
} else {
  root_dir <- getwd()
}

core_dir <- file.path(root_dir, "data", "processed", "core_bulk")
score_dir <- file.path(root_dir, "results", "scores")
pathway_dir <- file.path(root_dir, "results", "pathways")
bench_dir <- file.path(root_dir, "results", "benchmarks")
fig_dir <- file.path(root_dir, "results", "figures")
dir.create(bench_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

datasets <- c("GSE12251", "GSE16879", "GSE23597")
axes <- list(
  list(
    score_col = "strict_nonresponse_module_score",
    feature_or_axis = "strict_nonresponse_module"
  ),
  list(
    score_col = "lodo_nonresponse_module_score",
    feature_or_axis = "lodo_nonresponse_axis"
  )
)

read_expr <- function(path) {
  dat <- read.delim(path, check.names = FALSE, stringsAsFactors = FALSE)
  probes <- dat[[1]]
  mat <- as.matrix(dat[, -1, drop = FALSE])
  storage.mode(mat) <- "numeric"
  rownames(mat) <- probes
  mat
}

get_inflammatory_score <- function(acc) {
  fg_path <- file.path(pathway_dir, paste0(acc, "_hallmark_fgsea.tsv"))
  fg <- read.delim(fg_path, stringsAsFactors = FALSE)
  row <- fg[fg$pathway == "HALLMARK_INFLAMMATORY_RESPONSE", ]
  if (nrow(row) != 1) stop("Inflammatory response hallmark missing for ", acc)
  row
}

read_module_scores <- function(acc) {
  read.delim(file.path(score_dir, paste0(acc, "_module_scores.tsv")), stringsAsFactors = FALSE)
}

build_symbol_probe_map <- function(gene_deg) {
  available <- gene_deg[, c("SYMBOL", "ID_REF")]
  available <- available[!is.na(available$SYMBOL) & available$SYMBOL != "", ]
  available <- available[!duplicated(available$SYMBOL), ]
  available
}

compute_gene_set_proxy <- function(expr, symbol_probe_map, gene_set) {
  available <- symbol_probe_map[symbol_probe_map$SYMBOL %in% gene_set, , drop = FALSE]
  if (nrow(available) < 5) {
    return(NULL)
  }
  z_mat <- sapply(available$ID_REF, function(probe) {
    x <- expr[probe, ]
    as.numeric(scale(x))
  })
  if (is.null(dim(z_mat))) {
    z_mat <- matrix(z_mat, ncol = 1)
  }
  rowMeans(z_mat, na.rm = TRUE)
}

hallmark_df <- msigdbr(species = "Homo sapiens", collection = "H")
hallmark_inflammatory_genes <- unique(hallmark_df$gene_symbol[hallmark_df$gs_name == "HALLMARK_INFLAMMATORY_RESPONSE"])
hallmark_emt_genes <- unique(hallmark_df$gene_symbol[hallmark_df$gs_name == "HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION"])

all_rows <- list()

for (acc in datasets) {
  pheno <- read.delim(file.path(core_dir, paste0(acc, "_phenotype.tsv")), stringsAsFactors = FALSE)
  scores <- read_module_scores(acc)
  dat <- merge(pheno, scores, by = c("dataset_id", "geo_accession", "response_binary", "timepoint"))

  response_bin <- ifelse(dat$response_binary == "nonresponder", 1, 0)

  inf_row <- get_inflammatory_score(acc)
  inf_nes <- inf_row$NES[1]
  inf_dir <- inf_row$direction[1]
  all_rows[[paste0(acc, "_hallmark_ref")]] <- data.frame(
    dataset_id = acc,
    feature_or_axis = "hallmark_inflammatory_response_reference",
    severity_proxy = "hallmark_inflammatory_response_NES",
    base_effect = inf_nes,
    adjusted_effect = inf_nes,
    ci_lower = NA_real_,
    ci_upper = NA_real_,
    pvalue = inf_row$pval[1],
    fdr = inf_row$padj[1],
    interpretation = paste("cohort-level hallmark direction:", inf_dir),
    stringsAsFactors = FALSE
  )

  # Sample-level proxy: mean z-score of key inflammation genes that were repeatedly up in nonresponders.
  expr <- read_expr(file.path(core_dir, paste0(acc, "_expression.tsv")))
  gene_deg <- read.delim(file.path(root_dir, "results", "deg", paste0(acc, "_deg_gene.tsv")), stringsAsFactors = FALSE)
  symbol_probe_map <- build_symbol_probe_map(gene_deg)
  keep_genes <- c("IL1B", "TLR2", "TNFAIP6", "NAMPT", "PTGS2", "CXCR2", "TREM1")
  available <- symbol_probe_map[symbol_probe_map$SYMBOL %in% keep_genes, ]
  available <- available[!duplicated(available$SYMBOL), ]
  inflam_proxy <- NULL

  if (nrow(available) >= 3) {
    z_mat <- sapply(available$ID_REF, function(probe) {
      x <- expr[probe, ]
      as.numeric(scale(x))
    })
    if (is.null(dim(z_mat))) {
      z_mat <- matrix(z_mat, ncol = 1)
    }
    inflam_proxy <- rowMeans(z_mat, na.rm = TRUE)
  }

  hallmark_inflam_proxy <- compute_gene_set_proxy(expr, symbol_probe_map, hallmark_inflammatory_genes)
  hallmark_emt_proxy <- compute_gene_set_proxy(expr, symbol_probe_map, hallmark_emt_genes)

  # Per-axis models (strict vs LODO)
  for (axis in axes) {
    module_score <- dat[[axis$score_col]]
    if (is.null(module_score)) next

    base_fit <- lm(module_score ~ response_bin)
    base_coef <- coef(summary(base_fit))["response_bin", ]
    all_rows[[paste0(acc, "_", axis$feature_or_axis, "_base")]] <- data.frame(
      dataset_id = acc,
      feature_or_axis = axis$feature_or_axis,
      severity_proxy = "none",
      base_effect = unname(base_coef["Estimate"]),
      adjusted_effect = unname(base_coef["Estimate"]),
      ci_lower = unname(confint(base_fit)["response_bin", 1]),
      ci_upper = unname(confint(base_fit)["response_bin", 2]),
      pvalue = unname(base_coef["Pr(>|t|)"]),
      fdr = NA_real_,
      interpretation = "baseline group difference in module score",
      stringsAsFactors = FALSE
    )

    if (!is.null(inflam_proxy)) {
      adj_fit <- lm(module_score ~ response_bin + inflam_proxy)
      adj_coef <- coef(summary(adj_fit))["response_bin", ]
      all_rows[[paste0(acc, "_", axis$feature_or_axis, "_adjusted")]] <- data.frame(
        dataset_id = acc,
        feature_or_axis = axis$feature_or_axis,
        severity_proxy = "sample_level_inflammatory_proxy",
        base_effect = unname(base_coef["Estimate"]),
        adjusted_effect = unname(adj_coef["Estimate"]),
        ci_lower = unname(confint(adj_fit)["response_bin", 1]),
        ci_upper = unname(confint(adj_fit)["response_bin", 2]),
        pvalue = unname(adj_coef["Pr(>|t|)"]),
        fdr = NA_real_,
        interpretation = sprintf("adjusted for mean z-score of %d recurrent inflammatory genes", nrow(available)),
        stringsAsFactors = FALSE
      )
    }

    if (!is.null(hallmark_inflam_proxy)) {
      hallmark_inflam_n <- nrow(symbol_probe_map[symbol_probe_map$SYMBOL %in% hallmark_inflammatory_genes, ])
      adj_fit <- lm(module_score ~ response_bin + hallmark_inflam_proxy)
      adj_coef <- coef(summary(adj_fit))["response_bin", ]
      all_rows[[paste0(acc, "_", axis$feature_or_axis, "_hallmark_inflam_adjusted")]] <- data.frame(
        dataset_id = acc,
        feature_or_axis = axis$feature_or_axis,
        severity_proxy = "sample_level_hallmark_inflammatory_proxy",
        base_effect = unname(base_coef["Estimate"]),
        adjusted_effect = unname(adj_coef["Estimate"]),
        ci_lower = unname(confint(adj_fit)["response_bin", 1]),
        ci_upper = unname(confint(adj_fit)["response_bin", 2]),
        pvalue = unname(adj_coef["Pr(>|t|)"]),
        fdr = NA_real_,
        interpretation = sprintf(
          "adjusted for sample-level mean z-score across %d Hallmark inflammatory-response genes",
          hallmark_inflam_n
        ),
        stringsAsFactors = FALSE
      )
    }

    if (!is.null(hallmark_inflam_proxy) && !is.null(hallmark_emt_proxy)) {
      adj_fit <- lm(module_score ~ response_bin + hallmark_inflam_proxy + hallmark_emt_proxy)
      adj_coef <- coef(summary(adj_fit))["response_bin", ]
      all_rows[[paste0(acc, "_", axis$feature_or_axis, "_joint_hallmark_adjusted")]] <- data.frame(
        dataset_id = acc,
        feature_or_axis = axis$feature_or_axis,
        severity_proxy = "sample_level_hallmark_inflammatory_plus_emt_proxy",
        base_effect = unname(base_coef["Estimate"]),
        adjusted_effect = unname(adj_coef["Estimate"]),
        ci_lower = unname(confint(adj_fit)["response_bin", 1]),
        ci_upper = unname(confint(adj_fit)["response_bin", 2]),
        pvalue = unname(adj_coef["Pr(>|t|)"]),
        fdr = NA_real_,
        interpretation = sprintf(
          "adjusted jointly for sample-level Hallmark inflammatory-response and EMT proxies (%d and %d genes available)",
          nrow(symbol_probe_map[symbol_probe_map$SYMBOL %in% hallmark_inflammatory_genes, ]),
          nrow(symbol_probe_map[symbol_probe_map$SYMBOL %in% hallmark_emt_genes, ])
        ),
        stringsAsFactors = FALSE
      )
    }
  }
}

out <- do.call(rbind, all_rows)
test_rows <- !grepl("hallmark_inflammatory_response_reference", out$feature_or_axis)
out$fdr[test_rows] <- p.adjust(out$pvalue[test_rows], method = "BH")

write.table(
  out,
  file.path(bench_dir, "specificity_checks.tsv"),
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

message("[ok] wrote specificity checks to ", file.path(bench_dir, "specificity_checks.tsv"))

# Figure 5 anchor: use the interpretable 68-gene consensus signature.
fig5 <- out[out$feature_or_axis == "strict_nonresponse_module", ]
fig5 <- fig5[, c("dataset_id", "severity_proxy", "base_effect", "adjusted_effect",
                 "ci_lower", "ci_upper", "pvalue", "fdr", "interpretation")]

write.table(
  fig5,
  file.path(fig_dir, "fig5_specificity_summary.tsv"),
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

message("[ok] wrote Figure 5 anchor to ", file.path(fig_dir, "fig5_specificity_summary.tsv"))
