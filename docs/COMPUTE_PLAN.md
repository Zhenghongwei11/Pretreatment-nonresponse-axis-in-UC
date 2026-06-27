# Compute Plan

The release supports two reproducibility modes.

Quickstart mode starts from included derived tables and regenerates the main publication figures, Supplementary Figures S1 and S3, Table S7, and the rendered supplementary-table markdown. This mode is suitable for a laptop and avoids downloading raw matrices.

Full public-data mode downloads public GEO series matrices for the bulk cohorts, rebuilds harmonized phenotype and expression tables, reruns bulk differential expression, module scoring, Hallmark enrichment, specificity checks, and the GSE92415 sensitivity analysis, then regenerates the figures and table rendering.

Expected local outputs:

- `data/raw/geo/matrix/`: downloaded GEO series matrices in full mode
- `data/processed/`: harmonized expression and phenotype intermediates in full mode
- `results/`: derived analysis tables
- `plots/publication/`: figure exports
- `supplementary_tables/`: supplementary XLSX outputs
- `docs/SUPPLEMENTARY_TABLES.md`: readable supplementary-table rendering

The raw and processed data directories are excluded from version control because they can be regenerated from public sources.
