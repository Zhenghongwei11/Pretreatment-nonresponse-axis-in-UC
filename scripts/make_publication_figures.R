#!/usr/bin/env Rscript
# ──────────────────────────────────────────────────────────────
# Publication figures for IID manuscript
# Journal-quality rendering: 600 dpi PNG + vector PDF
# Outputs: plots/publication/Figure{2-5}_*.{png,pdf}
# ──────────────────────────────────────────────────────────────

suppressPackageStartupMessages({
  library(cowplot)
  library(ggplot2)
  library(gridExtra)
  library(ggtext)
  library(readr)
  library(dplyr)
  library(stringr)
  library(tidyr)
  library(scales)
  library(grid)
  library(ggrepel)
})

# ── Root directory resolution ─────────────────────────────────
arg_file <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(arg_file) > 0) {
  script_path <- normalizePath(sub("^--file=", "", arg_file[1]))
  root_dir   <- normalizePath(file.path(dirname(script_path), ".."))
} else {
  root_dir <- getwd()
}

fig_anchor_dir <- file.path(root_dir, "results", "figures")
pathway_dir    <- file.path(root_dir, "results", "pathways")
score_dir      <- file.path(root_dir, "results", "scores")
out_dir        <- file.path(root_dir, "plots", "publication")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# ── Typography & palette ──────────────────────────────────────
font_family <- "Helvetica"

# Lancet-inspired dual palette (colour-blind safe)
col_nonresponder <- "#B2182B"
col_responder    <- "#2166AC"
col_nr_light     <- "#FDDBC7"
col_r_light      <- "#D1E5F0"
col_neutral      <- "#1A1A1A"
col_border       <- "#4D4D4D"
col_gridline     <- "#E5E5E5"
col_annotation   <- "#525252"

# ── Master theme (High-impact Journal Style) ──────────────────
theme_pub <- theme_classic(base_size = 7.5, base_family = font_family) +
  theme(
    # Axes: thin lines for elegant look
    axis.line        = element_line(colour = col_neutral, linewidth = 0.35),
    axis.ticks       = element_line(colour = col_neutral, linewidth = 0.3),
    axis.ticks.length = unit(2, "pt"),
    axis.title       = element_text(size = 8, face = "plain", colour = col_neutral),
    axis.text        = element_text(size = 6.5, colour = col_neutral),
    # Titles: Centered for high-impact academic style
    plot.title       = element_text(size = 8.5, face = "bold", colour = col_neutral,
                                    hjust = 0.5, margin = margin(0, 0, 3, 0, "pt")),
    plot.subtitle    = element_text(size = 6.5, face = "italic", colour = col_annotation,
                                    hjust = 0.5, margin = margin(0, 0, 5, 0, "pt")),
    plot.title.position = "panel",
    # Legend: compact and clean
    legend.title     = element_text(size = 6.5, face = "bold"),
    legend.text      = element_text(size = 6),
    legend.key.size  = unit(7, "pt"),
    legend.background = element_blank(),
    legend.margin    = margin(0, 0, 0, 0, "pt"),
    legend.spacing.x = unit(2, "pt"),
    # Strip (facets): clean headers
    strip.background = element_blank(),
    strip.text       = element_text(size = 7.5, face = "bold", margin = margin(0, 0, 4, 0, "pt")),
    # Plot margin
    plot.margin      = margin(8, 8, 8, 8, unit = "pt"),
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background  = element_rect(fill = "white", colour = NA)
  )

# ── Helpers ───────────────────────────────────────────────────
save_fig <- function(p, stem, width_in, height_in, dpi = 600) {
  ggsave(filename = file.path(out_dir, paste0(stem, ".pdf")),
         plot = p, width = width_in, height = height_in, units = "in",
         device = cairo_pdf, bg = "white")
  ggsave(filename = file.path(out_dir, paste0(stem, ".png")),
         plot = p, width = width_in, height = height_in, units = "in",
         dpi = dpi, type = "cairo", bg = "white")
}

