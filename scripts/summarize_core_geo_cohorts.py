#!/usr/bin/env python3
import csv
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
META_DIR = ROOT / "data" / "processed" / "geo_sample_metadata"
OUT_PATH = ROOT / "results" / "dataset_summary.tsv"


def read_tsv(path: Path):
    with path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle, delimiter="\t"))


def summarize_gse12251(rows):
    pretreatment = rows
    responders = [
        row for row in pretreatment if "WK8RSPHM: Yes" in row.get("characteristics_ch1", "")
    ]
    nonresponders = [
        row for row in pretreatment if "WK8RSPHM: No" in row.get("characteristics_ch1", "")
    ]
    return {
        "dataset_id": "GSE12251",
        "disease_subset": "UC",
        "therapy": "infliximab",
        "pretreatment_n": len(pretreatment),
        "responder_n": len(responders),
        "nonresponder_n": len(nonresponders),
        "platform": "GPL570",
        "notes": "All imported samples appear to be pretreatment W0 biopsies; response encoded in characteristics_ch1",
    }


def summarize_gse16879(rows):
    pretreatment = []
    for row in rows:
        source = row.get("source_name_ch1", "")
        title = row.get("title", "")
        if "before first infliximab treatment" not in source:
            continue
        if "UC " not in source and not title.startswith("UC"):
            continue
        pretreatment.append(row)

    responders = [row for row in pretreatment if "UC responder" in row.get("source_name_ch1", "")]
    nonresponders = [
        row for row in pretreatment if "UC non-responder" in row.get("source_name_ch1", "")
    ]
    return {
        "dataset_id": "GSE16879",
        "disease_subset": "UC subset from mixed IBD cohort",
        "therapy": "infliximab",
        "pretreatment_n": len(pretreatment),
        "responder_n": len(responders),
        "nonresponder_n": len(nonresponders),
        "platform": "GPL570",
        "notes": "Filtered to UC biopsies before first infliximab treatment using source_name_ch1",
    }


def summarize_gse23597(rows):
    pretreatment = [row for row in rows if "/W0" in row.get("title", "")]
    responders = [
        row for row in pretreatment if "wk30 response: Yes" in row.get("characteristics_ch1", "")
    ]
    nonresponders = [
        row for row in pretreatment if "wk30 response: No" in row.get("characteristics_ch1", "")
    ]
    return {
        "dataset_id": "GSE23597",
        "disease_subset": "UC",
        "therapy": "infliximab",
        "pretreatment_n": len(pretreatment),
        "responder_n": len(responders),
        "nonresponder_n": len(nonresponders),
        "platform": "GPL570",
        "notes": "Filtered to W0 baseline biopsies using title; response encoded as wk30 response",
    }


def main():
    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)

    summaries = [
        summarize_gse12251(read_tsv(META_DIR / "GSE12251_samples.tsv")),
        summarize_gse16879(read_tsv(META_DIR / "GSE16879_samples.tsv")),
        summarize_gse23597(read_tsv(META_DIR / "GSE23597_samples.tsv")),
    ]

    fieldnames = [
        "dataset_id",
        "disease_subset",
        "therapy",
        "pretreatment_n",
        "responder_n",
        "nonresponder_n",
        "platform",
        "notes",
    ]

    with OUT_PATH.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter="\t")
        writer.writeheader()
        writer.writerows(summaries)

    print(f"[ok] wrote {OUT_PATH}")


if __name__ == "__main__":
    main()
