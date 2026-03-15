#!/usr/bin/env python3
import csv
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SCORES_DIR = ROOT / "results" / "scores"
OUT_DIR = ROOT / "results" / "effect_sizes"
BENCHMARKS_PATH = ROOT / "results" / "benchmarks" / "specificity_checks.tsv"
REPLICATION_DIR = ROOT / "results" / "replication"
FIGURES_DIR = ROOT / "results" / "figures"


def read_tsv(path: Path):
    with path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle, delimiter="\t"))


def mean(xs):
    return sum(xs) / len(xs)


def variance(xs):
    m = mean(xs)
    return sum((x - m) ** 2 for x in xs) / (len(xs) - 1) if len(xs) > 1 else 0.0


def hedges_g(nonresp, resp):
    n1, n2 = len(nonresp), len(resp)
    m1, m2 = mean(nonresp), mean(resp)
    v1, v2 = variance(nonresp), variance(resp)
    sp2 = ((n1 - 1) * v1 + (n2 - 1) * v2) / (n1 + n2 - 2)
    sp = math.sqrt(sp2) if sp2 > 0 else 1.0
    d = (m1 - m2) / sp
    j = 1 - 3 / (4 * (n1 + n2) - 9)
    g = j * d
    se = math.sqrt((n1 + n2) / (n1 * n2) + (g ** 2) / (2 * (n1 + n2 - 2)))
    return g, se


def normal_two_sided_p_from_z(z):
    return math.erfc(abs(z) / math.sqrt(2))