format_pathway <- function(x) {
  # Keep labels ASCII-only to avoid locale/font rendering issues.
  label <- x %>%
    str_replace("^HALLMARK_", "") %>%
    str_replace_all("_", " ") %>%
    str_to_lower()

  label <- label %>%
    str_replace_all("tnfa", "TNF-alpha") %>%
    str_replace_all("nfkb", "NF-kB") %>%
    str_replace_all("il6", "IL-6") %>%
    str_replace_all("jak stat3", "JAK-STAT3") %>%
    str_replace_all("\\bemt\\b", "EMT") %>%
    str_replace_all("\\bppar\\b", "PPAR")

  # Sentence-like capitalization without downcasing acronyms.
  paste0(str_to_upper(str_sub(label, 1, 1)), str_sub(label, 2))
}

short_dataset <- function(x) {
  case_when(
    x == "GSE12251" ~ "Discovery",
    x == "GSE16879" ~ "Replication",
    x == "GSE23597" ~ "Cohort 3",
    TRUE ~ x
  )
}

safe_neglog10 <- function(p) {
  p <- as.numeric(p)
  p <- ifelse(is.na(p), NA_real_, pmax(p, 1e-300))
  -log10(p)
}

# ══════════════════════════════════════════════════════════════
# FIGURE 2 — Discovery pathway structure + cross-cohort consistency
# ══════════════════════════════════════════════════════════════
fig2_sel <- read_tsv(file.path(fig_anchor_dir, "fig2_discovery_axis.tsv"), show_col_types = FALSE)
pathways_of_interest <- fig2_sel$pathway

hc <- read_tsv(file.path(pathway_dir, "hallmark_consistency_summary.tsv"), show_col_types = FALSE) %>%
  filter(pathway %in% pathways_of_interest) %>%
  mutate(pathway_label = format_pathway(pathway))

hc_long <- hc %>%
  select(pathway, pathway_label, matches("^GSE[0-9]+_(NES|padj|direction)$")) %>%
  pivot_longer(cols = -c(pathway, pathway_label), names_to = c("dataset_id", ".value"), names_pattern = "(GSE[0-9]+)_(.*)") %>%
  mutate(
    NES = as.numeric(NES),
    padj = as.numeric(padj),
    signed_NES = -NES,
    enrich = if_else(signed_NES >= 0, "Higher in nonresponders", "Higher in responders"),
    sig = if_else(!is.na(padj) & padj < 0.05, "FDR < 0.05", "n.s."),
    neglog10_fdr = safe_neglog10(padj),
    dataset_label = factor(dataset_id, levels = c("GSE12251", "GSE16879", "GSE23597"), labels = c("Discovery", "Replication", "Cohort 3"))
  )

hc_disc <- hc_long %>%
  filter(dataset_id == "GSE12251") %>%
  arrange(signed_NES) %>%
  mutate(
    q_label = if_else(
      !is.na(padj) & padj < 0.001,
      paste0("q=", scientific(padj, digits = 1)),
      paste0("q=", signif(padj, 2))
    ),
    label_x = if_else(signed_NES >= 0, signed_NES + 0.12, signed_NES - 0.12),
    label_hjust = if_else(signed_NES >= 0, 0, 1)
  )

p2a <- ggplot(hc_disc, aes(x = signed_NES, y = reorder(pathway_label, signed_NES), fill = enrich)) +
  geom_vline(xintercept = 0, linewidth = 0.35, colour = col_neutral) +
  geom_col(width = 0.75, colour = NA, alpha = 0.9) +
  geom_text(aes(x = label_x, label = q_label, hjust = label_hjust), size = 1.8, family = font_family, colour = col_annotation) +
  scale_fill_manual(values = c("Higher in nonresponders" = col_nonresponder, "Higher in responders" = col_responder), guide = "none") +
  scale_x_continuous(expand = expansion(mult = c(0.22, 0.26))) +
  labs(title = "A. Pathways enriched in discovery cohort", subtitle = "Signed NES with FDR q-values", x = "Signed NES", y = NULL) +
  theme_pub + theme(axis.text.y = element_text(size = 7), panel.grid.major.x = element_line(colour = col_gridline, linewidth = 0.2))

