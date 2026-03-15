#!/usr/bin/env python3
import csv
import gzip
from collections import Counter, defaultdict
from pathlib import Path

import numpy as np


ROOT = Path(__file__).resolve().parents[1]
REF_DIR = ROOT / "data" / "raw" / "geo" / "singlecell_ref"
MODULE_PATH = ROOT / "results" / "scores" / "strict_nonresponse_module_genes.txt"
OUT_DIR = ROOT / "results" / "singlecell"
FIG_DIR = ROOT / "results" / "figures"

GENE_PATH = REF_DIR / "GSE125527_gene_id_rownames.csv.gz"
CELL_PATH = REF_DIR / "GSE125527_cell_id_colnames.csv.gz"
META_PATH = REF_DIR / "GSE125527_cell_metadata.csv.gz"
SPARSE_PATH = REF_DIR / "GSE125527_UMI_cell_table_sparse.csv.gz"


def read_module_genes():
    with MODULE_PATH.open("r", encoding="utf-8") as handle:
        return [line.strip() for line in handle if line.strip()]


def read_lines_gz(path: Path):
    with gzip.open(path, "rt", encoding="utf-8", errors="replace") as handle:
        return [line.rstrip("\n") for line in handle if line.strip()]


def read_metadata():
    rows = []
    with gzip.open(META_PATH, "rt", encoding="utf-8", errors="replace") as handle:
        reader = csv.reader(handle)
        header = next(reader)
        for row in reader:
            if len(row) == len(header) + 1:
                row = row[1:]
            if len(row) != len(header):
                raise ValueError(f"Unexpected metadata row length: {len(row)}")
            rows.append(dict(zip(header, row)))
    return rows


def detect_index_offset(path: Path, n_lines=1000):
    min_gene = None
    min_cell = None
    with gzip.open(path, "rt", encoding="utf-8", errors="replace") as handle:
        for i, raw in enumerate(handle):
            raw = raw.strip()
            if not raw:
                continue
            parts = raw.split(",")
            if len(parts) < 3:
                parts = raw.split()
            if len(parts) < 3:
                continue
            try:
                gene_idx = int(parts[0])
                cell_idx = int(parts[1])
            except ValueError:
                continue
            min_gene = gene_idx if min_gene is None else min(min_gene, gene_idx)
            min_cell = cell_idx if min_cell is None else min(min_cell, cell_idx)
            if i >= n_lines:
                break
    if min_gene is None or min_cell is None:
        raise ValueError("Could not detect sparse index base.")
    if min_gene == 0 or min_cell == 0:
        return 0
    return 1


