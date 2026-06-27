#!/usr/bin/env python3
import csv
import gzip
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "data" / "raw" / "geo" / "matrix"
META_DIR = ROOT / "data" / "processed" / "geo_sample_metadata"
OUT_DIR = ROOT / "data" / "processed" / "sensitivity_bulk"


def read_tsv(path: Path):
    with path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle, delimiter="\t"))


def write_tsv(path: Path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter="\t")
        writer.writeheader()
        writer.writerows(rows)


def stream_extract_matrix(accession: str, keep_ids, out_path: Path):
    in_path = RAW_DIR / f"{accession}_series_matrix.txt.gz"
    keep_ids = list(keep_ids)
    keep_set = set(keep_ids)

    with gzip.open(in_path, "rt", encoding="utf-8", errors="replace") as src, out_path.open(
        "w", encoding="utf-8", newline=""
    ) as dst:
        writer = csv.writer(dst, delimiter="\t")
        in_table = False
        keep_indexes = []

        for line in src:
            if line.startswith("!series_matrix_table_begin"):
                in_table = True
                continue
            if not in_table:
                continue
            if line.startswith("!series_matrix_table_end"):
                break

            row = next(csv.reader([line], delimiter="\t"))
            cleaned = [cell.strip().strip('"') for cell in row]
            if cleaned[0] == "ID_REF":
                keep_indexes = [idx for idx, val in enumerate(cleaned) if idx == 0 or val in keep_set]
                selected_header = [cleaned[idx] for idx in keep_indexes]
                writer.writerow(selected_header)
                continue

            writer.writerow([cleaned[idx] for idx in keep_indexes])


def normalize_text(text: str) -> str:
    return re.sub(r"\s+", " ", (text or "").strip()).lower()


def infer_baseline(text: str) -> bool:
    t = normalize_text(text)
    baseline_tokens = [
        "baseline",
        "week 0",
        "week0",
        "w0",
        "pre-treatment",
        "pretreatment",
        "pre treatment",
        "before treatment",
        "prior to treatment",
        "before first",
    ]
    return any(tok in t for tok in baseline_tokens)


def infer_uc(text: str) -> bool:
    t = normalize_text(text)
    return ("ulcerative colitis" in t) or re.search(r"\buc\b", t) is not None


def infer_response(text: str):
    """
    Best-effort parsing for GEO free text. Returns (response_binary, raw_text) where
    response_binary is one of: responder, nonresponder, None.
    """
    raw = text or ""
    t = normalize_text(raw)

    # Prefer explicit labels.
    if any(
        tok in t
        for tok in [
            "non-responder",
            "nonresponder",
            "non responder",
            "primary nonresponse",
            "non response",
            "response: no",
            "response=no",
        ]
    ):
        return "nonresponder", raw
    if any(tok in t for tok in ["responder", "response: yes", "response=yes", "response yes"]):
        return "responder", raw

    # Fallback: common binary encodings.
    if re.search(r"\bresponse\b.*\bno\b", t):
        return "nonresponder", raw
    if re.search(r"\bresponse\b.*\byes\b", t):
        return "responder", raw

    return None, raw


def build_gse92415(meta_rows):
    selected = []
    for row in meta_rows:
        geo = row.get("geo_accession", "")
        if not geo:
            continue

        source = row.get("source_name_ch1", "")
        title = row.get("title", "")
        chars = row.get("characteristics_ch1", "")
        text = " | ".join([title, source, chars])

        # Sensitivity cohort: keep only UC baseline biopsies when possible.
        if not infer_uc(text):
            continue
        if not infer_baseline(text):
            continue

        response, raw = infer_response(text)
        if response is None:
            continue

        selected.append(
            {
                "dataset_id": "GSE92415",
                "geo_accession": geo,
                "sample_title": title,
                "disease_subset": "UC",
                "therapy": "golimumab",
                "timepoint": "pretreatment_baseline",
                "response_binary": response,
                "response_label_raw": raw,
                "include_core_analysis": "no",
                "selection_rule": "UC + baseline/pretreatment heuristic + response label heuristic (sensitivity only)",
            }
        )

    selected.sort(key=lambda r: r["geo_accession"])
    return selected


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    builders = {
        "GSE92415": build_gse92415,
    }

    combined_rows = []
    for accession, builder in builders.items():
        meta_path = META_DIR / f"{accession}_samples.tsv"
        meta_rows = read_tsv(meta_path)
        selected = builder(meta_rows)
        if not selected:
            raise SystemExit(
                f"No samples selected for {accession}. "
                f"Inspect {meta_path} and adjust build_sensitivity_uc_cohorts.py heuristics."
            )

        pheno_path = OUT_DIR / f"{accession}_phenotype.tsv"
        fieldnames = [
            "dataset_id",
            "geo_accession",
            "sample_title",
            "disease_subset",
            "therapy",
            "timepoint",
            "response_binary",
            "response_label_raw",
            "include_core_analysis",
            "selection_rule",
        ]
        write_tsv(pheno_path, selected, fieldnames)

        expr_path = OUT_DIR / f"{accession}_expression.tsv"
        stream_extract_matrix(accession, [r["geo_accession"] for r in selected], expr_path)
        combined_rows.extend(selected)

    combined_rows.sort(key=lambda r: (r["dataset_id"], r["geo_accession"]))
    write_tsv(
        OUT_DIR / "sensitivity_bulk_samples.tsv",
        combined_rows,
        [
            "dataset_id",
            "geo_accession",
            "sample_title",
            "disease_subset",
            "therapy",
            "timepoint",
            "response_binary",
            "response_label_raw",
            "include_core_analysis",
            "selection_rule",
        ],
    )
    print(f"[ok] wrote sensitivity phenotypes and matrices to {OUT_DIR}")


if __name__ == "__main__":
    main()