hc_mat <- hc_long %>% mutate(pathway_label = factor(pathway_label, levels = rev(levels(reorder(hc_disc$pathway_label, hc_disc$signed_NES)))), pt_alpha = if_else(sig == "FDR < 0.05", 1.0, 0.35))
p2b <- ggplot(hc_mat, aes(x = dataset_label, y = pathway_label)) +
  geom_tile(fill = "transparent", colour = NA) +
  geom_hline(yintercept = seq(0.5, nlevels(hc_mat$pathway_label) + 0.5, 1), colour = col_gridline, linewidth = 0.2) +
  geom_point(aes(size = neglog10_fdr, colour = enrich, alpha = pt_alpha), stroke = 0.4) +
  scale_colour_manual(values = c("Higher in nonresponders" = col_nonresponder, "Higher in responders" = col_responder), name = "Direction") +
  scale_alpha_identity() +
  scale_size_continuous(range = c(1, 5), breaks = c(1, 2, 5, 10), name = expression(-log[10] * " FDR")) +
  labs(title = "B. Cross-cohort consistency", subtitle = "Same direction colours as panel A; size encodes FDR", x = NULL, y = NULL) +
  theme_pub + theme(axis.text.x = element_text(face = "bold"), axis.text.y = element_blank(), axis.ticks.y = element_blank(), axis.line.y = element_blank(), legend.position = "right")

p2 <- plot_grid(p2a, p2b, ncol = 2, rel_widths = c(1.3, 0.85), align = "h", axis = "tb")
save_fig(p2, "Figure2_discovery_pathways", 7.5, 3.5)

# ══════════════════════════════════════════════════════════════
# FIGURE 3 — Sample-level replication + forest plot
# ══════════════════════════════════════════════════════════════
score_files <- list.files(score_dir, pattern = "_module_scores\\.tsv$", full.names = TRUE)
score_all <- lapply(score_files, function(f) read_tsv(f, show_col_types = FALSE)) %>% bind_rows()
score_all <- score_all %>% filter(is.na(timepoint) | timepoint == "" | str_detect(timepoint, "pretreatment")) %>%
  mutate(response_binary = factor(response_binary, levels = c("responder", "nonresponder"), labels = c("Responder", "Nonresponder")))

ns <- score_all %>% group_by(dataset_id, response_binary) %>% summarise(n = n(), .groups = "drop") %>%
  pivot_wider(names_from = response_binary, values_from = n, values_fill = 0) %>%
  mutate(dataset_facet_label = paste0(short_dataset(dataset_id), "\nn=", Responder + Nonresponder, " samples"))

facet_label_map <- ns %>%
  mutate(dataset_id = factor(dataset_id, levels = c("GSE12251", "GSE16879", "GSE23597"))) %>%
  arrange(dataset_id) %>%
  select(dataset_id, dataset_facet_label) %>%
  { setNames(.$dataset_facet_label, as.character(.$dataset_id)) }

score_all <- score_all %>%
  left_join(ns %>% select(dataset_id, dataset_facet_label), by = "dataset_id") %>%
  mutate(dataset_id = factor(dataset_id, levels = c("GSE12251", "GSE16879", "GSE23597")))

p3a <- ggplot(score_all, aes(x = response_binary, y = lodo_nonresponse_module_score, fill = response_binary)) +
  geom_violin(width = 0.8, alpha = 0.2, colour = NA, trim = FALSE) +
  geom_boxplot(width = 0.15, outlier.shape = NA, alpha = 0.9, colour = col_neutral, linewidth = 0.3) +
  geom_jitter(aes(colour = response_binary), width = 0.12, size = 0.8, alpha = 0.6, show.legend = FALSE) +
  facet_wrap(~ dataset_id, nrow = 1, labeller = labeller(dataset_id = as_labeller(facet_label_map))) +
  scale_fill_manual(values = c("Responder" = col_responder, "Nonresponder" = col_nonresponder), guide = "none") +
  scale_colour_manual(values = c("Responder" = col_responder, "Nonresponder" = col_nonresponder)) +
  labs(title = "A. Distribution of out-of-sample module scores", subtitle = "Module scores calculated via leave-one-dataset-out (LODO) procedure", x = NULL, y = "LODO Module Score") +
  theme_pub + theme(axis.text.x = element_text(face = "bold"))

