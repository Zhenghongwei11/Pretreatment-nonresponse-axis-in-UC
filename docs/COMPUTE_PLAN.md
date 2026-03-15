# Compute Plan

## What you can reproduce on a typical laptop

- Regenerating Figures 2–5 from the included `results/` tables:
  - Expected runtime: a few minutes (primarily R plotting)
  - Disk: < 1 GB (this package includes derived results tables and exported figures)

## Optional full re-run from public bulk GEO series matrices

The full bulk pipeline downloads three GEO series matrices (GSE12251, GSE16879, GSE23597), rebuilds the processed cohort matrices, and recomputes derived results under `results/`.

- Expected runtime: tens of minutes (depending on download speed and R package installation)
- Disk: several GB (downloaded raw matrices under `data/raw/`)

Entry point:
```bash
bash scripts/reproduce_one_click.sh --from-public-data
```

Dependencies:
- Minimal plotting dependencies can be installed via `Rscript scripts/install_r_deps.R --figures-only`.
- The full bulk re-run requires additional Bioconductor dependencies; install via `Rscript scripts/install_r_deps.R --full`.

## Single-cell localization

This release includes the single-cell localization outputs as derived anchor tables under `results/` so manuscript figures can be regenerated without downloading large single-cell references. Recomputing the single-cell mapping is optional and is not required for the core reproduction path.
