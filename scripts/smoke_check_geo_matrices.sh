#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/data/raw/geo/matrix"

for accession in GSE12251 GSE16879 GSE23597; do
  file="${OUT_DIR}/${accession}_series_matrix.txt.gz"
  if [[ ! -f "${file}" ]]; then
    echo "[missing] ${file}" >&2
    exit 1
  fi

  echo "=== ${accession} ==="
  ls -lh "${file}"
  gzip -cd "${file}" | sed -n '1,12p'
done