fig3_meta <- read_tsv(file.path(fig_anchor_dir, "fig3_replication_summary.tsv"), show_col_types = FALSE) %>%
  filter(feature == "lodo_nonresponse_axis") %>%
  mutate(
    dataset_label = case_when(
      dataset_id == "GSE12251" ~ "Discovery",
      dataset_id == "GSE16879" ~ "Replication",
      dataset_id == "GSE23597" ~ "Cohort 3",
      dataset_id == "meta_random" ~ "Pooled (Random Effects)",
      TRUE ~ dataset_id
    ),
    dataset_label = factor(dataset_label, levels = rev(c("Discovery", "Replication", "Cohort 3", "Pooled (Random Effects)"))),
    is_pooled = dataset_id == "meta_random",
    pt_col = if_else(is_pooled, col_nonresponder, col_neutral)
  )

p3b <- ggplot(fig3_meta, aes(y = dataset_label, x = effect)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = col_annotation, linewidth = 0.3) +
  geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper), height = 0.15, linewidth = 0.4, colour = col_neutral) +
  geom_point(aes(shape = is_pooled, fill = pt_col), size = 2.4, colour = col_neutral, stroke = 0.4) +
  scale_shape_manual(values = c("FALSE" = 21, "TRUE" = 23), guide = "none") +
  scale_fill_identity() +
  geom_text(aes(label = sprintf("%.2f [%.2f, %.2f]", effect, ci_lower, ci_upper), x = 2.4), hjust = 1, size = 2, family = font_family, colour = col_neutral) +
  labs(title = "B. Pooled effect size meta-analysis", subtitle = "Difference in module scores (Hedges\u2019 g; 95% CI)", x = "Hedges\u2019 g (Nonresponder \u2212 Responder)", y = NULL) +
  theme_pub + theme(panel.grid.major.y = element_line(colour = col_gridline, linewidth = 0.15), axis.text.y = element_text(face = if_else(str_detect(levels(fig3_meta$dataset_label), "Pooled"), "bold", "plain")))

p3 <- plot_grid(p3a, p3b, ncol = 1, rel_heights = c(1.1, 0.8), align = "v", axis = "lr")
save_fig(p3, "Figure3_replication_forest", 7.0, 5.0)

# ══════════════════════════════════════════════════════════════
# FIGURE 4 — Single-cell localization (epithelial + immune)
# ══════════════════════════════════════════════════════════════
fig4_loc <- read_tsv(file.path(fig_anchor_dir, "fig4_localization_integrated.tsv"), show_col_types = FALSE)
ep_loc <- fig4_loc %>% filter(reference_type == "epithelial") %>%
  filter(cell_state != "unassigned") %>%
  mutate(cell_state = cell_state %>% str_replace_all("_", " ") %>% str_replace("cycling", "Cycling (Stem-like)") %>% str_replace("stem ta", "Stem/Transit-amplifying") %>% str_replace("stress", "Stress-associated"),
         cell_state = factor(cell_state, levels = cell_state[order(enrichment_score)]))

p4a <- ggplot(ep_loc, aes(y = cell_state, x = enrichment_score)) +
  geom_segment(aes(x = 0, xend = enrichment_score, yend = cell_state), colour = col_gridline, linewidth = 0.5) +
  geom_point(aes(size = n_cells), colour = col_nonresponder, alpha = 0.9) +
  scale_size_continuous(range = c(1.5, 5), name = "Cells") +
  labs(title = "A. Localization in epithelial reference", subtitle = "Enrichment in stress-associated and stem-like states (GSE116222)", x = "Enrichment score", y = NULL) +
  theme_pub + theme(legend.position = "right")

im_loc <- fig4_loc %>% filter(reference_type == "immune_rectum") %>%
  mutate(cell_state = cell_state %>% str_replace("M_DC", "Rectal M/DC"),
         disease_label = factor(disease_assignment, levels = c("healthy", "diseased"), labels = c("Healthy", "Diseased")))
im_order_loc <- im_loc %>% filter(disease_assignment == "diseased") %>% arrange(enrichment_score) %>% pull(cell_state)
im_loc$cell_state <- factor(im_loc$cell_state, levels = unique(im_order_loc))

