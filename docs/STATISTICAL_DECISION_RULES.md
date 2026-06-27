# Statistical Decision Rules

The primary analysis uses public pretreatment mucosal transcriptomes from three infliximab-treated UC cohorts. Response labels were harmonized from deposited study metadata before modeling.

Differential expression was estimated within each cohort using limma on GPL570 probe-level expression matrices. Probe-level results were mapped to gene symbols with the GPL570 annotation, keeping one representative probe per symbol after ranking by P value and absolute log fold-change.

The fixed consensus signature contains genes upregulated in nonresponders and nominally significant at P < 0.01 in all three primary cohorts. This fixed signature is used for interpretation, localization, and sensitivity analyses.

Held-out performance is summarized with a leave-one-dataset-out axis. For each held-out cohort, genes are selected only from the other two cohorts and then scored in the held-out cohort. Standardized effects are reported as Hedges' g for nonresponders versus responders with 95% confidence intervals.

Pathway analysis uses Hallmark gene sets and signed preranked statistics. Positive signed enrichment denotes higher activity in nonresponders; negative signed enrichment denotes higher activity in responders.

Specificity analyses evaluate whether the nonresponse axis remains associated with response after adjustment for inflammatory and remodeling proxies. These analyses are interpreted as sensitivity checks rather than causal adjustment.

The GSE92415 analysis is treated as class-level anti-TNF sensitivity evidence because it uses a golimumab-treated cohort rather than an infliximab-treated cohort.

Single-cell analyses provide cellular-context localization using processed public references. They are not treatment-response validation cohorts.
