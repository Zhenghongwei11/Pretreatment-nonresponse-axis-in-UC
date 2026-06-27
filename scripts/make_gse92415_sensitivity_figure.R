#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ggplot2)
})

args <- commandArgs(trailingOnly = TRUE)
in_path <- if (length(args) >= 1) args[[1]] else "results/sensitivity/GSE92415_signature_scores.tsv"
out_png <- if (length(args) >= 2) args[[2]] else "plots/publication/FigureS1_gse92415_sensitivity.png"
out_pdf <- if (length(args) >= 3) args[[3]] else "plots/publication/FigureS1_gse92415_sensitivity.pdf"

dat <- read.delim(in_path, stringsAsFactors = FALSE, check.names = FALSE)
dat$signature_score <- as.numeric(dat$signature_score)
dat$response_binary <- factor(dat$response_binary, levels = c("responder", "nonresponder"))

dat <- dat[!is.na(dat$signature_score) & !is.na(dat$response_binary), ]
if (nrow(dat) == 0) stop("No rows available after filtering.")

resp <- dat$signature_score[dat$response_binary == "responder"]
nonresp <- dat$signature_score[dat$response_binary == "nonresponder"]

welch <- t.test(nonresp, resp, var.equal = FALSE)

hedges_g <- function(x, y) {
  x <- x[!is.na(x)]
  y <- y[!is.na(y)]
  n1 <- length(x)
  n2 <- length(y)
  if (n1 < 2 || n2 < 2) return(NA_real_)
  m1 <- mean(x)
  m2 <- mean(y)
  s1 <- var(x)
  s2 <- var(y)
  sp <- sqrt(((n1 - 1) * s1 + (n2 - 1) * s2) / (n1 + n2 - 2))
  if (sp == 0) return(NA_real_)
  d <- (m1 - m2) / sp
  j <- 1 - (3 / (4 * (n1 + n2) - 9))
  j * d
}

g <- hedges_g(nonresp, resp)
n_r <- sum(dat$response_binary == "responder")
n_nr <- sum(dat$response_binary == "nonresponder")

label <- sprintf("Hedges' g = %.2f; Welch p = %.3g\nResponder n=%d; Nonresponder n=%d", g, welch$p.value, n_r, n_nr)

dat$group <- ifelse(dat$response_binary == "responder", "Responder", "Nonresponder")
dat$group <- factor(dat$group, levels = c("Responder", "Nonresponder"))

p <- ggplot(dat, aes(x = group, y = signature_score, fill = group)) +
  geom_boxplot(width = 0.55, outlier.shape = NA, alpha = 0.75) +
  geom_jitter(width = 0.14, size = 1.4, alpha = 0.65, color = "#1f2937") +
  scale_fill_manual(values = c("Responder" = "#93c5fd", "Nonresponder" = "#fecaca")) +
  labs(
    title = "Supplementary Figure S1. Class-level anti-TNF sensitivity in GSE92415",
    subtitle = "Pretreatment UC mucosal biopsies; response assessed at week 6",
    x = NULL,
    y = "68-gene consensus signature score"
  ) +
  annotate("text", x = 1.5, y = max(dat$signature_score, na.rm = TRUE) + 0.25, label = label, size = 3.6) +
  theme_bw(base_size = 12) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  ) +
  coord_cartesian(clip = "off")

dir.create(dirname(out_png), recursive = TRUE, showWarnings = FALSE)
ggsave(out_png, p, width = 8.1, height = 5.0, dpi = 300)
ggsave(out_pdf, p, width = 8.1, height = 5.0)

message("[ok] wrote ", out_png)
message("[ok] wrote ", out_pdf)
