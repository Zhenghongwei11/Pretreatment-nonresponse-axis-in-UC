#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/reproduce_one_click.sh
  bash scripts/reproduce_one_click.sh --from-public-data

Default mode regenerates figures and supplementary-table renderings from included derived tables.
The --from-public-data mode downloads public GEO matrices and rebuilds the bulk analyses.
EOF
}

FROM_PUBLIC_DATA="no"
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi
if [[ "${1:-}" == "--from-public-data" ]]; then
  FROM_PUBLIC_DATA="yes"
fi

cd "${ROOT_DIR}"

if [[ "${FROM_PUBLIC_DATA}" == "yes" ]]; then
  echo "[check] R dependencies for full re-run"
  if ! Rscript -e 'stopifnot(requireNamespace("limma", quietly=TRUE)); stopifnot(requireNamespace("fgsea", quietly=TRUE)); stopifnot(requireNamespace("AnnotationDbi", quietly=TRUE)); stopifnot(requireNamespace("hgu133plus2.db", quietly=TRUE)); stopifnot(requireNamespace("msigdbr", quietly=TRUE))' >/dev/null 2>&1; then
    echo "[error] missing R dependencies for --from-public-data mode"
    echo "        run: Rscript scripts/install_r_deps.R --full"
    exit 1
  fi

  echo "[step] download GEO series matrices"
  bash scripts/download_geo_matrices.sh extended

  echo "[step] extract sample metadata"
  mkdir -p data/processed/geo_sample_metadata
  for ACC in GSE12251 GSE16879 GSE23597 GSE92415; do
    python3 scripts/extract_geo_sample_metadata.py \
      "data/raw/geo/matrix/${ACC}_series_matrix.txt.gz" \
      "data/processed/geo_sample_metadata/${ACC}_samples.tsv"
  done

  echo "[step] build harmonized core bulk cohorts"
  python3 scripts/build_core_uc_cohorts.py

  echo "[step] run core bulk differential expression"
  Rscript scripts/run_limma_core_bulk.R

  echo "[step] annotate core DEG tables"
  Rscript scripts/annotate_deg_gpl570.R

  echo "[step] run Hallmark enrichment"
  Rscript scripts/run_hallmark_fgsea.R

  echo "[step] compute module scores"
  python3 scripts/compute_module_scores.py

  echo "[step] run specificity checks"
  Rscript scripts/run_specificity_checks.R

  echo "[step] summarize core cohorts and figure tables"
  python3 scripts/summarize_module_effects.py
  python3 scripts/summarize_core_geo_cohorts.py

  echo "[step] build GSE92415 sensitivity cohort"
  python3 scripts/build_sensitivity_uc_cohorts.py
  Rscript scripts/run_limma_one_bulk.R \
    --dataset GSE92415 \
    --expr data/processed/sensitivity_bulk/GSE92415_expression.tsv \
    --pheno data/processed/sensitivity_bulk/GSE92415_phenotype.tsv \
    --out results/deg/GSE92415_deg.tsv
  Rscript scripts/annotate_deg_gpl570_one.R \
    --deg results/deg/GSE92415_deg.tsv \
    --out results/deg/GSE92415_deg_gene.tsv
  python3 scripts/score_signature_one_dataset.py \
    --dataset GSE92415 \
    --pheno data/processed/sensitivity_bulk/GSE92415_phenotype.tsv \
    --expr data/processed/sensitivity_bulk/GSE92415_expression.tsv \
    --deg_gene results/deg/GSE92415_deg_gene.tsv \
    --genes results/scores/strict_nonresponse_module_genes.txt \
    --out_scores results/sensitivity/GSE92415_signature_scores.tsv \
    --out_summary results/sensitivity/GSE92415_signature_effect.tsv

  echo "[step] render Supplementary Figure S2"
  Rscript scripts/make_supplementary_figureS2_confounding.R \
    plots/publication/FigureS2.png \
    plots/publication/FigureS2.pdf
fi

echo "[step] render Figure 1"
Rscript scripts/make_figure1_study_design.R

echo "[step] render Figures 2-5"
Rscript scripts/make_publication_figures.R

echo "[step] render Supplementary Figure S1"
Rscript scripts/make_gse92415_sensitivity_figure.R \
  results/sensitivity/GSE92415_signature_scores.tsv \
  plots/publication/FigureS1.png \
  plots/publication/FigureS1.pdf

echo "[step] refresh supplementary validation outputs and Supplementary Figure S3"
python3 scripts/build_supplementary_validation_support.py

echo "[step] refresh supplementary-table rendering"
python3 scripts/build_supplementary_tables_md.py --submission-dir .
mkdir -p docs
mv -f SUPPLEMENTARY_TABLES.md docs/SUPPLEMENTARY_TABLES.md

echo "[ok] reproducibility outputs written under plots/, results/, supplementary_tables/, and docs/"
