#!/usr/bin/env python3
import csv
import gzip
import sys
from pathlib import Path


def clean(value: str) -> str:
    value = value.strip()
    if len(value) >= 2 and value[0] == '"' and value[-1] == '"':
        value = value[1:-1]
    return value


def parse_series_matrix(path: Path):
    sample_fields = {}
    sample_count = None

    with gzip.open(path, "rt", encoding="utf-8", errors="replace") as handle:
        reader = csv.reader(handle, delimiter="\t")
        for row in reader:
            if not row:
                continue
            key = row[0]
            if key == "!series_matrix_table_begin":
                break
            if not key.startswith("!Sample_"):
                continue

            field = key[len("!Sample_") :]
            values = [clean(v) for v in row[1:]]

            if sample_count is None:
                sample_count = len(values)
            elif len(values) != sample_count:
                raise ValueError(
                    f"Inconsistent sample field length for {field}: "
                    f"expected {sample_count}, found {len(values)}"
                )

            # Some GEO series matrices repeat !Sample_ fields (most commonly
            # !Sample_characteristics_ch1) multiple times. Preserve all entries
            # by concatenating per-sample values in appearance order.
            if field in sample_fields:
                merged = []
                for prev, curr in zip(sample_fields[field], values, strict=True):
                    if not prev:
                        merged.append(curr)
                    elif not curr:
                        merged.append(prev)
                    elif curr in prev.split("; "):
                        merged.append(prev)
                    else:
                        merged.append(f"{prev}; {curr}")
                sample_fields[field] = merged
            else:
                sample_fields[field] = values

    if sample_count is None:
        raise ValueError(f"No !Sample_ metadata found in {path}")

    return sample_fields, sample_count


def write_tsv(sample_fields, sample_count: int, out_path: Path):
    headers = ["sample_index"]
    if "geo_accession" in sample_fields:
        headers.append("geo_accession")

    ordered_fields = [k for k in sorted(sample_fields) if k != "geo_accession"]
    headers.extend(ordered_fields)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle, delimiter="\t")
        writer.writerow(headers)

        for idx in range(sample_count):
            row = [idx + 1]
            if "geo_accession" in sample_fields:
                row.append(sample_fields["geo_accession"][idx])
            for field in ordered_fields:
                row.append(sample_fields[field][idx])
            writer.writerow(row)


def main():
    if len(sys.argv) != 3:
        raise SystemExit(
            "Usage: extract_geo_sample_metadata.py <series_matrix.txt.gz> <output.tsv>"
        )

    in_path = Path(sys.argv[1])
    out_path = Path(sys.argv[2])
    sample_fields, sample_count = parse_series_matrix(in_path)
    write_tsv(sample_fields, sample_count, out_path)
    print(f"[ok] wrote {sample_count} samples to {out_path}")


if __name__ == "__main__":
    main()
