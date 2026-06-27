#!/usr/bin/env python3
import argparse
import csv
import math
from pathlib import Path

import numpy as np
from scipy import stats


def read_tsv_dict(path: Path):
    with path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle, delimiter="\t"))


def load_expression(path: Path):
    with path.open("r", encoding="utf-8", newline="") as handle:
        reader = csv.reader(handle, delimiter="\t")
        header = next(reader)
        sample_ids = header[1:]
        probes = []
        mat = []
        for row in reader:
            probes.append(row[0])
            mat.append([float(x) if x != "" else math.nan for x in row[1:]])
    return sample_ids, probes, np.array(mat, dtype=float)


def zscore_rows(mat: np.ndarray):
    # z-score each row across columns, ignoring NaN
    out = np.full_like(mat, np.nan, dtype=float)
    for i in range(mat.shape[0]):
        row = mat[i, :]
        mask = ~np.isnan(row)
        vals = row[mask]
        if vals.size == 0:
            continue
        mean = float(np.mean(vals))
        sd = float(np.std(vals, ddof=1)) if vals.size > 1 else 1.0
        if sd == 0:
            sd = 1.0
        out[i, mask] = (row[mask] - mean) / sd
    return out


def hedges_g(x, y):
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    x = x[~np.isnan(x)]
    y = y[~np.isnan(y)]
    n1 = x.size
    n2 = y.size
    if n1 < 2 or n2 < 2:
        return None
    m1 = float(np.mean(x))
    m2 = float(np.mean(y))
    s1 = float(np.var(x, ddof=1))
    s2 = float(np.var(y, ddof=1))
    sp = math.sqrt(((n1 - 1) * s1 + (n2 - 1) * s2) / (n1 + n2 - 2))
    if sp == 0:
        return None
    d = (m1 - m2) / sp
    j = 1.0 - (3.0 / (4.0 * (n1 + n2) - 9.0))
    g = j * d
    var_g = (n1 + n2) / (n1 * n2) + (g**2) / (2.0 * (n1 + n2 - 2.0))
    se = math.sqrt(var_g)
    ci_low = g - 1.96 * se
    ci_high = g + 1.96 * se
    return {
        "n_nonresponders": n1,
        "n_responders": n2,
        "mean_nonresponders": m1,
        "mean_responders": m2,
        "hedges_g": g,
        "ci_low": ci_low,
        "ci_high": ci_high,
        "se": se,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dataset", required=True)
    ap.add_argument("--pheno", type=Path, required=True)
    ap.add_argument("--expr", type=Path, required=True)
    ap.add_argument("--deg_gene", type=Path, required=True)
    ap.add_argument("--genes", type=Path, required=True, help="one gene symbol per line")
    ap.add_argument("--out_scores", type=Path, required=True)
    ap.add_argument("--out_summary", type=Path, required=True)
    args = ap.parse_args()

    genes = [g.strip() for g in args.genes.read_text(encoding="utf-8").splitlines() if g.strip()]
    pheno = read_tsv_dict(args.pheno)
    pheno_by_sample = {r["geo_accession"]: r for r in pheno}

    deg_gene = read_tsv_dict(args.deg_gene)
    gene_to_probe = {}
    for r in deg_gene:
        symbol = r.get("SYMBOL", "")
        probe = r.get("ID_REF", "")
        if symbol and probe and symbol not in gene_to_probe:
            gene_to_probe[symbol] = probe

    sample_ids, probes, mat = load_expression(args.expr)
    probe_to_idx = {p: i for i, p in enumerate(probes)}

    used = []
    idxs = []
    for g in genes:
        probe = gene_to_probe.get(g)
        if probe and probe in probe_to_idx:
            used.append(g)
            idxs.append(probe_to_idx[probe])

    if not used:
        raise SystemExit("No signature genes could be mapped to probes in this dataset.")

    sub = mat[np.array(idxs, dtype=int), :]
    z = zscore_rows(sub)
    scores = np.nanmean(z, axis=0)

    rows = []
    for sid, score in zip(sample_ids, scores, strict=True):
        p = pheno_by_sample.get(sid)
        if p is None:
            raise SystemExit(f"Sample {sid} not found in phenotype table.")
        rows.append(
            {
                "dataset_id": args.dataset,
                "geo_accession": sid,
                "response_binary": p["response_binary"],
                "therapy": p.get("therapy", ""),
                "timepoint": p.get("timepoint", ""),
                "signature_score": float(score) if not math.isnan(float(score)) else "",
                "n_genes_used": len(used),
            }
        )

    args.out_scores.parent.mkdir(parents=True, exist_ok=True)
    with args.out_scores.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), delimiter="\t")
        writer.writeheader()
        writer.writerows(rows)

    nonresp = [r for r in rows if r["response_binary"] == "nonresponder"]
    resp = [r for r in rows if r["response_binary"] == "responder"]
    x = np.array([float(r["signature_score"]) for r in nonresp], dtype=float)
    y = np.array([float(r["signature_score"]) for r in resp], dtype=float)

    eff = hedges_g(x, y)
    if eff is None:
        raise SystemExit("Could not compute effect size (insufficient variance or sample size).")

    t_stat, p_value = stats.ttest_ind(x, y, equal_var=False, nan_policy="omit")
    direction = "higher_in_nonresponders" if eff["mean_nonresponders"] > eff["mean_responders"] else "higher_in_responders"

    summary = {
        "dataset_id": args.dataset,
        "therapy": rows[0].get("therapy", ""),
        "timepoint": rows[0].get("timepoint", ""),
        "n_total": len(rows),
        "n_responders": eff["n_responders"],
        "n_nonresponders": eff["n_nonresponders"],
        "signature_name": args.genes.name,
        "n_genes_used": len(used),
        "direction": direction,
        "hedges_g_nonresponder_minus_responder": eff["hedges_g"],
        "ci_low": eff["ci_low"],
        "ci_high": eff["ci_high"],
        "p_value_welch_t": float(p_value),
    }

    args.out_summary.parent.mkdir(parents=True, exist_ok=True)
    with args.out_summary.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(summary.keys()), delimiter="\t")
        writer.writeheader()
        writer.writerow(summary)

    print(f"[ok] wrote scores to {args.out_scores}")
    print(f"[ok] wrote summary to {args.out_summary}")


if __name__ == "__main__":
    main()