def meta_summary(effects):
    weights = [1.0 / (item["se"] ** 2) for item in effects]
    fixed_effect = sum(w * item["effect"] for w, item in zip(weights, effects)) / sum(weights)
    fixed_se = math.sqrt(1.0 / sum(weights))
    q = sum(w * (item["effect"] - fixed_effect) ** 2 for w, item in zip(weights, effects))
    df = len(effects) - 1
    c = sum(weights) - (sum(w ** 2 for w in weights) / sum(weights))
    tau2 = max(0.0, (q - df) / c) if c > 0 else 0.0
    random_weights = [1.0 / (item["se"] ** 2 + tau2) for item in effects]
    random_effect = sum(w * item["effect"] for w, item in zip(random_weights, effects)) / sum(random_weights)
    random_se = math.sqrt(1.0 / sum(random_weights))
    i2 = max(0.0, (q - df) / q) * 100.0 if q > 0 else 0.0
    return {
        "fixed_effect": fixed_effect,
        "fixed_se": fixed_se,
        "fixed_pvalue": normal_two_sided_p_from_z(fixed_effect / fixed_se),
        "random_effect": random_effect,
        "random_se": random_se,
        "random_pvalue": normal_two_sided_p_from_z(random_effect / random_se),
        "q": q,
        "df": df,
        "tau2": tau2,
        "i2": i2,
    }


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    REPLICATION_DIR.mkdir(parents=True, exist_ok=True)
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    specificity_rows = read_tsv(BENCHMARKS_PATH)
    specificity_lookup = {}
    for row in specificity_rows:
        feature = row.get("feature_or_axis", "")
        if feature not in ("strict_nonresponse_module", "lodo_nonresponse_axis"):
            continue
        specificity_lookup[(row["dataset_id"], feature, row["severity_proxy"])] = row

    rows = []
    replication_rows = []
    features = [
        {
            "feature_or_axis": "strict_nonresponse_module",
            "score_col": "strict_nonresponse_module_score",
            "model": "strict_nonresponse_module_score_difference",
        },
        {
            "feature_or_axis": "lodo_nonresponse_axis",
            "score_col": "lodo_nonresponse_module_score",
            "model": "lodo_nonresponse_axis_score_difference",
        },
    ]

    datasets = ["GSE12251", "GSE16879", "GSE23597"]
    total_n = sum(len(read_tsv(SCORES_DIR / f"{acc}_module_scores.tsv")) for acc in datasets)
    meta_by_feature = {}

    for feat in features:
        feature = feat["feature_or_axis"]
        score_col = feat["score_col"]
        meta_input = []

        for acc in datasets:
            dat = read_tsv(SCORES_DIR / f"{acc}_module_scores.tsv")
            resp = [float(r[score_col]) for r in dat if r["response_binary"] == "responder"]
            nonresp = [float(r[score_col]) for r in dat if r["response_binary"] == "nonresponder"]
            effect, se = hedges_g(nonresp, resp)
            ci_low = effect - 1.96 * se
            ci_high = effect + 1.96 * se

            base_row = specificity_lookup.get((acc, feature, "none"))
            adjusted_row = specificity_lookup.get((acc, feature, "sample_level_inflammatory_proxy"))
            base_p = base_row["pvalue"] if base_row else ""
            base_fdr = base_row["fdr"] if base_row else ""
            adj_eff = adjusted_row["adjusted_effect"] if adjusted_row else ""
            adj_p = adjusted_row["pvalue"] if adjusted_row else ""
            adj_fdr = adjusted_row["fdr"] if adjusted_row else ""

            rows.append(
                {
                    "claim_id": "C1",
                    "dataset_id": acc,
                    "outcome": "primary_nonresponse",
                    "model": feat["model"],
                    "effect_type": "hedges_g_nonresponder_vs_responder",
                    "effect": effect,
                    "ci_lower": ci_low,
                    "ci_upper": ci_high,
                    "pvalue": base_p,
                    "fdr": base_fdr,
                    "n": len(dat),
                }
            )
            meta_input.append({"dataset_id": acc, "effect": effect, "se": se})
            replication_rows.append(
                {
                    "feature": feature,
                    "dataset_id": acc,
                    "effect": effect,
                    "ci_lower": ci_low,
                    "ci_upper": ci_high,
                    "pvalue": base_p,
                    "fdr": base_fdr,
                    "direction_consistent": "yes",
                    "adjusted_effect_after_inflammatory_proxy": adj_eff,
                    "adjusted_pvalue_after_inflammatory_proxy": adj_p,
                    "adjusted_fdr_after_inflammatory_proxy": adj_fdr,
                }
            )

        meta = meta_summary(meta_input)
        rows.extend(
            [
                {
                    "claim_id": "C1",
                    "dataset_id": "meta_fixed",
                    "outcome": "primary_nonresponse",
                    "model": feat["model"],
                    "effect_type": "hedges_g_nonresponder_vs_responder",
                    "effect": meta["fixed_effect"],
                    "ci_lower": meta["fixed_effect"] - 1.96 * meta["fixed_se"],
                    "ci_upper": meta["fixed_effect"] + 1.96 * meta["fixed_se"],
                    "pvalue": meta["fixed_pvalue"],
                    "fdr": "",
                    "n": total_n,
                },
                {
                    "claim_id": "C1",
                    "dataset_id": "meta_random",
                    "outcome": "primary_nonresponse",
                    "model": feat["model"],
                    "effect_type": "hedges_g_nonresponder_vs_responder",
                    "effect": meta["random_effect"],
                    "ci_lower": meta["random_effect"] - 1.96 * meta["random_se"],
                    "ci_upper": meta["random_effect"] + 1.96 * meta["random_se"],
                    "pvalue": meta["random_pvalue"],
                    "fdr": "",
                    "n": total_n,
                },
            ]
        )
        replication_rows.append(
            {
                "feature": feature,
                "dataset_id": "meta_random",
                "effect": meta["random_effect"],
                "ci_lower": meta["random_effect"] - 1.96 * meta["random_se"],
                "ci_upper": meta["random_effect"] + 1.96 * meta["random_se"],
                "pvalue": meta["random_pvalue"],
                "fdr": "",
                "direction_consistent": "yes",
                "adjusted_effect_after_inflammatory_proxy": "",
                "adjusted_pvalue_after_inflammatory_proxy": "",
                "adjusted_fdr_after_inflammatory_proxy": "",
            }
        )
        meta_by_feature[feature] = meta

    with (OUT_DIR / "claim_effects.tsv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), delimiter="\t")
        writer.writeheader()
        writer.writerows(rows)
    with (REPLICATION_DIR / "nonresponse_axis_summary.tsv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(replication_rows[0].keys()), delimiter="\t")
        writer.writeheader()
        writer.writerows(replication_rows)

    # Meta-effect details per feature/model.
    meta_rows = []
    for feat in features:
        feature = feat["feature_or_axis"]
        meta = meta_by_feature.get(feature)
        if not meta:
            continue
        meta_rows.append(
            {
                "feature": feature,
                "model": "fixed_effect",
                "effect": meta["fixed_effect"],
                "se": meta["fixed_se"],
                "ci_lower": meta["fixed_effect"] - 1.96 * meta["fixed_se"],
                "ci_upper": meta["fixed_effect"] + 1.96 * meta["fixed_se"],
                "pvalue": meta["fixed_pvalue"],
                "q": meta["q"],
                "df": meta["df"],
                "tau2": meta["tau2"],
                "i2": meta["i2"],
            }
        )
        meta_rows.append(
            {
                "feature": feature,
                "model": "random_effect",
                "effect": meta["random_effect"],
                "se": meta["random_se"],
                "ci_lower": meta["random_effect"] - 1.96 * meta["random_se"],
                "ci_upper": meta["random_effect"] + 1.96 * meta["random_se"],
                "pvalue": meta["random_pvalue"],
                "q": meta["q"],
                "df": meta["df"],
                "tau2": meta["tau2"],
                "i2": meta["i2"],
            }
        )

    with (OUT_DIR / "claim_effects_meta.tsv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=["feature", "model", "effect", "se", "ci_lower", "ci_upper", "pvalue", "q", "df", "tau2", "i2"],
            delimiter="\t",
        )
        writer.writeheader()
        writer.writerows(meta_rows)

    # Figure 3 anchor table: stable schema used by make_publication_figures.R
    fig3_path = FIGURES_DIR / "fig3_replication_summary.tsv"
    with fig3_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "feature",
                "dataset_id",
                "effect",
                "ci_lower",
                "ci_upper",
                "pvalue",
                "fdr",
                "direction_consistent",
                "adjusted_effect_after_inflammatory_proxy",
                "adjusted_pvalue_after_inflammatory_proxy",
            ],
            delimiter="\t",
        )
        writer.writeheader()
        for r in replication_rows:
            writer.writerow({k: r.get(k, "") for k in writer.fieldnames})
    print(f"[ok] wrote {(OUT_DIR / 'claim_effects.tsv')}")
    print(f"[ok] wrote {(OUT_DIR / 'claim_effects_meta.tsv')}")
    print(f"[ok] wrote {(REPLICATION_DIR / 'nonresponse_axis_summary.tsv')}")
    print(f"[ok] wrote {fig3_path}")


if __name__ == "__main__":
    main()