p4b <- ggplot(im_loc, aes(y = cell_state, x = enrichment_score, colour = disease_label)) +
  geom_point(aes(size = n_cells), alpha = 0.8, stroke = 0.4, shape = 16) +
  scale_colour_manual(values = c("Healthy" = col_responder, "Diseased" = col_nonresponder), name = "Status") +
  scale_size_continuous(range = c(1.5, 5), guide = "none") +
  facet_wrap(~ disease_label, nrow = 1) +
  labs(title = "B. Localization in rectal immune reference", subtitle = "Specific enrichment in myeloid compartments (GSE125527)", x = "Enrichment score", y = NULL) +
  theme_pub + theme(strip.text = element_text(size = 7.5))

p4 <- plot_grid(p4a, p4b, ncol = 1, rel_heights = c(1, 1), align = "v", axis = "lr")
save_fig(p4, "Figure4_singlecell_localization", 7.0, 6.0)

# ══════════════════════════════════════════════════════════════
# FIGURE 5 — Specificity / attenuation under proxy adjustment
# ══════════════════════════════════════════════════════════════
fig5_spec <- read_tsv(file.path(fig_anchor_dir, "fig5_specificity_summary.tsv"), show_col_types = FALSE) %>%
  mutate(
    proxy_label = case_when(
      severity_proxy == "none" ~ "Unadjusted",
      severity_proxy == "sample_level_inflammatory_proxy" ~ "7-gene Inflam.",
      severity_proxy == "sample_level_hallmark_inflammatory_proxy" ~ "Hallmark Inflam.",
      severity_proxy == "sample_level_hallmark_inflammatory_plus_emt_proxy" ~ "Inflammatory + EMT",
      TRUE ~ severity_proxy
    ),
    proxy_label = factor(proxy_label, levels = c("Unadjusted", "7-gene Inflam.", "Hallmark Inflam.", "Inflammatory + EMT")),
    dataset_label = factor(dataset_id, levels = c("GSE12251", "GSE16879", "GSE23597"), labels = c("Discovery", "Replication", "Cohort 3"))
  )

p5a <- ggplot(fig5_spec, aes(x = proxy_label, y = adjusted_effect, group = 1)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = col_annotation, linewidth = 0.3) +
  geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper), fill = col_r_light, alpha = 0.3) +
  geom_line(colour = col_neutral, linewidth = 0.4) +
  geom_point(size = 1.5, shape = 21, fill = "white", colour = col_neutral, stroke = 0.5) +
  facet_wrap(~ dataset_label, ncol = 3) +
  labs(title = "A. Stability of association under background adjustment", subtitle = "Attenuation of the nonresponse axis relative to baseline inflammation", x = "Adjustment Strategy", y = "Adjusted Effect Size") +
  theme_pub + theme(axis.text.x = element_text(size = 5.5, angle = 30, hjust = 1))

strict_proxy_label <- "Inflammatory + EMT"
cmp_spec <- fig5_spec %>% filter(proxy_label %in% c("Unadjusted", strict_proxy_label)) %>%
  select(dataset_label, proxy_label, adjusted_effect) %>%
  pivot_wider(names_from = proxy_label, values_from = adjusted_effect) %>%
  rename(unadj = Unadjusted, adj = `Inflammatory + EMT`)

p5b <- ggplot(cmp_spec, aes(x = unadj, y = adj)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dotted", colour = col_annotation) +
  geom_point(size = 2.5, shape = 21, fill = col_nr_light, colour = col_nonresponder, stroke = 0.5) +
  geom_text_repel(aes(label = dataset_label), size = 2, family = font_family) +
  labs(title = "B. Residual Signal Stability", subtitle = "Unadjusted vs. Strictest adjustment", x = "Unadjusted Effect Size", y = "Adjusted Effect Size") +
  theme_pub

p5 <- plot_grid(p5a, p5b, ncol = 2, rel_widths = c(1.3, 0.8), align = "h", axis = "tb")
save_fig(p5, "Figure5_specificity", 7.5, 4.0)

cat("[pub-figs] Figures 2-5 written to:", out_dir, "\n")
