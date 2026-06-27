#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ggplot2)
  library(grid)
})

arg_file <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(arg_file) > 0) {
  script_path <- normalizePath(sub("^--file=", "", arg_file[1]))
  root_dir <- normalizePath(file.path(dirname(script_path), ".."))
} else {
  root_dir <- getwd()
}

out_dir <- file.path(root_dir, "plots", "publication")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

stem <- file.path(out_dir, "Figure1_study_design")

font_family <- "Helvetica"

# Palette aligned to main figures (responder vs nonresponder)
col_nonresponder <- "#B2182B"
col_responder <- "#2166AC"
col_panel_bg <- "#F3F4F6"
col_box_bg <- "#FFFFFF"
col_box_border <- "#8A8A8A"
col_text <- "#1A1A1A"
col_muted <- "#525252"
col_chip_bg <- "#E8EEF6"
col_chip_bg2 <- "#EDE7F6"
col_chip_border <- "#C8D3E6"
col_chip_border2 <- "#D3CAE6"

theme_fig <- theme_void(base_family = font_family) +
  theme(
    plot.background = element_rect(fill = "white", colour = NA),
    panel.background = element_rect(fill = "white", colour = NA),
    text = element_text(colour = col_text)
  )

rect <- function(xmin, xmax, ymin, ymax, fill = col_box_bg, colour = col_box_border, lw = 0.35, r = 0) {
  annotate("rect", xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fill, colour = colour, linewidth = lw)
}

label <- function(x, y, text, size = 3.1, face = "plain", colour = col_text, hjust = 0.5, vjust = 0.5) {
  annotate("text", x = x, y = y, label = text, size = size, family = font_family, fontface = face, colour = colour, hjust = hjust, vjust = vjust)
}

chip <- function(x, y, text, w = 1.55, h = 0.35, fill = col_chip_bg, border = col_chip_border, size = 2.4) {
  rect(x - w / 2, x + w / 2, y - h / 2, y + h / 2, fill = fill, colour = border, lw = 0.25)
  label(x, y, text, size = size, colour = col_muted)
}

arrow_seg <- function(x, y, xend, yend, col = col_muted, lw = 0.35) {
  annotate(
    "segment",
    x = x, y = y, xend = xend, yend = yend,
    colour = col, linewidth = lw,
    arrow = arrow(type = "closed", length = unit(0.12, "cm"))
  )
}

