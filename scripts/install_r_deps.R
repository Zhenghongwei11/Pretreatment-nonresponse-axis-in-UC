#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) > 0) args[1] else "--figures-only"

options(repos = c(CRAN = "https://cloud.r-project.org"))

cran_figures <- c(
  "cowplot", "ggplot2", "gridExtra", "ggtext", "readr",
  "dplyr", "stringr", "tidyr", "scales", "ggrepel"
)

cran_full_extra <- c("msigdbr")
bioc_full <- c("limma", "fgsea", "AnnotationDbi", "hgu133plus2.db")

install_cran <- function(pkgs) {
  need <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(need) == 0) return(invisible(NULL))
  install.packages(need)
}

install_bioc <- function(pkgs) {
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  BiocManager::install(pkgs, ask = FALSE, update = FALSE)
}

if (mode %in% c("--help", "-h")) {
  cat("Usage:\n")
  cat("  Rscript scripts/install_r_deps.R --figures-only\n")
  cat("  Rscript scripts/install_r_deps.R --full\n")
  quit(status = 0)
}

cat("[mode] ", mode, "\n", sep = "")

cat("[step] install CRAN packages for figure regeneration\n")
install_cran(cran_figures)

if (mode == "--full") {
  cat("[step] install additional packages for full bulk re-run\n")
  install_cran(cran_full_extra)
  cat("[note] Bioconductor annotation packages can be large; installation may take time.\n")
  install_bioc(bioc_full)
} else if (mode != "--figures-only") {
  stop("Unknown mode: ", mode, call. = FALSE)
}

cat("[ok] R dependencies installed\n")
cat("\n[sessionInfo]\n")
print(sessionInfo())

