#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(cowplot)
  library(dplyr)
  library(ggplot2)
  library(msigdbr)
  library(readr)
  library(stringr)
})

args <- commandArgs(trailingOnly = TRUE)
out_png <- if (length(args) >= 1) args[[1]] else "plots/publication/FigureS2.png"
out_pdf <- if (length(args) >= 2) args[[2]] else "plots/publication/FigureS2.pdf"

arg_file <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(arg_file) > 0) {
  script_path <- normalizePath(sub("^--file=", "", arg_file[1]))
  root_dir <- normalizePath(file.path(dirname(script_path), ".."))
} else {
  root_dir <- getwd()
}

core_dir <- file.path(root_dir, "data", "processed", "core_bulk")
score_dir <- file.path(root_dir, "results", "scores")
deg_dir <- file.path(root_dir, "results", "deg")
dir.create(dirname(out_png), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(out_pdf), recursive = TRUE, showWarnings = FALSE)

datasets <- c("GSE12251", "GSE16879", "GSE23597")

short_dataset <- function(x) {
  dplyr::case_when(
    x == "GSE12251" ~ "Discovery",
    x == "GSE16879" ~ "Replication",
    x == "GSE23597" ~ "Cohort 3",
    TRUE ~ x
  )
}

read_expr <- function(path) {
  dat <- read.delim(path, check.names = FALSE, stringsAsFactors = FALSE)
  probes <- dat[[1]]
  mat <- as.matrix(dat[, -1, drop = FALSE])
  storage.mode(mat) <- "numeric"
  rownames(mat) <- probes
  mat
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

all <- list()

for (acc in datasets) {
  pheno <- read.delim(file.path(core_dir, paste0(acc, "_phenotype.tsv")), stringsAsFactors = FALSE)
  scores <- read.delim(file.path(score_dir, paste0(acc, "_module_scores.tsv")), stringsAsFactors = FALSE)
  dat <- merge(pheno, scores, by = c("dataset_id", "geo_accession", "response_binary", "timepoint"))

  expr <- read_expr(file.path(core_dir, paste0(acc, "_expression.tsv")))
  gene_deg <- read.delim(file.path(deg_dir, paste0(acc, "_deg_gene.tsv")), stringsAsFactors = FALSE)
  symbol_probe_map <- build_symbol_probe_map(gene_deg)

  # Proxy 1: 7-gene inflammation proxy (mean z-score across available genes)
  keep_genes <- c("IL1B", "TLR2", "TNFAIP6", "NAMPT", "PTGS2", "CXCR2", "TREM1")
  available <- symbol_probe_map[symbol_probe_map$SYMBOL %in% keep_genes, ]
  available <- available[!duplicated(available$SYMBOL), ]
  inflam7_proxy <- NA_real_
  if (nrow(available) >= 3) {
    z_mat <- sapply(available$ID_REF, function(probe) {
      x <- expr[probe, ]
      as.numeric(scale(x))
    })
    if (is.null(dim(z_mat))) {
      z_mat <- matrix(z_mat, ncol = 1)
    }
    inflam7_proxy <- rowMeans(z_mat, na.rm = TRUE)
  }

  # Proxy 2/3: Hallmark proxies (mean z-score across available genes)
  hallmark_inflam_proxy <- compute_gene_set_proxy(expr, symbol_probe_map, hallmark_inflammatory_genes)
  hallmark_emt_proxy <- compute_gene_set_proxy(expr, symbol_probe_map, hallmark_emt_genes)

  dat$inflam7_proxy <- as.numeric(inflam7_proxy)
  dat$hallmark_inflam_proxy <- as.numeric(hallmark_inflam_proxy)
  dat$hallmark_emt_proxy <- as.numeric(hallmark_emt_proxy)
  dat$dataset_label <- short_dataset(dat$dataset_id)
  all[[acc]] <- dat
}

df <- bind_rows(all) %>%
  mutate(
    response_binary = factor(response_binary, levels = c("responder", "nonresponder"), labels = c("Responder", "Nonresponder")),
    dataset_label = factor(dataset_label, levels = c("Discovery", "Replication", "Cohort 3"))
  )

# Residual LODO axis after strict proxy adjustment (fit within each cohort)
df <- df %>%
  group_by(dataset_label) %>%
  mutate(
    lodo_residual_strict = residuals(lm(lodo_nonresponse_module_score ~ hallmark_inflam_proxy + hallmark_emt_proxy))
  ) %>%
  ungroup()

# Palette consistent with main figures
col_nonresponder <- "#B2182B"
col_responder    <- "#2166AC"
theme_pub <- theme_classic(base_size = 8, base_family = "Helvetica") +
  theme(
    axis.line = element_line(colour = "#1A1A1A", linewidth = 0.35),
    axis.ticks = element_line(colour = "#1A1A1A", linewidth = 0.3),
    axis.title = element_text(size = 9, colour = "#1A1A1A"),
    axis.text = element_text(size = 7.5, colour = "#1A1A1A"),
    strip.background = element_blank(),
    strip.text = element_text(size = 8.5, face = "bold"),
    plot.title = element_text(size = 10, face = "bold", hjust = 0, margin = margin(0, 0, 4, 0, "pt")),
    plot.subtitle = element_text(size = 8, hjust = 0, margin = margin(0, 0, 6, 0, "pt")),
    legend.title = element_text(size = 8, face = "bold"),
    legend.text = element_text(size = 7.5),
    legend.position = "bottom"
  )

pA <- ggplot(df, aes(x = hallmark_inflam_proxy, y = lodo_nonresponse_module_score, colour = response_binary)) +
  geom_point(size = 1.6, alpha = 0.75) +
  geom_smooth(method = "lm", se = FALSE, colour = "#4D4D4D", linewidth = 0.5) +
  facet_wrap(~ dataset_label, nrow = 1, scales = "free_x") +
  scale_colour_manual(values = c("Responder" = col_responder, "Nonresponder" = col_nonresponder), name = "Response") +
  labs(
    title = "A. Held-out LODO axis vs baseline inflammatory proxy",
    subtitle = "Each point is one pretreatment sample (within-cohort z-scored expression; proxy = mean z-score across Hallmark inflammatory-response genes)",
    x = "Sample-level Hallmark inflammatory proxy (mean z-score)",
    y = "Held-out LODO axis score"
  ) +
  theme_pub

pB <- ggplot(df, aes(x = response_binary, y = lodo_residual_strict, fill = response_binary)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "#525252", linewidth = 0.35) +
  geom_violin(width = 0.8, alpha = 0.15, colour = NA, trim = FALSE) +
  geom_boxplot(width = 0.18, outlier.shape = NA, alpha = 0.9, colour = "#1A1A1A", linewidth = 0.3) +
  geom_jitter(width = 0.12, size = 1.1, alpha = 0.55, colour = "#1A1A1A") +
  facet_wrap(~ dataset_label, nrow = 1) +
  scale_fill_manual(values = c("Responder" = col_responder, "Nonresponder" = col_nonresponder), guide = "none") +
  labs(
    title = "B. Partial-residual view after proxy adjustment",
    subtitle = "Residuals from: LODO axis ~ Hallmark inflammatory proxy + Hallmark EMT proxy (fit within each cohort)",
    x = NULL,
    y = "Residual LODO axis score"
  ) +
  theme_pub + theme(axis.text.x = element_text(face = "bold"))

p <- plot_grid(pA, pB, ncol = 1, rel_heights = c(1.1, 1.0), align = "v", axis = "lr")

ggsave(out_pdf, p, width = 7.5, height = 6.0, units = "in", device = cairo_pdf, bg = "white")
ggsave(out_png, p, width = 7.5, height = 6.0, units = "in", dpi = 600, type = "cairo", bg = "white")

cat("[ok] wrote:", out_pdf, "\n")
cat("[ok] wrote:", out_png, "\n")
