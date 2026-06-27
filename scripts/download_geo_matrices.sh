#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/data/raw/geo/matrix"

mkdir -p "${OUT_DIR}"

MODE="${1:-core}"

download_one() {
  local accession="$1"
  local prefix="$2"
  local url="https://ftp.ncbi.nlm.nih.gov/geo/series/${prefix}/${accession}/matrix/${accession}_series_matrix.txt.gz"
  local out="${OUT_DIR}/${accession}_series_matrix.txt.gz"

  echo "[download] ${accession}"
  curl -fL -C - \
    --retry 10 \
    --retry-delay 2 \
    --retry-all-errors \
    "${url}" -o "${out}"
  echo "[ok] ${out}"
}

download_core() {
  download_one "GSE12251" "GSE12nnn"
  download_one "GSE16879" "GSE16nnn"
  download_one "GSE23597" "GSE23nnn"
}

download_extended() {
  download_core
  download_one "GSE92415" "GSE92nnn"
  download_one "GSE73661" "GSE73nnn"
}

case "${MODE}" in
  core)
    download_core
    ;;
  extended)
    download_extended
    ;;
  *)
    echo "Usage: $0 [core|extended]" >&2
    exit 1
    ;;
esac
