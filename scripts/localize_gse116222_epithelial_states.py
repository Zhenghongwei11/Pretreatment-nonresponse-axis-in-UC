#!/usr/bin/env python3
import csv
import gzip
import math
from pathlib import Path

import numpy as np


ROOT = Path(__file__).resolve().parents[1]
SC_PATH = ROOT / "data" / "raw" / "geo" / "singlecell" / "GSE116222_Expression_matrix.txt.gz"
MODULE_PATH = ROOT / "results" / "scores" / "strict_nonresponse_module_genes.txt"
OUT_DIR = ROOT / "results" / "singlecell"
FIG_DIR = ROOT / "results" / "figures"


STATE_MARKERS = {
    "best4_absorptive": ["BEST4", "OTOP2", "CA7", "GUCA2A", "GUCA2B", "AQP8", "SLC26A3"],
    "goblet_secretory": ["MUC2", "SPINK4", "CLCA1", "FCGBP", "ZG16", "BPIFB1"],
    "stem_ta": ["OLFM4", "LGR5", "SMOC2", "PROM1", "MYC", "SOX9"],
    "cycling": ["MKI67", "TOP2A", "CENPF", "BIRC5", "PCNA", "HMGB2"],
    "regenerative_notch": ["SOX4", "ELF3", "HES1", "TLE4", "KLF5", "EGR1"],
    "stress_inflammatory_epithelial": ["DUOX2", "DUOXA2", "LCN2", "REG1A", "REG1B", "CXCL1", "CXCL8"],
}


def read_module_genes():
    with MODULE_PATH.open("r", encoding="utf-8") as handle:
        return [line.strip() for line in handle if line.strip()]


def mean_or_nan(values):
    return float(np.mean(values)) if len(values) else float("nan")


def safe_log1p_cpm(counts, totals):
    denom = np.where(totals > 0, totals, 1.0)
    return np.log1p((counts / denom) * 1e4)


def top_supporting_genes(state_mask, normalized_by_gene, module_genes, top_n=5):
    gene_means = []
    for gene in module_genes:
        if gene not in normalized_by_gene:
            continue
        gene_means.append((gene, float(np.mean(normalized_by_gene[gene][state_mask]))))
    gene_means.sort(key=lambda x: x[1], reverse=True)
    return "|".join(g for g, _ in gene_means[:top_n])


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    FIG_DIR.mkdir(parents=True, exist_ok=True)

    module_genes = read_module_genes()
    marker_genes = sorted({g for genes in STATE_MARKERS.values() for g in genes})
    target_genes = set(module_genes) | set(marker_genes)

    selected_counts = {}
    with gzip.open(SC_PATH, "rt", encoding="utf-8", errors="replace") as handle:
        header = handle.readline().rstrip("\n").split("\t")
        cell_ids = header
        n_cells = len(cell_ids)
        total_counts = np.zeros(n_cells, dtype=np.float64)

        for raw_line in handle:
            raw_line = raw_line.rstrip("\n")
            if not raw_line:
                continue
            gene, values = raw_line.split("\t", 1)
            counts = np.fromstring(values, sep="\t", dtype=np.float32)
            if counts.size != n_cells:
                raise ValueError(f"Unexpected cell count for {gene}: {counts.size} vs {n_cells}")
            total_counts += counts
            if gene in target_genes:
                selected_counts[gene] = counts

    normalized_by_gene = {gene: safe_log1p_cpm(counts, total_counts) for gene, counts in selected_counts.items()}

    state_scores = {}
    for state, genes in STATE_MARKERS.items():
        present = [gene for gene in genes if gene in normalized_by_gene]
        if not present:
            state_scores[state] = np.zeros(len(cell_ids), dtype=np.float32)
            continue
        state_scores[state] = np.vstack([normalized_by_gene[gene] for gene in present]).mean(axis=0)

    module_present = [gene for gene in module_genes if gene in normalized_by_gene]
    if not module_present:
        raise ValueError("No strict module genes were found in GSE116222.")
    module_score = np.vstack([normalized_by_gene[gene] for gene in module_present]).mean(axis=0)

    state_names = list(STATE_MARKERS.keys())
    score_matrix = np.vstack([state_scores[state] for state in state_names]).T
    best_idx = score_matrix.argmax(axis=1)
    best_scores = score_matrix.max(axis=1)

    assigned_states = []
    for idx, score in zip(best_idx, best_scores):
        if math.isnan(score) or score <= 0:
            assigned_states.append("unassigned")
        else:
            assigned_states.append(state_names[idx])

    assignments_path = OUT_DIR / "GSE116222_epithelial_state_assignments.tsv"
    with assignments_path.open("w", encoding="utf-8", newline="") as handle:
        fieldnames = ["cell_id", "assigned_state", "module_score"] + [f"{state}_score" for state in state_names]
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter="\t")
        writer.writeheader()
        for i, cell_id in enumerate(cell_ids):
            row = {
                "cell_id": cell_id,
                "assigned_state": assigned_states[i],
                "module_score": module_score[i],
            }
            for state in state_names:
                row[f"{state}_score"] = state_scores[state][i]
            writer.writerow(row)

    summary_rows = []
    for state in sorted(set(assigned_states)):
        mask = np.array([x == state for x in assigned_states])
        state_cell_count = int(mask.sum())
        if state_cell_count == 0:
            continue
        summary_rows.append(
            {
                "cell_state": state,
                "enrichment_score": mean_or_nan(module_score[mask]),
                "median_module_score": float(np.median(module_score[mask])),
                "n_cells": state_cell_count,
                "supporting_genes": top_supporting_genes(mask, normalized_by_gene, module_present),
                "present_module_genes": len(module_present),
                "interpretation": "marker-based coarse epithelial state assignment from deposited expression matrix",
            }
        )

    summary_rows.sort(key=lambda row: row["enrichment_score"], reverse=True)
    fig4_path = FIG_DIR / "fig4_cellstate_localization.tsv"
    with fig4_path.open("w", encoding="utf-8", newline="") as handle:
        fieldnames = ["cell_state", "enrichment_score", "median_module_score", "n_cells", "present_module_genes", "supporting_genes", "interpretation"]
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter="\t")
        writer.writeheader()
        writer.writerows(summary_rows)

    marker_path = OUT_DIR / "GSE116222_marker_panel_presence.tsv"
    with marker_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["state", "present_markers", "n_present_markers"], delimiter="\t")
        writer.writeheader()
        for state, genes in STATE_MARKERS.items():
            present = [gene for gene in genes if gene in normalized_by_gene]
            writer.writerow(
                {
                    "state": state,
                    "present_markers": "|".join(present),
                    "n_present_markers": len(present),
                }
            )

    print(f"[ok] wrote {assignments_path}")
    print(f"[ok] wrote {fig4_path}")
    print(f"[ok] wrote {marker_path}")
    print(f"[ok] cells={len(cell_ids)} genes_in_matrix={len(selected_counts)} module_genes_present={len(module_present)}")


if __name__ == "__main__":
    main()
