#!/usr/bin/env python3
import csv
import gzip
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "data" / "raw" / "geo" / "matrix"
META_DIR = ROOT / "data" / "processed" / "geo_sample_metadata"
OUT_DIR = ROOT / "data" / "processed" / "core_bulk"


def read_tsv(path: Path):
    with path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle, delimiter="\t"))


def parse_response_from_text(text: str, yes_token: str, no_token: str):
    if yes_token in text:
        return "responder", text
    if no_token in text:
        return "nonresponder", text
    return None, text


def build_gse12251(rows):
    selected = []
    for row in rows:
        response, raw = parse_response_from_text(
            row.get("characteristics_ch1", ""), "WK8RSPHM: Yes", "WK8RSPHM: No"
        )
        if response is None:
            continue
        selected.append(
            {
                "dataset_id": "GSE12251",
                "geo_accession": row["geo_accession"],
                "sample_title": row.get("title", ""),
                "disease_subset": "UC",
                "therapy": "infliximab",
                "timepoint": "pretreatment_W0",
                "response_binary": response,
                "response_label_raw": raw,
                "include_core_analysis": "yes",
                "selection_rule": "all samples with WK8RSPHM response label",
            }
        )
    return selected


def build_gse16879(rows):
    selected = []
    for row in rows:
        source = row.get("source_name_ch1", "")
        title = row.get("title", "")
        when = row.get("characteristics_ch1", "")

        if "before first infliximab treatment" not in source:
            continue
        if not title.startswith("UC") and "UC " not in source:
            continue

        response = None
        if "UC responder" in source:
            response = "responder"
        elif "UC non-responder" in source:
            response = "nonresponder"
        if response is None:
            continue

        selected.append(
            {
                "dataset_id": "GSE16879",
                "geo_accession": row["geo_accession"],
                "sample_title": title,
                "disease_subset": "UC",
                "therapy": "infliximab",
                "timepoint": "pretreatment_before_first_infliximab",
                "response_binary": response,
                "response_label_raw": source,
                "include_core_analysis": "yes",
                "selection_rule": f"UC subset + pretreatment + source_name_ch1; {when}",
            }
        )
    return selected


def build_gse23597(rows):
    selected = []
    for row in rows:
        title = row.get("title", "")
        if "/W0" not in title:
            continue
        response, raw = parse_response_from_text(
            row.get("characteristics_ch1", ""), "wk30 response: Yes", "wk30 response: No"
        )
        if response is None:
            continue
        selected.append(
            {
                "dataset_id": "GSE23597",
                "geo_accession": row["geo_accession"],
                "sample_title": title,
                "disease_subset": "UC",
                "therapy": "infliximab",
                "timepoint": "pretreatment_W0",
                "response_binary": response,
                "response_label_raw": raw,
                "include_core_analysis": "yes",
                "selection_rule": "title contains /W0 and wk30 response label available",
            }
        )
    return selected


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


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    phenotype_builders = {
        "GSE12251": build_gse12251,
        "GSE16879": build_gse16879,
        "GSE23597": build_gse23597,
    }

    combined_rows = []

    for accession, builder in phenotype_builders.items():
        meta_rows = read_tsv(META_DIR / f"{accession}_samples.tsv")
        selected = builder(meta_rows)
        selected.sort(key=lambda row: row["geo_accession"])

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

        matrix_path = OUT_DIR / f"{accession}_expression.tsv"
        stream_extract_matrix(accession, [row["geo_accession"] for row in selected], matrix_path)
        combined_rows.extend(selected)

    combined_rows.sort(key=lambda row: (row["dataset_id"], row["geo_accession"]))
    write_tsv(
        OUT_DIR / "core_bulk_samples.tsv",
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
    print(f"[ok] wrote harmonized phenotypes and matrices to {OUT_DIR}")


if __name__ == "__main__":
    main()
