# Statistical Decision Rules (Predeclared)

This document records key thresholds and modeling conventions used by the scripts in this reproducibility package.

## Differential expression (bulk microarray)

- Per-cohort differential expression is computed with `limma` (empirical Bayes moderation).
- Multiple testing adjustment is Benjamini-Hochberg (BH) as reported by `limma` (`adj.P.Val`).

## Pathway analysis (Hallmark fGSEA)

- Hallmark gene sets are tested using `fgsea`.
- Reported false discovery rates (FDR) are BH-adjusted within the Hallmark collection.
- A pathway is treated as significant if FDR < 0.05.

## Consensus gene module and LODO axis

- A 63-gene cross-cohort consensus module is defined as genes that are directionally higher in nonresponders and meet nominal P < 0.05 in all three bulk cohorts (see `results/deg/gene_direction_filtered.tsv`).
- The leave-one-dataset-out (LODO) axis is computed by defining a gene set using only the two training cohorts for each held-out cohort (nominal P < 0.05 in both training cohorts; direction higher in nonresponders), then scoring the held-out samples using that gene set.

## Effect sizes and meta-analysis

- Group differences are summarized using Hedges' g (nonresponder minus responder), with small-sample correction.
- Standard errors follow the conventional Hedges' g large-sample approximation implemented in `scripts/summarize_module_effects.py`.
- 95% confidence intervals are computed as effect +/- 1.96 * SE.
- P-values for per-cohort and pooled effects use a normal approximation (two-sided).
- Pooled effects use an inverse-variance random-effects model with tau^2 estimated by the DerSimonian-Laird method and heterogeneity summarized by I^2.

## Specificity checks (proxy adjustment)

- Proxy-adjusted effects are computed in `scripts/run_specificity_checks.R`.
- The primary display uses the unadjusted effect ("none") and progressively stricter adjustments (inflammation proxy; Hallmark inflammation; Hallmark inflammation + EMT proxy), as recorded in `results/figures/fig5_specificity_summary.tsv`.