p <- ggplot() +
  coord_cartesian(xlim = c(0, 10.4), ylim = c(0, 7), expand = FALSE, clip = "off") +
  theme_fig +
  # Title
  label(5, 6.75, "Integrated study overview and working model", size = 4.0, face = "bold") +
  # Panel backgrounds
  rect(0.3, 6.7, 0.55, 6.35, fill = col_panel_bg, colour = NA) +
  rect(7.0, 9.7, 0.55, 6.35, fill = col_panel_bg, colour = NA) +
  label(0.45, 6.15, "A", size = 4.0, face = "bold", hjust = 0) +
  label(0.85, 6.15, "Study design and evidence framework", size = 3.2, face = "bold", hjust = 0) +
  label(7.15, 6.15, "B", size = 4.0, face = "bold", hjust = 0) +
  label(7.55, 6.15, "Working model", size = 3.2, face = "bold", hjust = 0) +
  # Cohort row
  rect(0.7, 6.3, 5.35, 5.95, lw = 0.30) +
  rect(0.85, 2.55, 5.45, 5.85, fill = "#FAFAFA", lw = 0.25) +
  rect(2.70, 4.40, 5.45, 5.85, fill = "#FAFAFA", lw = 0.25) +
  rect(4.55, 6.25, 5.45, 5.85, fill = "#FAFAFA", lw = 0.25) +
  label(1.70, 5.67, "Discovery:\nGSE12251\n(n=23)", size = 2.7, face = "bold") +
  label(3.55, 5.67, "Replication:\nGSE16879\n(n=24)", size = 2.7, face = "bold") +
  label(5.40, 5.67, "Cohort 3:\nGSE23597\n(n=32)", size = 2.7, face = "bold") +
  label(3.50, 5.22, "Pretreatment UC mucosal biopsies | infliximab | GPL570", size = 2.30, colour = col_muted) +
  # Consensus signature box
  rect(0.9, 6.1, 4.45, 5.10, lw = 0.30) +
  label(3.50, 4.90, "68-gene cross-cohort consensus signature", size = 3.1, face = "bold") +
  chip(2.25, 4.60, "Interpretability") +
  chip(3.55, 4.60, "Specificity") +
  chip(4.85, 4.60, "Localization") +
  # LODO box
  rect(0.9, 6.1, 3.55, 4.30, lw = 0.30) +
  label(2.65, 4.08, "Leave-one-dataset-out (LODO) axis", size = 3.1, face = "bold") +
  chip(1.65, 3.78, "Held-out scoring", w = 1.65, fill = col_chip_bg2, border = col_chip_border2) +
  chip(3.05, 3.78, "Leakage-free", w = 1.35, fill = col_chip_bg2, border = col_chip_border2) +
  rect(4.55, 6.05, 3.62, 4.18, fill = "#FFF7F3", colour = "#E6B8A6", lw = 0.25) +
  label(5.30, 3.90, "LODO pooled Hedges' g\n1.36 (95% CI 0.83-1.89)\np = 5.65e-7; I2 = 0%", size = 2.15, colour = col_nonresponder) +
  # Pathway convergence
  rect(0.9, 6.1, 2.35, 3.35, lw = 0.30) +
  label(3.50, 3.15, "Hallmark pathway convergence", size = 3.1, face = "bold") +
  chip(1.55, 2.83, "Inflammatory response", w = 2.2) +
  chip(3.50, 2.83, "TNF/NF-kB", w = 1.55) +
  chip(5.20, 2.83, "IL-6/JAK-STAT3", w = 1.95) +
  chip(2.25, 2.48, "Interferon", w = 1.3) +
  chip(3.55, 2.48, "Hypoxia", w = 1.1) +
  chip(4.75, 2.48, "EMT", w = 0.8) +
  label(3.50, 2.15, "Responders: Oxidative phosphorylation", size = 2.5, colour = col_responder) +
  # Specificity benchmarks
  rect(0.9, 6.1, 1.55, 2.25, lw = 0.30) +
  label(2.35, 2.05, "Specificity benchmarks", size = 3.0, face = "bold") +
  chip(4.00, 2.05, "7-gene inflam. proxy", w = 1.85) +
  chip(5.35, 2.05, "Hallmark inflam.", w = 1.55) +
  chip(5.05, 1.72, "Inflammatory + EMT", w = 2.05) +
  # Single-cell localization support
  rect(0.9, 6.1, 0.80, 1.40, lw = 0.30) +
  label(2.15, 1.20, "Public single-cell localization support", size = 2.85, face = "bold") +
  chip(4.10, 1.20, "GSE116222 (epithelial)", w = 1.95, size = 2.15) +
  chip(5.55, 1.20, "GSE125527 (rectal immune)", w = 2.10, size = 2.15) +
  # Flow arrows in panel A
  arrow_seg(3.50, 5.35, 3.50, 5.10, col = col_muted) +
  arrow_seg(3.50, 4.45, 3.50, 4.30, col = col_muted) +
  arrow_seg(3.50, 3.55, 3.50, 3.35, col = col_muted) +
  arrow_seg(3.50, 2.35, 3.50, 2.25, col = col_muted) +
  arrow_seg(3.50, 1.55, 3.50, 1.40, col = col_muted) +
  # Panel B boxes
  rect(7.3, 9.4, 4.55, 5.85, fill = "#FFF7F3", colour = "#E6B8A6", lw = 0.30) +
  label(8.35, 5.62, "Rectal myeloid/\ndendritic (M/DC)", size = 2.55, face = "bold", colour = col_nonresponder) +
  chip(8.05, 5.25, "TNF/NF-kB", w = 1.35, fill = "#FDE7DE", border = "#F2C7B3", size = 2.05) +
  chip(8.95, 5.25, "IL-6/JAK/STAT3", w = 1.6, fill = "#FDE7DE", border = "#F2C7B3", size = 2.2) +
  chip(8.10, 4.90, "Interferon", w = 1.1, fill = "#FDE7DE", border = "#F2C7B3", size = 2.2) +
  chip(8.95, 4.90, "Hypoxia", w = 0.9, fill = "#FDE7DE", border = "#F2C7B3", size = 2.2) +
  rect(7.3, 9.4, 1.55, 3.05, fill = "#F3FBF8", colour = "#A9D6C5", lw = 0.30) +
  label(8.35, 2.82, "Epithelial remodeling", size = 3.0, face = "bold", colour = "#2C6E55") +
  chip(7.95, 2.45, "Cycling/stem-like", w = 1.45, fill = "#D9F0E6", border = "#B5DCCB", size = 2.2) +
  chip(8.95, 2.45, "Stress state", w = 1.25, fill = "#D9F0E6", border = "#B5DCCB", size = 2.1) +
  chip(8.50, 2.10, "EMT/remodeling", w = 1.45, fill = "#D9F0E6", border = "#B5DCCB", size = 2.2) +
  # Central axis circle
  annotate("point", x = 8.35, y = 3.95, size = 20, shape = 21, fill = "white", colour = col_box_border, stroke = 0.35) +
  label(8.35, 3.95, "Pretreatment\nnonresponse\naxis", size = 2.7, face = "bold") +
  label(9.45, 3.95, "Association\n+ localization", size = 2.1, colour = col_muted, hjust = 0) +
  # Arrows from components to axis
  arrow_seg(8.35, 4.55, 8.35, 4.18, col = col_nonresponder, lw = 0.45) +
  arrow_seg(8.35, 3.05, 8.35, 3.72, col = "#2C6E55", lw = 0.45) +
  # Linking arrow from panel A to axis
  arrow_seg(6.10, 3.90, 7.80, 3.90, col = col_muted, lw = 0.40) +
  # Boundary note
  label(5.0, 0.25, "Boundary: association + localization (public data); no causality; no deployable clinical predictor.", size = 2.4, colour = col_muted)

ggsave(paste0(stem, ".png"), p, width = 8.2, height = 5.7, units = "in", dpi = 600, bg = "white")
ggsave(paste0(stem, ".pdf"), p, width = 8.2, height = 5.7, units = "in", device = cairo_pdf, bg = "white")

cat("[ok] wrote:", paste0(stem, ".{png,pdf}"), "\n")