def normalize_log1p_cpm(count_matrix, total_counts):
    denom = np.where(total_counts > 0, total_counts, 1.0)
    return np.log1p((count_matrix / denom) * 1e4)


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    FIG_DIR.mkdir(parents=True, exist_ok=True)

    module_genes = read_module_genes()
    genes = read_lines_gz(GENE_PATH)
    cells = read_lines_gz(CELL_PATH)
    metadata = read_metadata()

    if len(cells) != len(metadata):
        raise ValueError(f"Cell metadata mismatch: {len(cells)} cell ids vs {len(metadata)} metadata rows")

    module_gene_to_row = {}
    for idx, gene in enumerate(genes):
        if gene in module_genes and gene not in module_gene_to_row:
            module_gene_to_row[gene] = idx

    module_present = [gene for gene in module_genes if gene in module_gene_to_row]
    if not module_present:
        raise ValueError("No module genes found in GSE125527 gene rows.")

    selected_cell_indices = []
    selected_cell_lookup = {}
    selected_meta = []
    for idx, row in enumerate(metadata):
        if row["tissue_assignment"] != "R":
            continue
        selected_cell_lookup[idx] = len(selected_cell_indices)
        selected_cell_indices.append(idx)
        selected_meta.append(row)

    total_counts = np.zeros(len(selected_cell_indices), dtype=np.float64)
    module_matrix = np.zeros((len(module_present), len(selected_cell_indices)), dtype=np.float32)
    module_gene_lookup = {module_gene_to_row[gene]: i for i, gene in enumerate(module_present)}

    index_offset = detect_index_offset(SPARSE_PATH)

    with gzip.open(SPARSE_PATH, "rt", encoding="utf-8", errors="replace") as handle:
        for raw in handle:
            raw = raw.strip()
            if not raw:
                continue
            parts = raw.split(",")
            if len(parts) < 3:
                parts = raw.split()
            if len(parts) < 3:
                continue
            try:
                gene_idx = int(parts[0]) - index_offset
                cell_idx = int(parts[1]) - index_offset
                count = float(parts[2])
            except ValueError:
                continue
            selected_pos = selected_cell_lookup.get(cell_idx)
            if selected_pos is None:
                continue
            total_counts[selected_pos] += count
            module_pos = module_gene_lookup.get(gene_idx)
            if module_pos is not None:
                module_matrix[module_pos, selected_pos] += count

    normalized_module = normalize_log1p_cpm(module_matrix, total_counts)
    per_cell_module_score = normalized_module.mean(axis=0)

    assignments_path = OUT_DIR / "GSE125527_rectal_immune_module_scores.tsv"
    with assignments_path.open("w", encoding="utf-8", newline="") as handle:
        fieldnames = ["cell_id", "patient_assignment", "tissue_assignment", "disease_assignment", "celltype", "module_score", "library_size"]
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter="\t")
        writer.writeheader()
        for i, row in enumerate(selected_meta):
            writer.writerow(
                {
                    "cell_id": cells[selected_cell_indices[i]],
                    "patient_assignment": row["patient_assignment"],
                    "tissue_assignment": row["tissue_assignment"],
                    "disease_assignment": row["disease_assignment"],
                    "celltype": row["celltype"],
                    "module_score": per_cell_module_score[i],
                    "library_size": total_counts[i],
                }
            )

    summary_rows = []
    state_groups = defaultdict(list)
    for i, row in enumerate(selected_meta):
        key = (row["disease_assignment"], row["celltype"])
        state_groups[key].append(i)

    for (disease, celltype), idxs in sorted(state_groups.items()):
        idxs = np.array(idxs, dtype=int)
        top_gene_means = []
        for gene_i, gene in enumerate(module_present):
            top_gene_means.append((gene, float(np.mean(normalized_module[gene_i, idxs]))))
        top_gene_means.sort(key=lambda x: x[1], reverse=True)
        summary_rows.append(
            {
                "dataset_id": "GSE125527",
                "tissue_assignment": "R",
                "disease_assignment": disease,
                "cell_state": celltype,
                "enrichment_score": float(np.mean(per_cell_module_score[idxs])),
                "median_module_score": float(np.median(per_cell_module_score[idxs])),
                "n_cells": int(len(idxs)),
                "present_module_genes": len(module_present),
                "supporting_genes": "|".join(g for g, _ in top_gene_means[:5]),
                "interpretation": "rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata",
            }
        )

    summary_rows.sort(key=lambda row: (row["disease_assignment"], -row["enrichment_score"]))
    fig_path = FIG_DIR / "fig4b_immune_localization.tsv"
    with fig_path.open("w", encoding="utf-8", newline="") as handle:
        fieldnames = ["dataset_id", "tissue_assignment", "disease_assignment", "cell_state", "enrichment_score", "median_module_score", "n_cells", "present_module_genes", "supporting_genes", "interpretation"]
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter="\t")
        writer.writeheader()
        writer.writerows(summary_rows)

    disease_summary = Counter(row["disease_assignment"] for row in selected_meta)
    celltype_summary = Counter(row["celltype"] for row in selected_meta)
    print(f"[ok] wrote {assignments_path}")
    print(f"[ok] wrote {fig_path}")
    print(f"[ok] rectal_cells={len(selected_meta)} disease_breakdown={dict(disease_summary)} celltypes={dict(celltype_summary)} module_genes_present={len(module_present)}")


if __name__ == "__main__":
    main()
