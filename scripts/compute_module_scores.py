#!/usr/bin/env python3
import csv
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CORE_DIR = ROOT / "data" / "processed" / "core_bulk"
DEG_DIR = ROOT / "results" / "deg"
OUT_DIR = ROOT / "results" / "scores"


def read_tsv(path: Path):
    with path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle, delimiter="\t"))


def load_expression(path: Path):
    with path.open("r", encoding="utf-8", newline="") as handle:
        reader = csv.reader(handle, delimiter="\t")
        header = next(reader)
        sample_ids = header[1:]
        matrix = {}
        for row in reader:
            probe = row[0]
            vals = [float(x) if x != "" else math.nan for x in row[1:]]
            matrix[probe] = vals
    return sample_ids, matrix


def zscore(values):
    vals = [v for v in values if not math.isnan(v)]
    mean = sum(vals) / len(vals)
    var = sum((v - mean) ** 2 for v in vals) / max(len(vals) - 1, 1)
    sd = math.sqrt(var) if var > 0 else 1.0
    return [(v - mean) / sd if not math.isnan(v) else math.nan for v in values]


def mean_ignore_nan(values):
    vals = [v for v in values if not math.isnan(v)]
    return sum(vals) / len(vals) if vals else math.nan


def load_strict_module():
    path = DEG_DIR / "gene_direction_filtered.tsv"
    genes = []
    with path.open("r", encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for row in reader:
            if (
                row["GSE12251_direction"] == "up_in_nonresponders"
                and row["GSE16879_direction"] == "up_in_nonresponders"
                and row["GSE23597_direction"] == "up_in_nonresponders"
                and int(row["nominal_p_lt_0_05_cohorts"]) == 3
            ):
                genes.append(row["SYMBOL"])
    return sorted(set(genes))


def load_lodo_module(holdout_dataset_id: str):
    """
    Leave-one-dataset-out (LODO) module:
    - Uses only the other two bulk cohorts to define the gene set.
    - Strict rule: gene is up_in_nonresponders and nominal p<0.05 in BOTH training cohorts.
    This avoids leaking the held-out dataset into module construction.
    """
    all_datasets = ["GSE12251", "GSE16879", "GSE23597"]
    if holdout_dataset_id not in all_datasets:
        raise ValueError(f"Unknown holdout dataset: {holdout_dataset_id}")
    training = [d for d in all_datasets if d != holdout_dataset_id]

    path = DEG_DIR / "gene_direction_filtered.tsv"
    genes = []
    with path.open("r", encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for row in reader:
            symbol = row.get("SYMBOL", "")
            if not symbol:
                continue

            ok = True
            for acc in training:
                if row[f"{acc}_direction"] != "up_in_nonresponders":
                    ok = False
                    break
                try:
                    if float(row[f"{acc}_PValue"]) >= 0.05:
                        ok = False
                        break
                except ValueError:
                    ok = False
                    break
            if ok:
                genes.append(symbol)
    return sorted(set(genes))


def load_gene_probe_map(gene_deg_path: Path):
    mapping = {}
    with gene_deg_path.open("r", encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for row in reader:
            symbol = row["SYMBOL"]
            probe = row["ID_REF"]
            if symbol and symbol not in mapping:
                mapping[symbol] = probe
    return mapping


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    module_genes = load_strict_module()
    module_path = OUT_DIR / "strict_nonresponse_module_genes.txt"
    module_path.write_text("\n".join(module_genes) + "\n", encoding="utf-8")

    lodo_dir = OUT_DIR / "lodo_modules"
    lodo_dir.mkdir(parents=True, exist_ok=True)
    lodo_modules = {}
    for holdout in ["GSE12251", "GSE16879", "GSE23597"]:
        genes = load_lodo_module(holdout)
        lodo_modules[holdout] = genes
        (lodo_dir / f"lodo_excluding_{holdout}_genes.txt").write_text("\n".join(genes) + "\n", encoding="utf-8")

    summary_rows = []

    for acc in ["GSE12251", "GSE16879", "GSE23597"]:
        pheno = read_tsv(CORE_DIR / f"{acc}_phenotype.tsv")
        sample_ids, expr = load_expression(CORE_DIR / f"{acc}_expression.tsv")
        gene_map = load_gene_probe_map(DEG_DIR / f"{acc}_deg_gene.tsv")

        lodo_genes = lodo_modules[acc]
        strict_available = [g for g in module_genes if g in gene_map and gene_map[g] in expr]
        lodo_available = [g for g in lodo_genes if g in gene_map and gene_map[g] in expr]
        union = sorted(set(strict_available).union(lodo_available))

        z_by_gene = {}
        for gene in union:
            probe = gene_map[gene]
            z_by_gene[gene] = zscore(expr[probe])

        rows = []
        pheno_by_sample = {row["geo_accession"]: row for row in pheno}
        for idx, sample in enumerate(sample_ids):
            strict_scores = [z_by_gene[g][idx] for g in strict_available]
            strict_score = mean_ignore_nan(strict_scores)
            lodo_scores = [z_by_gene[g][idx] for g in lodo_available]
            lodo_score = mean_ignore_nan(lodo_scores)
            p = pheno_by_sample[sample]
            rows.append(
                {
                    "dataset_id": acc,
                    "geo_accession": sample,
                    "response_binary": p["response_binary"],
                    "timepoint": p["timepoint"],
                    "strict_nonresponse_module_score": strict_score,
                    "n_genes_used": len(strict_available),
                    "lodo_nonresponse_module_score": lodo_score,
                    "lodo_n_genes_used": len(lodo_available),
                }
            )

        out_path = OUT_DIR / f"{acc}_module_scores.tsv"
        with out_path.open("w", encoding="utf-8", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), delimiter="\t")
            writer.writeheader()
            writer.writerows(rows)

        responders = [r["strict_nonresponse_module_score"] for r in rows if r["response_binary"] == "responder"]
        nonresponders = [r["strict_nonresponse_module_score"] for r in rows if r["response_binary"] == "nonresponder"]
        lodo_responders = [r["lodo_nonresponse_module_score"] for r in rows if r["response_binary"] == "responder"]
        lodo_nonresponders = [r["lodo_nonresponse_module_score"] for r in rows if r["response_binary"] == "nonresponder"]
        summary_rows.append(
            {
                "dataset_id": acc,
                "module_gene_count": len(strict_available),
                "responder_mean_score": mean_ignore_nan(responders),
                "nonresponder_mean_score": mean_ignore_nan(nonresponders),
                "direction": "higher_in_nonresponders" if mean_ignore_nan(nonresponders) > mean_ignore_nan(responders) else "higher_in_responders",
                "lodo_module_gene_count": len(lodo_available),
                "lodo_responder_mean_score": mean_ignore_nan(lodo_responders),
                "lodo_nonresponder_mean_score": mean_ignore_nan(lodo_nonresponders),
                "lodo_direction": "higher_in_nonresponders"
                if mean_ignore_nan(lodo_nonresponders) > mean_ignore_nan(lodo_responders)
                else "higher_in_responders",
            }
        )

    with (OUT_DIR / "module_score_summary.tsv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(summary_rows[0].keys()), delimiter="\t")
        writer.writeheader()
        writer.writerows(summary_rows)

    print(f"[ok] wrote module scores to {OUT_DIR}")


if __name__ == "__main__":
    main()
