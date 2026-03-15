#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/reproduce_one_click.sh              # regenerate Figures 2-5 from included results tables
  bash scripts/reproduce_one_click.sh --from-public-data

Notes:
  - Figure 1 is provided as a fixed schematic under plots/publication/ and is not regenerated.
  - The --from-public-data mode downloads GEO series matrices and recomputes derived tables under results/.
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

  echo "[step] download GEO series matrices (core cohorts)"
  bash scripts/download_geo_matrices.sh core

  echo "[step] extract sample metadata"
  mkdir -p data/processed/geo_sample_metadata
  for ACC in GSE12251 GSE16879 GSE23597; do
    python3 scripts/extract_geo_sample_metadata.py \
      "data/raw/geo/matrix/${ACC}_series_matrix.txt.gz" \
      "data/processed/geo_sample_metadata/${ACC}_samples.tsv"
  done

  echo "[step] build harmonized core cohorts"
  python3 scripts/build_core_uc_cohorts.py

  echo "[step] bulk DE (limma)"
  Rscript scripts/run_limma_core_bulk.R

  echo "[step] probe-to-gene annotation (GPL570)"
  Rscript scripts/annotate_deg_gpl570.R

  echo "[step] pathway analysis (Hallmark fGSEA)"
  Rscript scripts/run_hallmark_fgsea.R

  echo "[step] module scoring (strict + LODO)"
  python3 scripts/compute_module_scores.py

  echo "[step] specificity checks"
  Rscript scripts/run_specificity_checks.R

  echo "[step] summarize effect sizes and figure anchor tables"
  python3 scripts/summarize_module_effects.py
  python3 scripts/summarize_core_geo_cohorts.py
fi

echo "[step] render publication figures (Figures 2-5)"
Rscript scripts/make_publication_figures.R

echo "[ok] plots written under plots/publication/"
