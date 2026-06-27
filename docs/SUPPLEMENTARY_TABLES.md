# Supplementary Tables

This document contains Tables S1–S7 for separate upload.

## Table S1. Strict 68-gene cross-cohort consensus signature (gene symbols)
Gene symbols for the strict consensus signature used for interpretability, specificity benchmarking, and single-cell localization.

| Gene symbol |
| --- |
| BCL6 |
| CD86 |
| CD93 |
| CEBPB |
| CFLAR |
| CHI3L1 |
| CHST15 |
| CLEC4E |
| COL8A1 |
| CSF2RB |
| CSF3 |
| CYRIA |
| DENND5A |
| FCGR1BP |
| FCGR2A |
| FST |
| FZD10 |
| G0S2 |
| GLIPR1 |
| GLT1D1 |
| HGF |
| HLA-DQA1 |
| HSD11B1 |
| IER5 |
| IFIT3 |
| IGFBP5 |
| IL11 |
| IL13RA2 |
| IL6 |
| INHBA |
| KLHL5 |
| LILRA2 |
| LILRB1 |
| LILRB2 |
| LILRB3 |
| LRRC8C |
| LRRK2 |
| NIBAN1 |
| NR4A3 |
| NRG1 |
| NRP2 |
| P2RX7 |
| P2RY13 |
| PALM2AKAP2 |
| PAPPA |
| PRR16 |
| PTGS1 |
| PTGS2 |
| PTPRC |
| RAB31 |
| RBMS1 |
| RGS18 |
| RGS4 |
| RHOQ |
| RNF144B |
| SELE |
| SERPINE1 |
| SOCS3 |
| SOD2 |
| SRGN |
| STC1 |
| TAGAP |
| TFPI |
| TFPI2 |
| TLR1 |
| TLR8 |
| TNFRSF11B |
| ZEB1 |

## Table S2. Replication effect sizes (consensus signature and LODO axis)
Numeric fields are rounded for readability; full-precision values are available in the corresponding TSV files.

| Feature | Dataset | Effect (Hedges g) | Lower 95% CI | Upper 95% CI | P-value | FDR | Direction consistent | Adjusted effect (inflammatory proxy) | Adjusted P-value (inflammatory proxy) | Adjusted FDR (inflammatory proxy) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Consensus signature (68 genes) | GSE12251 | 1.85 | 0.86 | 2.84 | 1.55e-4 | 0.001 | Yes | 0.34 | 0.038 | 0.078 |
| Consensus signature (68 genes) | GSE16879 | 1.48 | 0.52 | 2.43 | 0.002 | 0.007 | Yes | 0.44 | 0.04 | 0.078 |
| Consensus signature (68 genes) | GSE23597 | 2.03 | 1.05 | 3.01 | 3.39e-5 | 8.13e-4 | Yes | 0.61 | 1.87e-4 | 0.001 |
| Consensus signature (68 genes) | Random-effects meta | 1.78 | 1.22 | 2.34 | 5.97e-10 |  | Yes |  |  |  |
| Held-out LODO axis | GSE12251 | 1.52 | 0.58 | 2.45 | 0.001 | 0.005 | Yes | 0.21 | 0.259 | 0.345 |
| Held-out LODO axis | GSE16879 | 0.90 | 0.01 | 1.79 | 0.042 | 0.078 | Yes | 0.07 | 0.654 | 0.714 |
| Held-out LODO axis | GSE23597 | 1.72 | 0.77 | 2.66 | 2.73e-4 | 0.002 | Yes | 0.40 | 0.009 | 0.026 |
| Held-out LODO axis | Random-effects meta | 1.36 | 0.83 | 1.89 | 5.65e-7 |  | Yes |  |  |  |

## Table S3. Specificity checks under inflammation and remodeling proxy adjustment
Numeric fields are rounded for readability; full-precision values are available in the corresponding TSV files.

| Dataset | Feature/axis | Severity proxy | Base effect (Hedges g) | Adjusted effect (Hedges g) | Lower 95% CI | Upper 95% CI | P-value | FDR | Interpretation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| GSE12251 | Hallmark inflammatory response (reference) | Hallmark inflammatory response (NES) | -3.65 | -3.65 |  |  | 1.26e-43 | 3.16e-42 | Hallmark direction: enriched in nonresponders |
| GSE12251 | Consensus signature (68 genes) | Unadjusted | 1.14 | 1.14 | 0.62 | 1.65 | 1.55e-4 | 0.001 | baseline group difference in signature score |
| GSE12251 | Consensus signature (68 genes) | Adjusted: 7-gene inflammatory proxy | 1.14 | 0.34 | 0.02 | 0.65 | 0.038 | 0.078 | adjusted for mean z-score of 7 recurrent inflammatory genes |
| GSE12251 | Consensus signature (68 genes) | Adjusted: Hallmark inflammatory-response proxy | 1.14 | 0.02 | -0.22 | 0.27 | 0.841 | 0.877 | adjusted for sample-level mean z-score across 200 Hallmark inflammatory-response genes |
| GSE12251 | Consensus signature (68 genes) | Adjusted: Hallmark inflammatory-response + EMT proxies | 1.14 | 0.02 | -0.20 | 0.23 | 0.878 | 0.878 | adjusted jointly for sample-level Hallmark inflammatory-response and EMT proxies (200 and 200 genes available) |
| GSE12251 | Held-out LODO axis | Unadjusted | 0.79 | 0.79 | 0.36 | 1.23 | 0.001 | 0.005 | baseline group difference in signature score |
| GSE12251 | Held-out LODO axis | Adjusted: 7-gene inflammatory proxy | 0.79 | 0.21 | -0.17 | 0.59 | 0.259 | 0.345 | adjusted for mean z-score of 7 recurrent inflammatory genes |
| GSE12251 | Held-out LODO axis | Adjusted: Hallmark inflammatory-response proxy | 0.79 | -0.11 | -0.39 | 0.16 | 0.404 | 0.511 | adjusted for sample-level mean z-score across 200 Hallmark inflammatory-response genes |
| GSE12251 | Held-out LODO axis | Adjusted: Hallmark inflammatory-response + EMT proxies | 0.79 | -0.13 | -0.33 | 0.08 | 0.211 | 0.298 | adjusted jointly for sample-level Hallmark inflammatory-response and EMT proxies (200 and 200 genes available) |
| GSE16879 | Hallmark inflammatory response (reference) | Hallmark inflammatory response (NES) | -3.46 | -3.46 |  |  | 2.90e-33 | 4.83e-32 | Hallmark direction: enriched in nonresponders |
| GSE16879 | Consensus signature (68 genes) | Unadjusted | 1.01 | 1.01 | 0.42 | 1.60 | 0.002 | 0.007 | baseline group difference in signature score |
| GSE16879 | Consensus signature (68 genes) | Adjusted: 7-gene inflammatory proxy | 1.01 | 0.44 | 0.02 | 0.85 | 0.04 | 0.078 | adjusted for mean z-score of 7 recurrent inflammatory genes |
| GSE16879 | Consensus signature (68 genes) | Adjusted: Hallmark inflammatory-response proxy | 1.01 | 0.28 | 0.02 | 0.54 | 0.034 | 0.078 | adjusted for sample-level mean z-score across 200 Hallmark inflammatory-response genes |
| GSE16879 | Consensus signature (68 genes) | Adjusted: Hallmark inflammatory-response + EMT proxies | 1.01 | 0.26 | 0.03 | 0.50 | 0.03 | 0.078 | adjusted jointly for sample-level Hallmark inflammatory-response and EMT proxies (200 and 200 genes available) |
| GSE16879 | Held-out LODO axis | Unadjusted | 0.40 | 0.40 | 0.02 | 0.78 | 0.042 | 0.078 | baseline group difference in signature score |
| GSE16879 | Held-out LODO axis | Adjusted: 7-gene inflammatory proxy | 0.40 | 0.07 | -0.24 | 0.38 | 0.654 | 0.714 | adjusted for mean z-score of 7 recurrent inflammatory genes |
| GSE16879 | Held-out LODO axis | Adjusted: Hallmark inflammatory-response proxy | 0.40 | -0.06 | -0.24 | 0.12 | 0.464 | 0.557 | adjusted for sample-level mean z-score across 200 Hallmark inflammatory-response genes |
| GSE16879 | Held-out LODO axis | Adjusted: Hallmark inflammatory-response + EMT proxies | 0.40 | -0.09 | -0.21 | 0.04 | 0.178 | 0.284 | adjusted jointly for sample-level Hallmark inflammatory-response and EMT proxies (200 and 200 genes available) |
| GSE23597 | Hallmark inflammatory response (reference) | Hallmark inflammatory response (NES) | -2.97 | -2.97 |  |  | 6.48e-23 | 1.08e-21 | Hallmark direction: enriched in nonresponders |
| GSE23597 | Consensus signature (68 genes) | Unadjusted | 1.25 | 1.25 | 0.73 | 1.78 | 3.39e-5 | 8.13e-4 | baseline group difference in signature score |
| GSE23597 | Consensus signature (68 genes) | Adjusted: 7-gene inflammatory proxy | 1.25 | 0.61 | 0.32 | 0.90 | 1.87e-4 | 0.001 | adjusted for mean z-score of 7 recurrent inflammatory genes |
| GSE23597 | Consensus signature (68 genes) | Adjusted: Hallmark inflammatory-response proxy | 1.25 | 0.26 | -0.00 | 0.51 | 0.052 | 0.089 | adjusted for sample-level mean z-score across 200 Hallmark inflammatory-response genes |
| GSE23597 | Consensus signature (68 genes) | Adjusted: Hallmark inflammatory-response + EMT proxies | 1.25 | 0.29 | 0.08 | 0.49 | 0.008 | 0.026 | adjusted jointly for sample-level Hallmark inflammatory-response and EMT proxies (200 and 200 genes available) |
| GSE23597 | Held-out LODO axis | Unadjusted | 0.98 | 0.98 | 0.50 | 1.47 | 2.73e-4 | 0.002 | baseline group difference in signature score |
| GSE23597 | Held-out LODO axis | Adjusted: 7-gene inflammatory proxy | 0.98 | 0.40 | 0.11 | 0.70 | 0.009 | 0.026 | adjusted for mean z-score of 7 recurrent inflammatory genes |
| GSE23597 | Held-out LODO axis | Adjusted: Hallmark inflammatory-response proxy | 0.98 | 0.05 | -0.18 | 0.28 | 0.642 | 0.714 | adjusted for sample-level mean z-score across 200 Hallmark inflammatory-response genes |
| GSE23597 | Held-out LODO axis | Adjusted: Hallmark inflammatory-response + EMT proxies | 0.98 | 0.09 | -0.05 | 0.23 | 0.206 | 0.298 | adjusted jointly for sample-level Hallmark inflammatory-response and EMT proxies (200 and 200 genes available) |

## Table S4. Hallmark pathway enrichment results (full FGSEA outputs)
Numeric fields are rounded for readability. `leadingEdge` is truncated in this DOCX-friendly rendering; full outputs (including full `leadingEdge`) are available in the corresponding TSV files.

| Pathway (Hallmark) | P-value | FDR | log2(error) | ES | NES | Gene set size | Leading edge genes | Dataset | Direction |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TNFA Signaling via NFkB | 8.90e-50 | 4.45e-48 | 1.84 | -0.68 | -3.79 | 200 | G0S2, TLR2, IL1B, PTGS2, TNFAIP6, NAMPT, BCL6, OLR1, SOD2, CXCL11, PDE4B, PLEK, DUSP1, BCL2A1, IFIT2, INHBA, GADD45B, IL1A, GFPT2, RIPK2, ... | GSE12251 | Enriched in nonresponders |
| Inflammatory Response | 4.37e-44 | 1.09e-42 | 1.73 | -0.65 | -3.65 | 200 | TLR2, IL1B, TNFAIP6, NAMPT, CSF3R, C5AR1, OSM, FPR1, OLR1, CXCL8, PROK2, CXCL11, PDE4B, AQP9, FFAR2, MEFV, CD82, INHBA, IL1A, IL18RAP, ... | GSE12251 | Enriched in nonresponders |
| E2f Targets | 2.42e-42 | 4.04e-41 | 1.70 | 0.65 | 3.53 | 199 | PLK4, DUT, SSRP1, GINS1, CHEK1, UBR7, UNG, RRM2, SHMT1, MCM4, TK1, AK2, CDCA8, CBX5, RAD51AP1, BIRC5, E2F8, BARD1, TMPO, ASF1B, ... | GSE12251 | Enriched in responders |
| Interferon Gamma Response | 1.22e-35 | 1.52e-34 | 1.55 | -0.61 | -3.41 | 200 | PTGS2, TNFAIP6, NAMPT, FPR1, SOD2, CXCL11, PDE4B, IFITM2, FCGR1A, IFIT2, RIPK2, SOCS3, TNFAIP3, UPP1, NFKBIA, LATS2, IL6, CCL7, SELP, MX2, ... | GSE12251 | Enriched in nonresponders |
| MYC Targets V1 | 2.44e-34 | 2.44e-33 | 1.52 | 0.61 | 3.31 | 200 | DUT, HNRNPA3, RUVBL2, PPIA, TOMM70, SERBP1, TCP1, MCM4, PHB1, POLE3, SET, HDAC2, CDC45, RPL22, CYC1, RPL14, FBL, LSM7, TYMS, CCNA2, ... | GSE12251 | Enriched in responders |
| Oxidative Phosphorylation | 1.07e-32 | 8.91e-32 | 1.49 | 0.59 | 3.25 | 199 | ECH1, SUPV3L1, LRPPRC, IDH3B, TOMM70, ATP5F1A, FH, NDUFB8, MRPL11, MRPS30, OPA1, NDUFV1, CYC1, IDH3A, GPI, CYCS, NDUFS3, DLAT, ACADSB, UQCRFS1, ... | GSE12251 | Enriched in responders |
| G2/M Checkpoint | 4.41e-22 | 3.15e-21 | 1.21 | 0.53 | 2.87 | 200 | PLK4, SMC2, CHEK1, STIL, SLC12A2, H2AZ2, PRC1, KIF11, NSD2, CENPF, CDC45, BIRC5, UBE2C, BARD1, TMPO, CCNA2, DKC1, SQLE, KIF15, GINS2, ... | GSE12251 | Enriched in responders |
| Epithelial Mesenchymal Transition | 3.73e-21 | 2.33e-20 | 1.19 | -0.52 | -2.87 | 200 | TNFRSF11B, CXCL8, WNT5A, FGF2, INHBA, GADD45B, SERPINE1, SPP1, TNFAIP3, TFPI2, TGFBI, BMP1, RGS4, IL6, ITGA5, PDLIM4, ANPEP, CTHRC1, SERPINH1, BASP1, ... | GSE12251 | Enriched in nonresponders |
| Allograft Rejection | 1.87e-17 | 1.04e-16 | 1.08 | -0.48 | -2.68 | 200 | TLR2, IL1B, SRGN, IL11, FGR, INHBA, IL18RAP, RIPK2, EREG, IL6, CCL7, GBP2, TLR1, CCR1, LYN, NLRP3, IGSF6, CD86, PTPRC, CCL4, ... | GSE12251 | Enriched in nonresponders |
| Complement | 1.91e-16 | 9.57e-16 | 1.05 | -0.47 | -2.63 | 200 | OLR1, FCN1, PLEK, S100A12, FCER1G, SERPINE1, TNFAIP3, HSPA1A, TFPI2, GCA, KYNU, CEBPB, S100A9, SERPINB2, IL6, TIMP2, USP15, CASP4, LYN, ITGAM, ... | GSE12251 | Enriched in nonresponders |
| Interferon Alpha Response | 2.44e-15 | 1.11e-14 | 1.01 | -0.58 | -2.85 | 97 | CXCL11, IFITM2, IFIT2, RIPK2, SELL, GBP2, IFIT3, IFI44L, TMEM140, MX1, IL4R, IRF7, WARS1, TAP1, STAT2, SP110, IFIH1, B2M, IFITM1, IFI30, ... | GSE12251 | Enriched in nonresponders |
| IL6 JAK STAT3 Signaling | 9.32e-15 | 3.88e-14 | 0.99 | -0.60 | -2.91 | 87 | TLR2, IL1B, CSF3R, CXCL11, SOCS3, IL18R1, CD14, TNFRSF1B, IL6, CCL7, CCR1, IL17RA, CRLF2, CSF2RB, PIK3R5, CSF2RA, OSMR, CD44, PIM1, IL4R, ... | GSE12251 | Enriched in nonresponders |
| KRAS Signaling (up) | 1.15e-12 | 4.42e-12 | 0.91 | -0.43 | -2.40 | 200 | G0S2, IL1B, PTGS2, TFPI, INHBA, GFPT2, FCER1G, SPP1, TNFAIP3, EREG, PPP1R15A, TNFRSF1B, TLR8, HSD11B1, IL33, CSF2RA, PECAM1, ADAM8, CTSS, SCN1B, ... | GSE12251 | Enriched in nonresponders |
| Apoptosis | 3.25e-11 | 1.16e-10 | 0.85 | -0.44 | -2.40 | 161 | IL1B, SOD2, GADD45B, IL1A, HGF, CD14, EREG, IL6, TIMP2, CFLAR, IGF2R, CASP4, PMAIP1, RARA, SAT1, TIMP1, CD44, BCL2L1, CAV1, RHOB, ... | GSE12251 | Enriched in nonresponders |
| Coagulation | 8.11e-11 | 2.70e-10 | 0.84 | -0.46 | -2.42 | 138 | OLR1, PLEK, SERPINE1, TFPI2, BMP1, SERPINB2, PRSS23, THBD, KLK8, TIMP1, MMP3, PECAM1, CTSB, C8G, MMP1, LAMP2, KLF7, DUSP14, VWF, CPQ, ... | GSE12251 | Enriched in nonresponders |
| IL2 STAT5 Signaling | 4.15e-10 | 1.30e-9 | 0.81 | -0.40 | -2.21 | 199 | GABARAPL1, GADD45B, NFIL3, IL18R1, SPP1, SLC2A3, TNFRSF1B, SELL, SELP, IGF2R, PHLDA1, CD86, DENND5A, CD44, BCL2L1, PIM1, KLF6, IL4R, RHOB, CST7, ... | GSE12251 | Enriched in nonresponders |
| DNA Repair | 6.51e-10 | 1.91e-9 | 0.80 | 0.44 | 2.33 | 150 | ZWINT, DUT, SSRP1, ERCC2, RAD51, ALYREF, RFC5, TYMS, TP53, PCNA, RFC3, RFC4, AK3, IMPDH2, NUDT21, ITPA, POLR1H, SNAPC5, MPC2, TAF9, ... | GSE12251 | Enriched in responders |
| Adipogenesis | 8.33e-9 | 2.31e-8 | 0.75 | 0.38 | 2.09 | 200 | ELOVL6, ECH1, DHCR7, PDCD4, COQ3, MCCC1, AK2, CYC1, IDH3A, HADH, SLC25A10, NDUFS3, DLAT, COQ9, ACLY, IMMT, UQCRC1, DLD, GPHN, PFKL, ... | GSE12251 | Enriched in responders |
| MYC Targets V2 | 1.58e-8 | 4.15e-8 | 0.73 | 0.57 | 2.51 | 58 | TMEM97, PLK4, SUPV3L1, NDUFAF4, UNG, SLC29A2, MCM4, PHB1, DCTPP1, LAS1L, DDX18, SORD, PA2G4, FARSA, WDR74, EXOSC5, RABEPK, HK2, MYBBP1A, AIMP2, ... | GSE12251 | Enriched in responders |
| Hypoxia | 2.75e-7 | 6.86e-7 | 0.67 | -0.35 | -1.97 | 200 | STC1, DUSP1, NFIL3, ZFP36, PFKFB3, SERPINE1, TNFAIP3, PPP1R15A, TGFBI, SLC2A3, IL6, HAS1, CAV1, PIM1, KLF6, PLAUR, FOSL2, DTNA, INHA, KLF7, ... | GSE12251 | Enriched in nonresponders |
| Angiogenesis | 2.41e-6 | 5.75e-6 | 0.63 | -0.60 | -2.36 | 36 | STC1, OLR1, SPP1, KCNJ8, THBD, TIMP1, PGLYRP1, COL5A2, CXCL6, VCAN, LRPAP1, LUM, FGFR1, S100A4, MSX1, NRP1, COL3A1, JAG2 | GSE12251 | Enriched in nonresponders |
| Fatty Acid Metabolism | 3.18e-6 | 7.22e-6 | 0.63 | 0.37 | 1.99 | 156 | ECH1, IDH3B, FASN, FH, ADH1C, HADH, HMGCS1, HSD17B4, ACSL5, HSDL2, APEX1, PDHB, GSTZ1, ECI1, NCAPH2, DLD, PPARA, ALAD, DHCR24, ALDH9A1, ... | GSE12251 | Enriched in responders |
| p53 Pathway | 6.48e-6 | 1.41e-5 | 0.61 | -0.33 | -1.82 | 200 | CD82, IL1A, UPP1, NINJ1, PPP1R15A, HSPA4L, SPHK1, ZFP36L1, SAT1, KLK8, IER5, PTPRE, KRT17, TAP1, BTG2, PHLDA3, RGS16, PTPN14, PLK2, JUN, ... | GSE12251 | Enriched in nonresponders |
| mTORC1 Signaling | 1.83e-5 | 3.80e-5 | 0.58 | 0.32 | 1.77 | 200 | TMEM97, ELOVL6, SCD, PPIA, DHCR7, UNG, RRM2, HMGCR, MCM4, EBP, NUFIP1, GPI, MTHFD2L, SQLE, CCNF, HMGCS1, NUPR1, SLC37A4, ACLY, CCNG1, ... | GSE12251 | Enriched in responders |
| Glycolysis | 8.95e-5 | 1.79e-4 | 0.54 | 0.31 | 1.69 | 200 | PPIA, EFNA3, B4GALT1, RPE, COG2, PAXIP1, GFPT1, SLC25A10, DEPDC1, SLC37A4, ELF3, CASP6, AURKA, AK3, BIK, DLD, CLN6, CDK1, GNE, HMMR, ... | GSE12251 | Enriched in responders |
| UV Response (down) | 4.68e-4 | 8.90e-4 | 0.50 | -0.31 | -1.67 | 144 | TFPI, DUSP1, SERPINE1, RGS4, IGFBP5, CELF2, GJA1, CAV1, PTEN, COL5A2, ADGRL2, AKT3, ITGB3, IGF1R, MAPK14, CDON, ATXN1, AMPH, RBPMS, RUNX1, ... | GSE12251 | Enriched in nonresponders |
| Apical Junction | 4.81e-4 | 8.90e-4 | 0.50 | -0.29 | -1.61 | 200 | TNFRSF11B, GNAI1, TGFBI, BMP1, CD86, PTPRC, ACTN1, PECAM1, ICAM1, PBX2, PTEN, CD274, CLDN9, ZYX, TRO, VWF, FYB1, AKT3, MMP2, RSU1, ... | GSE12251 | Enriched in nonresponders |
| Mitotic Spindle | 8.38e-4 | 0.001 | 0.48 | 0.29 | 1.56 | 199 | LRPPRC, ATG4B, DLG1, PRC1, KIF11, CENPF, SORBS2, BIRC5, KIF15, NUSAP1, KIF22, CCNB2, AURKA, NEK2, CDK1, FARP1, CDC42EP4, RACGAP1, PCGF5, NET1, ... | GSE12251 | Enriched in responders |
| Cholesterol Homeostasis | 0.001 | 0.002 | 0.46 | 0.37 | 1.73 | 74 | TMEM97, ECH1, SCD, DHCR7, FASN, FDFT1, HMGCR, EBP, SQLE, HMGCS1, ADH4, MVK, NSDHL, CYP51A1, CHKA, ACAT2, SC5D, ACSS2, CD9, FDPS, ... | GSE12251 | Enriched in responders |
| Peroxisome | 0.002 | 0.003 | 0.46 | 0.34 | 1.67 | 104 | ECH1, NUDT19, CTBP1, HSD17B4, ACSL5, MSH2, HSD11B2, CLN6, DHCR24, ALDH9A1, PRDX5, ABCD3, SMARCC1, LONP2, MLYCD, RDH11, IDH2, IDH1, ECI2, STS, ... | GSE12251 | Enriched in responders |
| Unfolded Protein Response | 0.004 | 0.006 | 0.43 | 0.32 | 1.59 | 113 | PAIP1, DKC1, RPS14, CKS1B, NFYB, BANF1, GEMIN4, IMP3, EXOC2, EXOSC5, H2AX, PDIA6, FUS, NHP2, KHSRP, EEF2, CNOT2, TATDN2, WIPI1, SLC30A5, ... | GSE12251 | Enriched in responders |
| Myogenesis | 0.004 | 0.006 | 0.43 | -0.26 | -1.47 | 200 | ACSL1, FGF2, GADD45B, FST, SPHK1, PTP4A3, ADAM12, TNNT3, GJA5, DTNA, MYL4, ATP2A1, PDLIM7, MAPK12, RIT1, COL15A1, COL4A2, GSN, COX6A2, ACTN2, ... | GSE12251 | Enriched in nonresponders |
| Estrogen Response Early | 0.005 | 0.007 | 0.41 | -0.26 | -1.46 | 200 | GLA, KLK10, GREB1, OLFM1, RAB31, PRSS23, PTGES, PMAIP1, RARA, GJA1, CYP26B1, TMPRSS3, SH3BP5, CD44, FOXC1, TFAP2C, PLAAT3, PPIF, GAB2, ELOVL2, ... | GSE12251 | Enriched in nonresponders |
| Spermatogenesis | 0.005 | 0.008 | 0.41 | 0.29 | 1.52 | 135 | TSN, CFTR, SLC12A2, PEBP1, PIAS2, YBX2, STRBP, CCNB2, AURKA, RFC4, NEK2, CDK1, NPHP1, PCSK1N, GFI1, TTK, MAP7, ACE, TOPBP1, PSMG1, ... | GSE12251 | Enriched in responders |
| Androgen Response | 0.007 | 0.01 | 0.41 | 0.31 | 1.55 | 101 | SCD, HMGCR, B4GALT1, ZBTB10, HMGCS1, UAP1, GSR, KLK3, GPD1L, TPD52, DHCR24, SORD, UBE2J1, INSIG1, PA2G4, DBI, ANKH, ACSL3, MAP7, TSC22D1, ... | GSE12251 | Enriched in responders |
| Heme Metabolism | 0.009 | 0.013 | 0.38 | -0.25 | -1.41 | 200 | SNCA, SLC22A4, SLC25A37, BACH1, USP15, NFE2, PICALM, TSPAN5, CTSB, GYPB, ANK1, SEC14L1, LAMP2, FTCD, HBB, MYL4, BTG2, SMOX, EPB42, RCL1, ... | GSE12251 | Enriched in nonresponders |
| UV Response (up) | 0.012 | 0.017 | 0.38 | -0.26 | -1.41 | 158 | SOD2, NFKBIA, OLFM1, IL6, LYN, ARRB2, ICAM1, ATP6V1C1, RHOB, PPIF, TAP1, BTG2, DNAJA1, BTG1, CYB5R1, FOS, JUNB, RRAD, CDO1, HLA-F, ... | GSE12251 | Enriched in nonresponders |
| Estrogen Response Late | 0.036 | 0.048 | 0.32 | 0.24 | 1.30 | 200 | PLK4, IL17RB, MEST, MYB, DHCR7, PDCD4, FDFT1, STIL, CXCL14, LLGL2, PLXNB1, GINS2, IMPA2, CDC20, OVOL2, DCXR, FARP1, SORD, ST14, HR, ... | GSE12251 | Enriched in responders |
| Xenobiotic Metabolism | 0.069 | 0.088 | 0.25 | -0.23 | -1.26 | 200 | GABARAPL1, AQP9, SERPINE1, UPP1, NINJ1, KYNU, HSD11B1, PTGES, AOX1, BCAT1, SMOX, ARG1, ETS2, TPST1, CRP, AKR1C2, ENPEP, CYP4F2, MT2A, SLC6A6, ... | GSE12251 | Enriched in nonresponders |
| TGF beta Signaling | 0.095 | 0.119 | 0.21 | -0.31 | -1.34 | 54 | SERPINE1, PPP1R15A, RAB31, ENG, THBS1, JUNB, TGIF1, ARID4B, KLF10, TGFB1, BMPR2, SMAD3, PPM1A, WWTR1, UBE2D3, ACVR1, SMAD6, SLC20A1, CDKN1C | GSE12251 | Enriched in nonresponders |
| Pancreas beta Cells | 0.123 | 0.15 | 0.17 | 0.32 | 1.31 | 40 | FOXA2, NKX2-2, INSM1, GCG, PAX6, ISL1, CHGA, NEUROD1, PAK3, SLC2A2, SRP9, ELP4, SCGN, SRPRB, PCSK2, HNF1A, FOXO1, SST, SYT13, VDR | GSE12251 | Enriched in responders |
| Bile Acid Metabolism | 0.151 | 0.18 | 0.16 | 0.24 | 1.20 | 112 | AGXT, HSD17B4, ACSL5, HSD17B6, NR3C2, RBP1, DHCR24, ALDH9A1, PRDX5, ABCD3, CYP39A1, LONP2, MLYCD, TFCP2L1, IDH2, PEX1, NUDT12, IDH1, SOD1, GNPAT, ... | GSE12251 | Enriched in responders |
| KRAS Signaling (down) | 0.157 | 0.183 | 0.16 | -0.21 | -1.16 | 200 | MEFV, SERPINB2, EDN1, IFI44L, KLK8, MX1, SGK1, KLK7, BTG2, CHST2, PRKN, IL12B, EPHA5, ADRA2C, SPTBN2, CACNG1, PTGFR, CD80, TGFB2, SHOX2, ... | GSE12251 | Enriched in nonresponders |
| Protein Secretion | 0.169 | 0.191 | 0.15 | 0.24 | 1.17 | 96 | COG2, TPD52, SSPN, ARFGEF2, CLCN3, ICA1, OCRL, ATP1A1, COPE, SCAMP1, SOD1, AP2B1, RAB2A, TOM1L1, ARCN1, VPS45, YIPF6, CTSC, CLTA, M6PR, ... | GSE12251 | Enriched in responders |
| PI3K AKT Mtor Signaling | 0.172 | 0.191 | 0.15 | -0.23 | -1.17 | 105 | MAPK1, SLA, PTEN, STAT2, DAPP1, RALB, TBK1, MKNK1, GRK2, RIT1, ACTR2, TNFRSF1A, CXCR4, ADCY2, MYD88, ARF1, GSK3B, PRKCB, GRB2, SQSTM1, ... | GSE12251 | Enriched in nonresponders |
| Wnt beta Catenin Signaling | 0.328 | 0.357 | 0.10 | 0.26 | 1.07 | 42 | DVL2, HDAC2, AXIN2, PTCH1, TP53, SKP2 | GSE12251 | Enriched in responders |
| Hedgehog Signaling | 0.335 | 0.357 | 0.10 | -0.27 | -1.07 | 36 | NRP2, NRCAM, TLE3, PML, ETS2, HEY1, NF1, NRP1, PLG, NKX6-1, UNC5C, THY1, VEGFA | GSE12251 | Enriched in nonresponders |
| Notch Signaling | 0.866 | 0.902 | 0.05 | -0.19 | -0.72 | 32 | WNT5A, ST3GAL6, CCND1, WNT2, PPARD, HEYL, CUL1, PSEN2, NOTCH1, SAP30, DLL1, NOTCH3, NOTCH2, DTX1 | GSE12251 | Enriched in nonresponders |
| Apical Surface | 0.909 | 0.928 | 0.05 | 0.17 | 0.71 | 44 | B4GALT1, TMEM8B, PCSK9, BRCA1, ATP8B1, AKAP7, SHROOM2, NCOA6 | GSE12251 | Enriched in responders |
| Reactive Oxygen Species Pathway | 0.939 | 0.939 | 0.05 | -0.17 | -0.70 | 49 | SOD2, CDKN2D, JUNB, SBNO2, MBP, PRNP, PFKP, CAT, FES, MPO, FTL, G6PD | GSE12251 | Enriched in nonresponders |
| TNFA Signaling via NFkB | 6.19e-40 | 3.09e-38 | 1.65 | -0.62 | -3.72 | 200 | CXCL2, IL7R, TNC, SOD2, INHBA, CXCL6, DRAM1, TRAF1, PLAU, CEBPB, CXCL1, PDE4B, CD69, CFLAR, SOCS3, RIGI, PTGS2, IL6, CCL2, ACKR3, ... | GSE16879 | Enriched in nonresponders |
| Epithelial Mesenchymal Transition | 1.46e-37 | 3.65e-36 | 1.60 | -0.61 | -3.64 | 200 | PDLIM4, TNC, TFPI2, INHBA, CXCL6, MMP3, WNT5A, CXCL1, SPOCK1, FBN1, VCAN, GLIPR1, FAP, CXCL8, IL6, CDH11, VIM, TNFRSF11B, CALU, LOX, ... | GSE16879 | Enriched in nonresponders |
| Inflammatory Response | 6.15e-33 | 1.02e-31 | 1.50 | -0.58 | -3.48 | 200 | PDPN, IL7R, INHBA, CXCL6, RNF144B, PDE4B, CD69, CXCL8, IL6, CCL2, CSF3, LY6E, IL18RAP, TLR1, RGS1, IL10, GPR183, ABCA1, CCL22, SELE, ... | GSE16879 | Enriched in nonresponders |
| Interferon Gamma Response | 3.65e-30 | 4.56e-29 | 1.42 | -0.57 | -3.38 | 200 | SOD2, CD86, IFIT3, C1S, PDE4B, CD69, SOCS3, RIGI, PTGS2, IL6, CCL2, ST8SIA4, LY6E, CSF2RB, SAMHD1, IFNAR2, P2RY14, MTHFD2, ICAM1, SOCS1, ... | GSE16879 | Enriched in nonresponders |
| Allograft Rejection | 2.29e-28 | 2.29e-27 | 1.38 | -0.56 | -3.31 | 200 | INHBA, IL11, SRGN, CD86, IL6, CCL2, ST8SIA4, IL18RAP, TLR1, FCGR2B, IL10, IFNAR2, FYB1, PTPRC, FLNA, CCL4, CCL22, ICAM1, IL1B, GLMN, ... | GSE16879 | Enriched in nonresponders |
| KRAS Signaling (up) | 1.34e-15 | 1.12e-14 | 1.02 | -0.45 | -2.65 | 200 | ETV1, AKAP12, IL7R, MMP10, INHBA, TMEM158, TRAF1, PLAU, PTGS2, MAFB, TFPI, CAB39L, IL33, FCER1G, GFPT2, LY96, HSD11B1, IL1B, ETV5, G0S2, ... | GSE16879 | Enriched in nonresponders |
| IL6 JAK STAT3 Signaling | 3.32e-15 | 2.37e-14 | 1.01 | -0.59 | -3.04 | 87 | CXCL1, SOCS3, IL6, CSF2RB, CXCL3, IL1R1, IL1B, SOCS1, IL6ST, CD14, CXCL10, PDGFC, TLR2, MAP3K8, CSF2, CD44, CXCL9, GRB2, IL3RA, OSMR, ... | GSE16879 | Enriched in nonresponders |
| Complement | 4.02e-13 | 2.51e-12 | 0.93 | -0.42 | -2.50 | 200 | TFPI2, CEBPB, CXCL1, MMP12, S100A9, C1S, IL6, ZEB1, GNB4, CTSL, LAMP2, ANXA5, FCER1G, SERPINE1, PLA2G7, LCP2, SERPING1, GZMK, GNG2, PRCP, ... | GSE16879 | Enriched in nonresponders |
| IL2 STAT5 Signaling | 1.04e-10 | 5.76e-10 | 0.84 | -0.39 | -2.34 | 199 | TRAF1, LRRC8C, CD86, RRAGD, PRNP, IL10, CTLA4, PHLDA1, SOCS1, DENND5A, LIF, CXCL10, CST7, SLC2A3, NRP1, TNFRSF4, CD48, XBP1, HIPK2, RORA, ... | GSE16879 | Enriched in nonresponders |
| Interferon Alpha Response | 1.38e-10 | 6.89e-10 | 0.83 | -0.50 | -2.62 | 97 | IFIT3, C1S, LY6E, IFIH1, PROCR, CXCL10, IFIT2, IFI44L, SELL, RIPK2, EPSTI1, TRIM14, TRIM5, SAMD9L, ISG20, ELF1, IFI30, WARS1, IFITM2, TXNIP, ... | GSE16879 | Enriched in nonresponders |
| MYC Targets V1 | 4.99e-9 | 2.27e-8 | 0.76 | -0.36 | -2.17 | 200 | HNRNPC, CANX, XPOT, HNRNPD, MRPL9, BUB3, NAP1L1, EIF2S1, NOP56, ABCE1, PRDX4, DDX21, SYNCRIP, SERBP1, SF3A1, HDDC2, RSL1D1, PRPF31, UBA2, SRSF2, ... | GSE16879 | Enriched in nonresponders |
| Unfolded Protein Response | 1.76e-8 | 7.34e-8 | 0.73 | -0.43 | -2.33 | 113 | CEBPB, CCL2, MTHFD2, HERPUD1, XPOT, XBP1, CNOT2, DNAJB9, ASNS, SDAD1, SPCS3, SRPRA, DCP1A, NFYB, FKBP14, EIF2S1, SLC7A5, NOP56, ATF6, PSAT1, ... | GSE16879 | Enriched in nonresponders |
| UV Response (down) | 4.75e-7 | 1.83e-6 | 0.67 | -0.38 | -2.16 | 144 | IGFBP5, NR3C1, PTGFR, ADGRL2, PRKAR2B, SDC2, CAV1, TFPI, SYNE1, CCN1, SERPINE1, RGS4, AKT3, PTPRM, NRP1, LAMC1, COL5A2, FZD2, FYN, ATRX, ... | GSE16879 | Enriched in nonresponders |
| Apoptosis | 1.44e-6 | 5.04e-6 | 0.64 | -0.35 | -2.05 | 161 | HGF, SOD2, CYLD, CAV1, CD69, CFLAR, IL6, DPYD, TIMP3, DCN, IL1B, F2R, CD14, PMAIP1, ROCK1, LUM, BTG2, CD44, MMP2, IER3, ... | GSE16879 | Enriched in nonresponders |
| Fatty Acid Metabolism | 1.61e-6 | 5.04e-6 | 0.64 | 0.37 | 1.97 | 156 | BLVRA, HADH, RAP1GDS1, HMGCS2, CA4, CRAT, HSD17B11, ACOX1, HMGCL, EHHADH, TP53INP2, RETSAT, MLYCD, SLC22A5, DHCR24, HIBCH, CPT1A, PPARA, ACSL5, GAD2, ... | GSE16879 | Enriched in responders |
| Hypoxia | 1.57e-6 | 5.04e-6 | 0.64 | -0.32 | -1.93 | 200 | AKAP12, NR3C1, STC1, SDC2, CAV1, RRAGD, IL6, ACKR3, LOX, CCN1, TPST2, DCN, PNRC1, SIAH2, SAP30, RBPJ, SERPINE1, CAVIN1, IDS, SLC2A3, ... | GSE16879 | Enriched in nonresponders |
| Coagulation | 3.61e-6 | 1.06e-5 | 0.63 | -0.36 | -2.04 | 138 | TFPI2, MMP10, MMP3, PLAU, FBN1, C1S, THBD, LAMP2, TIMP3, SERPINE1, CTSK, SERPING1, PECAM1, DUSP14, MMP8, FYN, MMP2, CFH, MMP1, CPQ, ... | GSE16879 | Enriched in nonresponders |
| mTORC1 Signaling | 7.70e-6 | 2.14e-5 | 0.59 | -0.31 | -1.85 | 200 | IGFBP5, STC1, NIBAN1, MTHFD2, SLA, CANX, SERPINH1, ACTR3, SLC2A3, ELOVL5, NAMPT, XBP1, BTG2, ASNS, BCAT1, SLC6A6, SHMT2, SKAP2, CTSC, NUFIP1, ... | GSE16879 | Enriched in nonresponders |
| E2f Targets | 1.01e-5 | 2.67e-5 | 0.59 | -0.32 | -1.88 | 199 | NBN, MTHFD2, HNRNPD, ANP32E, HMGA1, BRCA2, RFC1, SMC3, PSIP1, NAP1L1, EIF2S1, NOP56, PRDX4, SYNCRIP, SNRPB, TP53, PRPS1, STMN1, CNOT9, SLBP, ... | GSE16879 | Enriched in nonresponders |
| Apical Junction | 6.69e-5 | 1.67e-4 | 0.54 | -0.29 | -1.74 | 200 | TRAF1, AMIGO2, MAP3K20, CD86, FBN1, VCAN, CDH11, TNFRSF11B, FYB1, PTPRC, ICAM1, AKT3, SIRPA, NEXN, GNAI1, MSN, PECAM1, MMP2, RAC2, CLDN19, ... | GSE16879 | Enriched in nonresponders |
| Angiogenesis | 1.84e-4 | 4.18e-4 | 0.52 | -0.52 | -2.18 | 36 | CXCL6, STC1, VCAN, THBD, MSX1, FSTL1, LUM, NRP1, COL5A2, COL3A1, S100A4, TIMP1, ITGAV, KCNJ8, LPL, OLR1, SPP1 | GSE16879 | Enriched in nonresponders |
| G2/M Checkpoint | 1.76e-4 | 4.18e-4 | 0.52 | -0.28 | -1.67 | 200 | DMD, MEIS1, MAP3K20, SAP30, HNRNPD, HMGA1, ATRX, BRCA2, SRSF10, BUB3, MAPK14, FBXO5, HIF1A, RBL1, SLC7A5, TGFB1, SYNCRIP, FOXN3, BUB1, CDC27, ... | GSE16879 | Enriched in nonresponders |
| Oxidative Phosphorylation | 0.002 | 0.003 | 0.46 | 0.29 | 1.58 | 199 | MGST3, RETSAT, CPT1A, BAX, ATP5F1E, NDUFB8, SLC25A4, PDP1, MPC1, CYCS, UQCRC1, AFG3L2, SDHA, IDH3G, VDAC3, SLC25A20, ECI1, OGDH, NDUFB1, ACADVL, ... | GSE16879 | Enriched in responders |
| Bile Acid Metabolism | 0.002 | 0.004 | 0.43 | 0.33 | 1.69 | 112 | BBOX1, PEX26, ABCG8, ABCA2, HSD17B11, RETSAT, NR1I2, MLYCD, SLC27A2, DHCR24, NR3C2, AMACR, PXMP2, ACSL5, PEX16, TFCP2L1, PAOX, EPHX2, PEX19, RBP1, ... | GSE16879 | Enriched in responders |
| UV Response (up) | 0.003 | 0.005 | 0.43 | -0.27 | -1.58 | 158 | CXCL2, SOD2, IL6, HSPA13, ICAM1, MSX1, PDLIM3, IL6ST, E2F5, BTG2, OLFM1, ASNS, BTG3, NFKBIA, RASGRP1, MMP14, EIF5, DDX21, PPIF, FGF18, ... | GSE16879 | Enriched in nonresponders |
| Androgen Response | 0.01 | 0.02 | 0.38 | -0.29 | -1.53 | 101 | AKAP12, PTK2B, ABCC4, STEAP4, TNFAIP8, ELL2, ELOVL5, SLC38A2, ADAMTS1, DNAJB9, ARID5B, MAK, SPCS3, ACTN1, CAMKK2, GUCY1A1, ELK4, NGLY1, LMAN1, UBE2J1, ... | GSE16879 | Enriched in nonresponders |
| Peroxisome | 0.012 | 0.022 | 0.38 | 0.30 | 1.52 | 104 | ABCC5, CADM1, CRAT, HSD17B11, ACOX1, HMGCL, EHHADH, RETSAT, NR1I2, MLYCD, CLN6, SLC27A2, DHCR24, HSD11B2, PEX5, ACSL5, ACOT8, SLC25A4, CACNA1B, SEMA3C, ... | GSE16879 | Enriched in responders |
| Myogenesis | 0.034 | 0.061 | 0.32 | -0.22 | -1.32 | 200 | DMD, FHL1, PRNP, COL6A3, FST, IGFBP7, COL15A1, WWTR1, PDE4DIP, FGF2, COL4A2, COL3A1, PTP4A3, SCHIP1, HSPB8, SPARC, COL1A1, SVIL, MEF2C, PKIA, ... | GSE16879 | Enriched in nonresponders |
| PI3K AKT Mtor Signaling | 0.039 | 0.066 | 0.32 | -0.25 | -1.34 | 105 | CAB39L, SLA, PRKAA2, ITPR2, ACTR3, PLCB1, GRB2, PRKCB, PTPN11, CXCR4, LCK, CAMK4, PIKFYVE, RPS6KA3, PTEN, RAF1, HSP90B1, RAC1, THEM4, DAPP1, ... | GSE16879 | Enriched in nonresponders |
| Heme Metabolism | 0.04 | 0.066 | 0.28 | 0.24 | 1.32 | 200 | TAL1, SELENBP1, BLVRA, NFE2L1, ENDOD1, IGSF3, BACH1, MKRN1, SLC30A10, LPIN2, FBXO34, MGST3, SNCA, RAP1GAP, CA1, ABCG2, BSG, RIOK3, RANBP10, MOCOS, ... | GSE16879 | Enriched in responders |
| Estrogen Response Early | 0.052 | 0.083 | 0.24 | 0.23 | 1.30 | 200 | ENDOD1, RETREG1, SLC1A1, TJP3, NADSYN1, OVOL2, MAPT, RAB17, PDZK1, AKAP1, SLC22A5, SYT12, SLC26A2, SCNN1A, SLC27A2, MINDY1, LRIG1, NBL1, SEMA3B, ASB13, ... | GSE16879 | Enriched in responders |
| Xenobiotic Metabolism | 0.072 | 0.113 | 0.20 | 0.23 | 1.26 | 200 | GART, PLG, ENTPD5, LPIN2, ACOX1, CYP2S1, RETSAT, RAP1GAP, CSAD, PTGR1, ABHD6, ANGPTL3, SPINT2, ASL, ACOX3, HNF4A, MAOA, SLC46A3, TMEM176B, CYP17A1, ... | GSE16879 | Enriched in responders |
| MYC Targets V2 | 0.086 | 0.131 | 0.24 | -0.28 | -1.33 | 58 | DUSP2, SLC19A1, NOP56, MPHOSPH10, SRM, CBX3, RCL1, NPM1, MYC, MRTO4, PPRC1, IMP4, BYSL, TFB2M, NOLC1, GNL3, HSPD1, PRMT3, PLK4, PES1, ... | GSE16879 | Enriched in nonresponders |
| Mitotic Spindle | 0.103 | 0.151 | 0.25 | -0.20 | -1.18 | 199 | CEP72, FLNA, CCDC88A, PKD2, HOOK3, NIN, ROCK1, PREX1, CEP57, KNTC1, DOCK2, BRCA2, CNTRL, RFC1, FBXO5, SMC3, MARK4, MAPRE1, KIF1B, ARHGEF2, ... | GSE16879 | Enriched in nonresponders |
| Adipogenesis | 0.124 | 0.177 | 0.15 | 0.22 | 1.19 | 200 | APLP2, HADH, ESRRA, ADCY6, ATP1B3, CRAT, ACOX1, MGST3, RETSAT, SLC25A1, RIOK3, HIBCH, ARL4A, TKT, ITSN1, PHLDB1, PFKL, SCARB1, UQCRC1, ADIPOR2, ... | GSE16879 | Enriched in responders |
| p53 Pathway | 0.139 | 0.193 | 0.21 | -0.19 | -1.15 | 200 | DRAM1, TM7SF3, NINJ1, IER5, SOCS1, LIF, F2R, PROCR, BTG2, RHBDF2, IER3, RGS16, DEF6, IL1A, PTPRE, S100A4, ZFP36L1, IFI30, FBXW7, TGFB1, ... | GSE16879 | Enriched in nonresponders |
| TGF beta Signaling | 0.187 | 0.252 | 0.16 | -0.26 | -1.20 | 54 | RAB31, SERPINE1, WWTR1, HIPK2, TGFB1, TRIM33, KLF10, TGFBR1, ACVR1, JUNB, THBS1, PMEPA1, BMPR2, MAP3K7, XIAP, LTBP2, TGIF1, FNTA, NOG, ARID4B, ... | GSE16879 | Enriched in nonresponders |
| Hedgehog Signaling | 0.209 | 0.275 | 0.15 | -0.29 | -1.21 | 36 | NRCAM, NRP2, RTN1, NRP1, CRMP1, HEY2, PML, THY1, TLE3, DPYSL2, HEY1, CDK6 | GSE16879 | Enriched in nonresponders |
| Glycolysis | 0.217 | 0.277 | 0.11 | 0.20 | 1.13 | 200 | MPI, POLR3K, IDUA, AGRN, B4GALT4, SLC37A4, PHKA2, SDC3, B3GNT3, CLN6, GLCE, ARTN, PPIA, MXI1, EFNA3, ELF3, FAM162A, CHST6, B4GALT2, CLDN3, ... | GSE16879 | Enriched in responders |
| KRAS Signaling (down) | 0.221 | 0.277 | 0.11 | 0.20 | 1.12 | 200 | NR6A1, IDUA, SSTR4, FGFR3, DTNB, ASB7, KCND1, KLK8, P2RX6, HSD11B2, GPRC5C, KCNQ2, HNF1A, MYO15A, TFCP2L1, SKIL, FSHB, RGS11, EPHA5, BMPR1B, ... | GSE16879 | Enriched in responders |
| Cholesterol Homeostasis | 0.238 | 0.29 | 0.11 | 0.25 | 1.15 | 74 | ACSS2, ABCA2, CD9, SEMA3B, GUSB, NSDHL, LGALS3, FDFT1, LSS, CBS, EBP, PPARG, DHCR7, PCYT2, HMGCS1, CLU, CHKA, ADH4, TRIB3, ETHE1, ... | GSE16879 | Enriched in responders |
| Estrogen Response Late | 0.339 | 0.404 | 0.08 | 0.19 | 1.06 | 200 | LLGL2, HMGCS2, TJP3, OVOL2, FGFR3, MAPT, PDZK1, CKB, PRLR, CD9, SLC22A5, SLC26A2, SCNN1A, SLC27A2, EMP2, ASCL1, NBL1, LARGE1, SEMA3B, HOMER2, ... | GSE16879 | Enriched in responders |
| Protein Secretion | 0.572 | 0.65 | 0.09 | -0.18 | -0.95 | 96 | CAV2, LAMP2, ABCA1, PAM, ANP32E, CTSC, KIF1B, LMAN1, SNX2, PPT1, SSPN, BNIP3, RPS6KA3, STX7, VAMP4, GLA, VAMP7, M6PR, TMX1 | GSE16879 | Enriched in nonresponders |
| Notch Signaling | 0.564 | 0.65 | 0.07 | 0.25 | 0.93 | 32 | PRKCA, ARRB1, PSEN2, TCF7L2, KAT2A, FZD5, DTX4, HES1, LFNG, HEYL | GSE16879 | Enriched in responders |
| Apical Surface | 0.603 | 0.67 | 0.06 | 0.22 | 0.90 | 44 | HSPB1, SLC2A4, EPHB4, ADIPOR2, NCOA6, CD160, SLC34A3, ATP8B1, ADAM10, APP, TMEM8B, PCSK9, DCBLD2, AKAP7 | GSE16879 | Enriched in responders |
| Wnt beta Catenin Signaling | 0.762 | 0.828 | 0.05 | 0.20 | 0.81 | 42 | LEF1, HDAC11, PSEN2, AXIN2, KAT2A, JAG2, NKD1, FZD8, WNT6, NCOR2, MAML1, HDAC5, AXIN1 | GSE16879 | Enriched in responders |
| Reactive Oxygen Species Pathway | 0.911 | 0.968 | 0.06 | -0.16 | -0.74 | 49 | SOD2, PRNP, PRDX4, IPCEF1, HHEX, GCLC, JUNB, GPX3, CAT, ERCC2, LSP1, GLRX, GCLM, CDKN2D, GPX4, SBNO2, ABCC1, FES, FTL, G6PD, ... | GSE16879 | Enriched in nonresponders |
| Pancreas beta Cells | 0.929 | 0.968 | 0.06 | -0.16 | -0.68 | 40 | MAFB, AKT3, ELP4, LMO2, IAPP, SRPRB | GSE16879 | Enriched in nonresponders |
| DNA Repair | 0.989 | 0.991 | 0.06 | -0.12 | -0.71 | 150 | PDE4B, GTF2H5, BRF2, GTF2H1, HCLS1, POLB, TP53, RFC3, ELL, REV3L, SNAPC5, BCAM, CLP1, GTF2B, ADA, ERCC8, ERCC1, ELOA, TYMS, PCNA, ... | GSE16879 | Enriched in nonresponders |
| Spermatogenesis | 0.991 | 0.991 | 0.06 | -0.12 | -0.68 | 135 | IL13RA2, DMC1, GSTM3, JAM3, PACRG, CFTR, SHE, MLF1, BUB1, CAMK4, LDHC, SLC2A5, GFI1, PDHA2, PARP2, TLE4, RAD17, ACE, COIL, NCAPH | GSE16879 | Enriched in nonresponders |
| Interferon Gamma Response | 7.32e-26 | 3.66e-24 | 1.32 | -0.54 | -3.14 | 200 | SELP, IFIT1, SAMHD1, SP110, CASP4, FCGR1A, P2RY14, B2M, IFIT2, FGL2, IFI44, HLA-DQA1, PTGS2, IFNAR2, TXNIP, ST3GAL5, IL6, SOD2, IFIT3, ST8SIA4, ... | GSE23597 | Enriched in nonresponders |
| Oxidative Phosphorylation | 2.90e-25 | 7.25e-24 | 1.30 | 0.53 | 3.15 | 199 | IDH2, MTRF1, IDH3G, MRPS30, UQCRC1, OPA1, UQCRFS1, ALDH6A1, MRPL35, ACO2, VDAC1, NDUFB8, PDHX, ECH1, FH, MRPL11, MRPS12, IDH1, NNT, SLC25A11, ... | GSE23597 | Enriched in responders |
| Inflammatory Response | 1.13e-22 | 1.88e-21 | 1.23 | -0.52 | -3.00 | 200 | RNF144B, TNFSF15, P2RX7, SELE, INHBA, PSEN1, IL6, OSM, TLR1, IFITM1, PIK3R5, FPR1, LPAR1, NAMPT, RGS16, PTPRE, SERPINE1, ITGB8, LAMP3, TACR3, ... | GSE23597 | Enriched in nonresponders |
| TNFA Signaling via NFkB | 2.76e-22 | 3.45e-21 | 1.22 | -0.51 | -2.98 | 200 | CD80, BCL6, EGR1, IFIT2, TNF, PTGS2, INHBA, DUSP1, IL6, SOD2, CEBPB, ZFP36, SLC16A6, DENND5A, KDM6B, KLF2, IER5, CFLAR, SNN, SOCS3, ... | GSE23597 | Enriched in nonresponders |
| E2f Targets | 9.36e-21 | 9.36e-20 | 1.18 | 0.50 | 2.94 | 199 | DEPDC1, RAD50, TRIP13, HELLS, RACGAP1, RAN, RAD51AP1, DLGAP5, HMMR, TMPO, GSPT1, UNG, UBR7, HMGB3, BARD1, MSH2, TK1, ASF1B, LIG1, CDK1, ... | GSE23597 | Enriched in responders |
| Allograft Rejection | 5.51e-16 | 4.59e-15 | 1.03 | -0.46 | -2.66 | 200 | CD80, B2M, SRGN, TNF, HLA-DQA1, BCAT1, IFNAR2, INHBA, IL6, FCGR2B, TGFB2, GBP2, IFNGR1, ST8SIA4, HLA-A, PTPRC, TLR1, GPR65, IL11, FYB1, ... | GSE23597 | Enriched in nonresponders |
| G2/M Checkpoint | 1.39e-15 | 9.90e-15 | 1.02 | 0.45 | 2.68 | 200 | SLC12A2, CHAF1A, LIG3, PRC1, RACGAP1, TTK, NUMA1, SMC2, HMMR, TMPO, GSPT1, STIL, TFDP1, BCL3, TPX2, UBE2C, HMGB3, BARD1, KMT5A, NSD2, ... | GSE23597 | Enriched in responders |
| MYC Targets V1 | 2.16e-15 | 1.35e-14 | 1.01 | 0.45 | 2.66 | 200 | TXNL4A, SERBP1, RAN, RUVBL2, HDAC2, RPS2, GSPT1, TFDP1, POLE3, YWHAE, DDX18, VDAC1, ILF2, EIF3B, PHB1, SMARCC1, RANBP1, PCNA, MCM4, PPIA, ... | GSE23597 | Enriched in responders |
| Glycolysis | 1.26e-13 | 7.01e-13 | 0.94 | 0.43 | 2.55 | 200 | PYGB, PKP2, SOX9, SLC25A10, CLDN3, DEPDC1, PC, SLC35A3, CAPN5, ELF3, B4GALT4, GNE, TKTL1, DSC2, CLN6, GMPPB, GLCE, HMMR, GFPT1, EFNA3, ... | GSE23597 | Enriched in responders |
| Interferon Alpha Response | 3.57e-11 | 1.78e-10 | 0.85 | -0.51 | -2.64 | 97 | SP110, B2M, IFIT2, IFI44, TXNIP, IFIT3, GBP2, IFITM2, IFITM1, NCOA7, MX1, HLA-C, LAMP3, RIPK2, LY6E, BST2, IRF7, WARS1, CD47, SELL, ... | GSE23597 | Enriched in nonresponders |
| Fatty Acid Metabolism | 4.32e-10 | 1.96e-9 | 0.81 | 0.41 | 2.36 | 156 | PPARA, GSTZ1, FASN, ACSL5, IDH3G, GPD2, SUCLG2, UGDH, ACO2, DHCR24, ECH1, FH, BCKDHB, CPOX, ECI2, IDH1, KMT5A, ALDH3A2, YWHAH, SUCLA2, ... | GSE23597 | Enriched in responders |
| Epithelial Mesenchymal Transition | 5.39e-10 | 2.24e-9 | 0.80 | -0.39 | -2.25 | 200 | LOXL2, TFPI2, TGFBI, SLIT2, INHBA, CAP2, IL6, SFRP1, VIM, NTM, MSX1, GLIPR1, RGS4, SERPINE1, TNFRSF11B, TPM4, CALD1, CDH11, GADD45B, SAT1, ... | GSE23597 | Enriched in nonresponders |
| Adipogenesis | 1.30e-8 | 5.01e-8 | 0.75 | 0.36 | 2.16 | 200 | SLC25A10, CMBL, IDH3G, GPD2, UQCRC1, ELOVL6, COQ9, PFKL, ACO2, MCCC1, ECH1, APLP2, COQ3, IDH1, CMPK1, SLC25A1, SOWAHC, DLAT, UQCR10, ACOX1, ... | GSE23597 | Enriched in responders |
| mTORC1 Signaling | 1.63e-7 | 5.81e-7 | 0.69 | 0.35 | 2.04 | 200 | SORD, GSR, CALR, EBP, UCHL5, TXNRD1, SCD, TMEM97, ELOVL6, ACSL3, PFKL, GCLC, DHCR24, UNG, PSMC2, SC5D, IDH1, CCNG1, HK2, CD9, ... | GSE23597 | Enriched in responders |
| Protein Secretion | 2.63e-7 | 8.77e-7 | 0.67 | 0.43 | 2.24 | 96 | CLCN3, TPD52, ARCN1, ATP1A1, RAB2A, ICA1, TOM1L1, GBF1, COG2, ARFGEF1, ARFGEF2, GOLGA4, VPS4B, AP2B1, RAB14, RPS6KA3, ARFIP1, SCAMP1, OCRL, M6PR, ... | GSE23597 | Enriched in responders |
| Complement | 4.05e-7 | 1.27e-6 | 0.67 | -0.34 | -1.96 | 200 | DOCK4, TFPI2, SH2B3, CASP4, CP, F5, CDK5R1, ZEB1, PSEN1, IL6, CEBPB, LIPA, AKAP10, PIK3R5, SERPINE1, EHD1, GRB2, PIK3CA, CR1, LCP2, ... | GSE23597 | Enriched in nonresponders |
| IL6 JAK STAT3 Signaling | 1.50e-6 | 4.41e-6 | 0.64 | -0.43 | -2.17 | 87 | TNF, CRLF2, IL6, IFNGR1, IL17RA, SOCS3, PIK3R5, CBL, CSF2RB, CCR1, GRB2, A2M, CSF3R, TNFRSF1B, IL1B, PTPN1, STAT3, OSMR, PIM1, IL4R, ... | GSE23597 | Enriched in nonresponders |
| Mitotic Spindle | 4.61e-6 | 1.28e-5 | 0.61 | 0.32 | 1.91 | 199 | ABR, PRC1, CD2AP, NET1, RACGAP1, VCL, TTK, CDC42EP4, NUMA1, ECT2, DLGAP5, GSN, PCGF5, YWHAE, EZR, MYO1E, TPX2, ARHGDIA, ARFGEF1, BCAR1, ... | GSE23597 | Enriched in responders |
| Estrogen Response Late | 6.66e-6 | 1.75e-5 | 0.61 | 0.31 | 1.86 | 200 | PLXNB1, SORD, FRK, MEST, LSR, MYB, ST14, EMP2, HR, IMPA2, CDH1, IDH2, AGR2, BAG1, SCNN1A, OVOL2, SLC27A2, IL17RB, UGDH, STIL, ... | GSE23597 | Enriched in responders |
| Peroxisome | 9.07e-6 | 2.27e-5 | 0.59 | 0.38 | 2.03 | 104 | NUDT19, ACSL5, IDH2, PEX13, CTBP1, SLC27A2, CLN6, HSD11B2, DHCR24, ABCD3, ECH1, PRDX5, IDE, ECI2, IDH1, MSH2, SMARCC1, VPS4B, PEX11B, YWHAH, ... | GSE23597 | Enriched in responders |
| DNA Repair | 9.75e-6 | 2.32e-5 | 0.59 | 0.34 | 1.92 | 150 | CANT1, UMPS, RFC5, VPS37B, ZWINT, GTF2H5, POLR1H, CSTF3, RAD51, LIG1, ITPA, PCNA, IMPDH2, UPF3B, ELOA, GTF2F1, MPC2, TP53, POLR2J, NPR2, ... | GSE23597 | Enriched in responders |
| IL2 STAT5 Signaling | 5.19e-5 | 1.18e-4 | 0.56 | -0.31 | -1.79 | 199 | SELP, FGL2, LRRC8C, BMPR2, DENND5A, IFNGR1, BCL2, GLIPR2, GPR65, CD86, HUWE1, RGS16, ETFBKMT, BCL2L1, TNFRSF18, TRAF1, RHOH, IRF4, PTH1R, HIPK2, ... | GSE23597 | Enriched in nonresponders |
| KRAS Signaling (up) | 2.86e-4 | 6.21e-4 | 0.50 | -0.28 | -1.64 | 200 | TFPI, PDCD1LG2, PTGS2, INHBA, SATB1, TLR8, LAT2, PECAM1, IKZF1, CBL, G0S2, PEG3, ETV1, RGS16, ETV5, NIN, HSD11B1, TRAF1, TNFRSF1B, EMP1, ... | GSE23597 | Enriched in nonresponders |
| Spermatogenesis | 3.26e-4 | 6.79e-4 | 0.50 | 0.31 | 1.72 | 135 | MAP7, SLC12A2, PRKAR2A, CFTR, ZC2HC1C, TKTL1, PEBP1, MAST2, TTK, IDE, IFT88, STAM2, NCAPH, ZC3H14, CDK1, AGFG1, PAPOLB, NEK2, CAMK4, BUB1, ... | GSE23597 | Enriched in responders |
| MYC Targets V2 | 4.92e-4 | 9.84e-4 | 0.48 | 0.40 | 1.87 | 58 | SORD, TMEM97, DDX18, UNG, MYBBP1A, PHB1, HK2, NIP7, MCM4, DCTPP1, PLK4, PA2G4, RRP9, TBRG4, SLC29A2, IPO4, PRMT3, NOLC1 | GSE23597 | Enriched in responders |
| Apoptosis | 0.002 | 0.003 | 0.46 | -0.29 | -1.61 | 161 | CASP4, TNF, TXNIP, PSEN1, SATB1, IL6, SOD2, TGFB2, IFNGR1, CFLAR, HGF, BCL2L1, SQSTM1, GADD45B, SAT1, RHOB, EMP1, IL1B, BTG2, CYLD, ... | GSE23597 | Enriched in nonresponders |
| Xenobiotic Metabolism | 0.002 | 0.004 | 0.43 | 0.26 | 1.54 | 200 | HES6, GSR, PC, ABCC3, SLC35D1, JUP, TMEM97, RAP1GAP, UGDH, GSS, SPINT2, ACO2, GCLC, ECH1, AHCY, HNF4A, LCAT, IDH1, ETS2, DDC, ... | GSE23597 | Enriched in responders |
| Estrogen Response Early | 0.003 | 0.005 | 0.43 | 0.26 | 1.51 | 200 | FRK, MYB, HR, FASN, ELF3, BAG1, AKAP1, THSD4, CLDN7, CANT1, LAD1, SCNN1A, RAB17, OVOL2, SLC27A2, IL17RB, ESRP2, MUC1, MYBBP1A, NRIP1, ... | GSE23597 | Enriched in responders |
| Cholesterol Homeostasis | 0.004 | 0.006 | 0.43 | 0.33 | 1.64 | 74 | MVK, FASN, EBP, SCD, TMEM97, ANXA13, JAG1, ECH1, SC5D, MAL2, FDFT1, CD9, CHKA, ETHE1, DHCR7, HMGCR, ACSS2, TRIB3, CYP51A1, SQLE, ... | GSE23597 | Enriched in responders |
| PI3K AKT Mtor Signaling | 0.005 | 0.009 | 0.41 | 0.30 | 1.59 | 105 | PAK4, CALR, PRKAR2A, PRKAA2, TSC2, VAV3, ARHGDIA, RAC1, UBE2N, SMAD2, SLC2A1, SFN, CDK1, RPS6KA1, RPS6KA3, ECSIT, MAP2K6, CAMK4, PLA2G12A, CSNK2B, ... | GSE23597 | Enriched in responders |
| Androgen Response | 0.007 | 0.011 | 0.41 | 0.29 | 1.57 | 101 | SORD, GSR, MAP7, TPD52, SPDEF, SCD, TMPRSS2, SELENOP, ACSL3, DHCR24, UAP1, B4GALT1, RPS6KA3, H1-0, KRT19, STK39, RAB4A, PDLIM5, SEC24D, PA2G4, ... | GSE23597 | Enriched in responders |
| Hypoxia | 0.01 | 0.015 | 0.38 | -0.25 | -1.44 | 200 | WSB1, CP, STC1, TGFBI, IDS, KLHL24, DUSP1, IL6, JMJD6, ZFP36, BCL2, S100A4, PGF, SERPINE1, GAPDH, CSRP2, ZNF292, CXCR4, BTG1, NFIL3, ... | GSE23597 | Enriched in nonresponders |
| Unfolded Protein Response | 0.01 | 0.016 | 0.38 | 0.28 | 1.54 | 113 | PAIP1, CALR, YWHAZ, LSM4, SLC30A5, KHSRP, TUBB2A, DKC1, SERP1, ALDH18A1, EIF4A3, KIF5B, DNAJC3, RRP9, NFYA, H2AX, HSPA9, SKIC3, CNOT6, PDIA6, ... | GSE23597 | Enriched in responders |
| Angiogenesis | 0.017 | 0.024 | 0.35 | -0.39 | -1.56 | 36 | STC1, FGFR1, KCNJ8, S100A4, MSX1, JAG2, NRP1, THBD, APOH, OLR1, TIMP1, CXCL6, SLCO2A1, LUM, SPP1, LRPAP1 | GSE23597 | Enriched in nonresponders |
| Bile Acid Metabolism | 0.016 | 0.024 | 0.35 | 0.27 | 1.49 | 112 | TFCP2L1, ACSL5, IDH2, PEX13, SLC27A2, GCLM, PEX7, DHCR24, ABCD3, PRDX5, IDH1, AGXT, NR3C2, LIPE, NUDT12, NR1I2, PEX11A, SCP2, PEX16, SOD1, ... | GSE23597 | Enriched in responders |
| UV Response (down) | 0.029 | 0.039 | 0.35 | -0.25 | -1.37 | 144 | IGFBP5, TFPI, RUNX1, CDON, CAP2, DUSP1, CELF2, MAP1B, YTHDC1, LPAR1, SYNJ2, AKT3, RGS4, SCHIP1, SERPINE1, LTBP1, GRK5, PIK3CD, ZMIZ1, NRP1, ... | GSE23597 | Enriched in nonresponders |
| Apical Junction | 0.029 | 0.039 | 0.35 | -0.23 | -1.35 | 200 | CADM3, TRO, PKD1, TGFBI, SLIT2, ACTB, PBX2, CADM2, CNTN1, ICAM2, JAM3, PTPRC, PECAM1, FYB1, CD86, AKT3, TSPAN4, TNFRSF11B, TRAF1, CLDN11, ... | GSE23597 | Enriched in nonresponders |
| Pancreas beta Cells | 0.043 | 0.057 | 0.32 | 0.34 | 1.46 | 40 | FOXA2, NKX2-2, ELP4, PAX6, SYT13, GCG, NEUROD1, CHGA, SST, VDR, SRPRB, INSM1, HNF1A | GSE23597 | Enriched in responders |
| p53 Pathway | 0.065 | 0.083 | 0.29 | 0.21 | 1.27 | 200 | EI24, ST14, CEBPA, SLC35D1, KIF13B, GPX2, EPS8L2, PRKAB1, CCNG1, SFN, FUCA1, ABAT, PCNA, CLCA2, ACVR1B, CCNK, KLF4, SP1, TRAF4, NUDT15, ... | GSE23597 | Enriched in responders |
| Hedgehog Signaling | 0.103 | 0.126 | 0.19 | -0.33 | -1.35 | 36 | NRP2, CDK5R1, CDK6, TLE3, DPYSL2, HEY1, NRP1, NKX6-1, RTN1, L1CAM, THY1 | GSE23597 | Enriched in nonresponders |
| Coagulation | 0.103 | 0.126 | 0.19 | -0.23 | -1.24 | 138 | WDR1, TFPI2, PECAM1, TF, SERPINE1, A2M, CPQ, GP1BA, PRSS23, THBD, FYN, KLF7, S100A13, SH2B2, F12, F8, CTSB, LRP1, CAPN2, CRIP2, ... | GSE23597 | Enriched in nonresponders |
| KRAS Signaling (down) | 0.202 | 0.24 | 0.13 | -0.19 | -1.13 | 200 | CD80, TGFB2, SNN, MX1, SGK1, ARPP21, BTG2, IL12B, GP1BA, TAS2R4, SLC16A7, GDNF, RGS11, RIBC2, IFNG, EPHA5, KCNMB1, MYOT, NUDT11, SYNPO, ... | GSE23597 | Enriched in nonresponders |
| Notch Signaling | 0.235 | 0.273 | 0.13 | 0.28 | 1.16 | 32 | TCF7L2, JAG1, FZD5, DTX4, ARRB1, SKP1, APH1A, SAP30 | GSE23597 | Enriched in responders |
| Heme Metabolism | 0.364 | 0.414 | 0.10 | 0.17 | 1.03 | 200 | CLCN3, PC, TRIM10, XK, GCLM, XPO7, KLF3, DCAF10, RAP1GAP, ALDH6A1, GCLC, NUDT4, CPOX, MBOAT2, MKRN1, TFDP2, NNT, GDE1, SLC2A1, MFHAS1, ... | GSE23597 | Enriched in responders |
| UV Response (up) | 0.468 | 0.52 | 0.09 | 0.17 | 1.00 | 158 | SIGMAR1, MARK2, POLE3, AGO2, CLTB, CHKA, PTPRD, DGAT1, GGH, CDC34, KLHDC3, RXRB, CASP3, FKBP4, BMP2, AQP3, MAOA, H2AX, PDAP1, FEN1, ... | GSE23597 | Enriched in responders |
| Myogenesis | 0.498 | 0.542 | 0.07 | -0.17 | -0.98 | 200 | PTP4A3, WWTR1, FST, MYH8, SCHIP1, IGFBP7, GADD45B, SLC6A8, SGCD, MYL4, ACTN2, CKMT2, NCAM1, HSPB8, ACSL1, DTNA, KIFC3, CRYAB, MEF2C, TNNI2, ... | GSE23597 | Enriched in nonresponders |
| Reactive Oxygen Species Pathway | 0.709 | 0.755 | 0.07 | 0.19 | 0.86 | 49 | GSR, TXNRD1, GCLM, GCLC, MGST1, SOD1, PRDX2, OXSR1, ERCC2, PDLIM1, PFKP, PTPA, MSRA, HMOX2, NDUFA6, NQO1, NDUFS2, MPO, SELENOS | GSE23597 | Enriched in responders |
| TGF beta Signaling | 0.8 | 0.833 | 0.05 | -0.18 | -0.80 | 54 | ARID4B, BMPR2, RAB31, WWTR1, SERPINE1, HIPK2 | GSE23597 | Enriched in nonresponders |
| Apical Surface | 0.845 | 0.863 | 0.05 | -0.18 | -0.77 | 44 | MDGA1, LYN, PKHD1, THY1, ATP6V0A4, EFNA5, RTN4RL1, FLOT2, GATA3, SRPX, CX3CL1, HSPB1, MAL, AFAP1L2 | GSE23597 | Enriched in nonresponders |
| Wnt beta Catenin Signaling | 0.959 | 0.959 | 0.04 | -0.15 | -0.65 | 42 | GNAI1, JAG2, WNT1, HEY1, ADAM17, RBPJ, NUMB, TCF7, HDAC11, WNT6, PSEN2, LEF1, CUL1, NCOR2, NKD1, CCND2 | GSE23597 | Enriched in nonresponders |

## Table S5. Single-cell localization support summary (processed public references)
Numeric fields are rounded for readability; full-precision values are available in the corresponding TSV files.

| Reference | Dataset | Disease assignment | Cell state | Enrichment score | Median signature score | Cells (n) | Present signature genes (n) | Supporting genes | Interpretation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Epithelial | GSE116222 |  | Cycling | 0.125 | 0.136 | 579 | 64 | SRGN\|PTPRC\|GLIPR1\|CFLAR\|SOD2 | marker-based coarse epithelial state assignment from deposited expression matrix |
| Epithelial | GSE116222 |  | Stem/TA | 0.115 | 0.115 | 108 | 64 | SRGN\|PTPRC\|HLA-DQA1\|CFLAR\|SOD2 | marker-based coarse epithelial state assignment from deposited expression matrix |
| Epithelial | GSE116222 |  | Stress/inflammatory epithelial | 0.090 | 0.070 | 544 | 64 | CFLAR\|SOD2\|IER5\|CEBPB\|SRGN | marker-based coarse epithelial state assignment from deposited expression matrix |
| Epithelial | GSE116222 |  | Goblet (secretory) | 0.066 | 0.056 | 1510 | 64 | IER5\|CEBPB\|CFLAR\|SOD2\|SRGN | marker-based coarse epithelial state assignment from deposited expression matrix |
| Epithelial | GSE116222 |  | Regenerative (Notch) | 0.048 | 0.039 | 6315 | 64 | SOD2\|IER5\|CFLAR\|CEBPB\|SOCS3 | marker-based coarse epithelial state assignment from deposited expression matrix |
| Epithelial | GSE116222 |  | BEST4+ absorptive | 0.039 | 0.033 | 2052 | 64 | CFLAR\|SOD2\|IER5\|CEBPB\|SOCS3 | marker-based coarse epithelial state assignment from deposited expression matrix |
| Immune (rectum) | GSE125527 | diseased | M/DC | 0.583 | 0.587 | 259 | 40 | SRGN\|HLA-DQA1\|SOD2\|PTPRC\|GLIPR1 | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | diseased | NK | 0.241 | 0.237 | 283 | 40 | SRGN\|PTPRC\|TAGAP\|CFLAR\|NR4A3 | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | diseased | T | 0.210 | 0.208 | 10103 | 40 | SRGN\|PTPRC\|TAGAP\|SOCS3\|CFLAR | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | diseased | unknown | 0.175 | 0.174 | 560 | 40 | PTPRC\|SRGN\|HLA-DQA1\|TAGAP\|CFLAR | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | diseased | B | 0.170 | 0.160 | 5704 | 40 | HLA-DQA1\|SRGN\|PTPRC\|TAGAP\|SOCS3 | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | healthy | M/DC | 0.526 | 0.536 | 129 | 40 | SRGN\|HLA-DQA1\|SOD2\|PTPRC\|GLIPR1 | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | healthy | NK | 0.232 | 0.239 | 127 | 40 | SRGN\|PTPRC\|IER5\|TAGAP\|NR4A3 | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | healthy | T | 0.200 | 0.199 | 7130 | 40 | SRGN\|PTPRC\|TAGAP\|GLIPR1\|IER5 | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | healthy | B | 0.136 | 0.121 | 4753 | 40 | SRGN\|HLA-DQA1\|PTPRC\|CFLAR\|TAGAP | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |
| Immune (rectum) | GSE125527 | healthy | unknown | 0.132 | 0.127 | 324 | 40 | SRGN\|PTPRC\|TAGAP\|GLIPR1\|CFLAR | rectal immune-cell localization from sparse UMI matrix and deposited GEO metadata |

## Table S6. Class-level anti-TNF sensitivity analysis (GSE92415, golimumab-treated UC cohort)
This table reports the association between the fixed 68-gene consensus signature and Week 6 response status in the golimumab-treated UC cohort.

| Dataset | Therapy | Endpoint definition | Response window | Timepoint | N total | N responders | N nonresponders | Signature | Genes used (n) | Direction | Hedges g (nonresponder - responder) | Lower 95% CI | Upper 95% CI | P-value (Welch t-test) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| GSE92415 | golimumab | wk6response (Yes/No) | Week 6 response; baseline biopsy at Week 0 | Pretreatment baseline | 87 | 43 | 44 | Consensus signature (68 genes) | 68 | Higher in nonresponders | 0.50 | 0.07 | 0.92 | 0.022 |

## Table S7. Gene-set overlap and single-cell statistical tests
This table reports the gene-set overlap between the fixed consensus signature and the broader LODO training-derived axes, as well as global and pairwise single-cell statistical tests and cell-type gene means for the consensus signature.

### Sheet 1: GeneSetOverlap
This sheet reports the overlap between the fixed consensus signature (68 genes) and the broader LODO training-derived axes (held-out datasets).

| held_out_dataset | fixed_consensus_n | lodo_gene_set_n | overlap_n | fixed_genes_present_in_lodo_pct | lodo_genes_present_in_fixed_pct | jaccard_index | overlap_genes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| GSE12251 | 68 | 632 | 68 | 100.0% | 10.8% | 0.108 | BCL6, CD86, CD93, CEBPB, CFLAR, CHI3L1, CHST15, CLEC4E, COL8A1, CSF2RB, CSF3, CYRIA, DENND5A, FCGR1BP, FCGR2A, FST, FZD10, G0S2, GLIPR1, GLT1D1, ... |
| GSE16879 | 68 | 1007 | 68 | 100.0% | 6.8% | 0.068 | BCL6, CD86, CD93, CEBPB, CFLAR, CHI3L1, CHST15, CLEC4E, COL8A1, CSF2RB, CSF3, CYRIA, DENND5A, FCGR1BP, FCGR2A, FST, FZD10, G0S2, GLIPR1, GLT1D1, ... |
| GSE23597 | 68 | 524 | 68 | 100.0% | 13.0% | 0.130 | BCL6, CD86, CD93, CEBPB, CFLAR, CHI3L1, CHST15, CLEC4E, COL8A1, CSF2RB, CSF3, CYRIA, DENND5A, FCGR1BP, FCGR2A, FST, FZD10, G0S2, GLIPR1, GLT1D1, ... |

### Sheet 2: SingleCellGlobalTests
This sheet reports global Kruskal-Wallis test statistics and p-values for signature activity differences across cell types or states.

| reference | subset | test | grouping | n_groups | statistic | pvalue |
| --- | --- | --- | --- | --- | --- | --- |
| GSE116222 | epithelial_states | Kruskal-Wallis | assigned_state | 6 | 1023.96 | 3.91e-219 |
| GSE125527 | rectum_diseased | Kruskal-Wallis | celltype | 5 | 1611.70 | 0 |
| GSE125527 | rectum_healthy | Kruskal-Wallis | celltype | 5 | 2045.07 | 0 |

### Sheet 3: SingleCellPairwiseTests
This sheet reports pairwise Mann-Whitney U test statistics, direction, and adjusted p-values (Benjamini-Hochberg) for signature activity differences.

| reference | subset | test | grouping | group | comparator | n_group | n_comparator | group_mean | comparator_mean | direction | statistic | pvalue | p_adj_bh |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| GSE116222 | epithelial_states | Mann-Whitney U one-vs-rest | assigned_state | BEST4+ absorptive | all other groups | 2052 | 9056 | 0.0386 | 0.0593 | lower | 7290323 | 4.83e-53 | 9.66e-53 |
| GSE116222 | epithelial_states | Mann-Whitney U one-vs-rest | assigned_state | Cycling | all other groups | 579 | 10529 | 0.1254 | 0.0517 | higher | 4768842 | 3.38e-117 | 1.08e-116 |
| GSE116222 | epithelial_states | Mann-Whitney U one-vs-rest | assigned_state | Goblet (secretory) | all other groups | 1510 | 9598 | 0.0665 | 0.0538 | higher | 8359654 | 4.63e-22 | 6.74e-22 |
| GSE116222 | epithelial_states | Mann-Whitney U one-vs-rest | assigned_state | Regenerative (Notch) | all other groups | 6315 | 4793 | 0.0480 | 0.0654 | lower | 13188676 | 1.69e-31 | 2.70e-31 |
| GSE116222 | epithelial_states | Mann-Whitney U one-vs-rest | assigned_state | Stem/TA | all other groups | 108 | 11000 | 0.1150 | 0.0549 | higher | 843140 | 4.41e-14 | 5.04e-14 |
| GSE116222 | epithelial_states | Mann-Whitney U one-vs-rest | assigned_state | Stress/inflammatory epithelial | all other groups | 544 | 10564 | 0.0896 | 0.0538 | higher | 3736760 | 1.29e-32 | 2.29e-32 |
| GSE125527 | rectum_diseased | Mann-Whitney U one-vs-rest | celltype | B | all other groups | 5704 | 11205 | 0.1700 | 0.2172 | lower | 22904873 | 7.50e-200 | 4.00e-199 |
| GSE125527 | rectum_diseased | Mann-Whitney U one-vs-rest | celltype | M/DC | all other groups | 259 | 16650 | 0.5829 | 0.1954 | higher | 4239232 | 2.64e-157 | 1.05e-156 |
| GSE125527 | rectum_diseased | Mann-Whitney U one-vs-rest | celltype | NK | all other groups | 283 | 16626 | 0.2406 | 0.2006 | higher | 3013817 | 4.64e-16 | 5.71e-16 |
| GSE125527 | rectum_diseased | Mann-Whitney U one-vs-rest | celltype | T | all other groups | 10103 | 6806 | 0.2096 | 0.1890 | higher | 41389173 | 2.92e-112 | 7.79e-112 |
| GSE125527 | rectum_diseased | Mann-Whitney U one-vs-rest | celltype | unknown | all other groups | 560 | 16349 | 0.1746 | 0.2022 | lower | 3876547 | 6.70e-10 | 6.70e-10 |
| GSE125527 | rectum_healthy | Mann-Whitney U one-vs-rest | celltype | B | all other groups | 4753 | 7710 | 0.1357 | 0.2029 | lower | 10473760 | 0 | 0 |
| GSE125527 | rectum_healthy | Mann-Whitney U one-vs-rest | celltype | M/DC | all other groups | 129 | 12334 | 0.5260 | 0.1736 | higher | 1552439 | 2.26e-77 | 5.16e-77 |
| GSE125527 | rectum_healthy | Mann-Whitney U one-vs-rest | celltype | NK | all other groups | 127 | 12336 | 0.2323 | 0.1767 | higher | 1063979 | 3.47e-12 | 3.70e-12 |
| GSE125527 | rectum_healthy | Mann-Whitney U one-vs-rest | celltype | T | all other groups | 7130 | 5333 | 0.1997 | 0.1472 | higher | 26358073 | 4.32e-299 | 3.46e-298 |
| GSE125527 | rectum_healthy | Mann-Whitney U one-vs-rest | celltype | unknown | all other groups | 324 | 12139 | 0.1322 | 0.1785 | lower | 1432105 | 6.20e-17 | 8.27e-17 |

### Sheet 4: EpithelialGeneMeans
This sheet reports the mean expression scores of the consensus signature genes across marker-defined epithelial states.

| gene | BEST4+ absorptive | Goblet (secretory) | Stem/TA | Cycling | Regenerative (Notch) | Stress/inflammatory epithelial |
| --- | --- | --- | --- | --- | --- | --- |
| BCL6 | 0.0210 | 0.0526 | 0.0529 | 0.0898 | 0.0417 | 0.0613 |
| CD86 | 0.0006 | 0.0096 | 0.0333 | 0.0128 | 0.0049 | 0.0388 |
| CD93 | 0.0000 | 0.0000 | 0.0000 | 0.0024 | 0.0014 | 0.0055 |
| CEBPB | 0.3003 | 0.5152 | 0.2118 | 0.3666 | 0.4560 | 0.4356 |
| CFLAR | 0.7528 | 0.5067 | 0.5397 | 0.5889 | 0.4677 | 0.9754 |
| CHI3L1 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 |
| CHST15 | 0.0005 | 0.0052 | 0.0369 | 0.0163 | 0.0024 | 0.0000 |
| CLEC4E | 0.0000 | 0.0000 | 0.0000 | 0.0024 | 0.0007 | 0.0200 |
| COL8A1 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0002 | 0.0023 |
| CSF2RB | 0.0000 | 0.0036 | 0.0000 | 0.0060 | 0.0044 | 0.0196 |
| CSF3 | 0.0014 | 0.0054 | 0.0000 | 0.0011 | 0.0036 | 0.0029 |
| DENND5A | 0.0032 | 0.0106 | 0.0375 | 0.0226 | 0.0069 | 0.0260 |
| FCGR2A | 0.0000 | 0.0009 | 0.0000 | 0.0000 | 0.0038 | 0.0283 |
| FST | 0.0000 | 0.0020 | 0.0000 | 0.0000 | 0.0000 | 0.0000 |
| FZD10 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 |
| G0S2 | 0.0473 | 0.0924 | 0.0337 | 0.0659 | 0.0938 | 0.0736 |
| GLIPR1 | 0.0363 | 0.1582 | 0.4396 | 0.6899 | 0.0508 | 0.1187 |
| GLT1D1 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0051 |
| HGF | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 |
| HLA-DQA1 | 0.0128 | 0.1275 | 0.6690 | 0.3648 | 0.0425 | 0.2750 |
| HSD11B1 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0002 | 0.0062 |
| IER5 | 0.3746 | 0.5874 | 0.3463 | 0.3819 | 0.4876 | 0.4463 |
| IFIT3 | 0.0338 | 0.0267 | 0.0157 | 0.0269 | 0.0183 | 0.1969 |
| IGFBP5 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0007 | 0.0000 |
| IL11 | 0.0016 | 0.0000 | 0.0000 | 0.0080 | 0.0029 | 0.0000 |
| IL13RA2 | 0.0037 | 0.0007 | 0.0000 | 0.0000 | 0.0013 | 0.0000 |
| IL6 | 0.0000 | 0.0029 | 0.0845 | 0.0112 | 0.0026 | 0.0163 |
| INHBA | 0.0009 | 0.0053 | 0.0000 | 0.0000 | 0.0021 | 0.0129 |
| KLHL5 | 0.0052 | 0.0377 | 0.1686 | 0.1220 | 0.0075 | 0.0732 |
| LILRA2 | 0.0000 | 0.0000 | 0.0000 | 0.0024 | 0.0005 | 0.0047 |
| LILRB1 | 0.0010 | 0.0160 | 0.0389 | 0.0135 | 0.0029 | 0.0291 |
| LILRB2 | 0.0000 | 0.0012 | 0.0000 | 0.0000 | 0.0012 | 0.0282 |
| LILRB3 | 0.0014 | 0.0115 | 0.0000 | 0.0126 | 0.0079 | 0.0119 |
| LRRC8C | 0.0015 | 0.0172 | 0.0520 | 0.0562 | 0.0063 | 0.0276 |
| LRRK2 | 0.0025 | 0.0047 | 0.0350 | 0.0125 | 0.0015 | 0.0105 |
| NR4A3 | 0.0276 | 0.1227 | 0.3009 | 0.3198 | 0.0689 | 0.1057 |
| NRG1 | 0.0000 | 0.0000 | 0.0000 | 0.0024 | 0.0000 | 0.0092 |
| NRP2 | 0.0013 | 0.0104 | 0.0083 | 0.0070 | 0.0077 | 0.0318 |
| P2RX7 | 0.0028 | 0.0074 | 0.0177 | 0.0256 | 0.0020 | 0.0031 |
| P2RY13 | 0.0007 | 0.0000 | 0.0000 | 0.0024 | 0.0010 | 0.0052 |
| PAPPA | 0.0008 | 0.0008 | 0.0000 | 0.0000 | 0.0008 | 0.0000 |
| PRR16 | 0.0000 | 0.0000 | 0.0153 | 0.0000 | 0.0000 | 0.0000 |
| PTGS1 | 0.0054 | 0.0130 | 0.0356 | 0.0000 | 0.0116 | 0.0183 |
| PTGS2 | 0.0019 | 0.0132 | 0.0200 | 0.0086 | 0.0142 | 0.0478 |
| PTPRC | 0.0617 | 0.3375 | 1.1656 | 1.4260 | 0.0866 | 0.2746 |
| RAB31 | 0.0360 | 0.0133 | 0.0178 | 0.0052 | 0.0102 | 0.2149 |
| RBMS1 | 0.0098 | 0.0427 | 0.0933 | 0.1975 | 0.0166 | 0.0538 |
| RGS18 | 0.0014 | 0.0043 | 0.0000 | 0.0407 | 0.0028 | 0.0093 |
| RGS4 | 0.0010 | 0.0000 | 0.0000 | 0.0000 | 0.0090 | 0.0042 |
| RHOQ | 0.0049 | 0.0956 | 0.0635 | 0.1196 | 0.0255 | 0.0599 |
| RNF144B | 0.0072 | 0.0156 | 0.0000 | 0.0292 | 0.0113 | 0.0121 |
| SELE | 0.0000 | 0.0000 | 0.0000 | 0.0037 | 0.0002 | 0.0000 |
| SERPINE1 | 0.0032 | 0.0011 | 0.0000 | 0.0024 | 0.0068 | 0.0040 |
| SOCS3 | 0.1076 | 0.2194 | 0.3775 | 0.2583 | 0.2090 | 0.3827 |
| SOD2 | 0.4716 | 0.4787 | 0.4856 | 0.4519 | 0.6435 | 0.9629 |
| SRGN | 0.0854 | 0.4727 | 1.3923 | 1.7663 | 0.1377 | 0.4205 |
| STC1 | 0.0006 | 0.0017 | 0.0000 | 0.0000 | 0.0070 | 0.0175 |
| TAGAP | 0.0208 | 0.0903 | 0.3735 | 0.3453 | 0.0215 | 0.0576 |
| TFPI | 0.0037 | 0.0053 | 0.0261 | 0.0074 | 0.0099 | 0.0295 |
| TFPI2 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0036 |
| TLR1 | 0.0024 | 0.0012 | 0.0403 | 0.0160 | 0.0035 | 0.0156 |
| TLR8 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0065 |
| TNFRSF11B | 0.0068 | 0.0794 | 0.0000 | 0.0045 | 0.0310 | 0.0039 |
| ZEB1 | 0.0055 | 0.0265 | 0.1288 | 0.1085 | 0.0099 | 0.0252 |

### Sheet 5: ImmuneGeneMeans
This sheet reports the mean expression scores of the consensus signature genes across marker-defined immune cell types in diseased and healthy rectal tissues.

| gene | diseased_B | diseased_M/DC | diseased_NK | diseased_T | diseased_unknown | healthy_B | healthy_M/DC | healthy_NK | healthy_T | healthy_unknown |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BCL6 | 0.0423 | 0.1294 | 0.0709 | 0.0593 | 0.1756 | 0.0077 | 0.1884 | 0.0769 | 0.0334 | 0.0284 |
| CD86 | 0.0649 | 0.7250 | 0.0046 | 0.0021 | 0.1329 | 0.0545 | 0.6407 | 0.0000 | 0.0018 | 0.0254 |
| CD93 | 0.0001 | 0.1914 | 0.0057 | 0.0005 | 0.0000 | 0.0000 | 0.2919 | 0.0000 | 0.0013 | 0.0000 |
| CEBPB | 0.1462 | 0.6034 | 0.2712 | 0.2001 | 0.1081 | 0.2325 | 0.7662 | 0.3193 | 0.3142 | 0.1959 |
| CFLAR | 0.2888 | 0.7687 | 0.5762 | 0.3825 | 0.3198 | 0.3870 | 0.6469 | 0.3162 | 0.2829 | 0.2988 |
| CHST15 | 0.0754 | 0.0158 | 0.0041 | 0.0054 | 0.0269 | 0.1056 | 0.0661 | 0.0351 | 0.0072 | 0.0342 |
| CLEC4E | 0.0000 | 0.0816 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0914 | 0.0000 | 0.0000 | 0.0000 |
| CSF2RB | 0.0619 | 0.1535 | 0.0000 | 0.0058 | 0.0667 | 0.1286 | 0.1317 | 0.0083 | 0.0075 | 0.0750 |
| DENND5A | 0.0137 | 0.1166 | 0.0481 | 0.0171 | 0.0091 | 0.0049 | 0.0767 | 0.0538 | 0.0163 | 0.0092 |
| FCGR2A | 0.0080 | 0.4997 | 0.0000 | 0.0000 | 0.0088 | 0.0042 | 0.3941 | 0.0000 | 0.0004 | 0.0000 |
| G0S2 | 0.1087 | 1.0559 | 0.0261 | 0.0223 | 0.0146 | 0.0909 | 0.8717 | 0.0268 | 0.0063 | 0.0104 |
| GLIPR1 | 0.2901 | 1.0562 | 0.4312 | 0.3614 | 0.3076 | 0.2208 | 1.0997 | 0.4160 | 0.5258 | 0.3093 |
| HLA-DQA1 | 1.3097 | 3.2788 | 0.1068 | 0.0953 | 1.0813 | 0.6216 | 2.7993 | 0.0691 | 0.0362 | 0.2265 |
| IER5 | 0.2374 | 0.4853 | 0.4993 | 0.3218 | 0.1837 | 0.1900 | 0.5209 | 0.8595 | 0.4220 | 0.1440 |
| IFIT3 | 0.0075 | 0.0433 | 0.0129 | 0.0079 | 0.0058 | 0.0023 | 0.0424 | 0.0000 | 0.0095 | 0.0000 |
| KLHL5 | 0.0482 | 0.0784 | 0.0353 | 0.0269 | 0.0899 | 0.0473 | 0.0438 | 0.0756 | 0.0208 | 0.0438 |
| LILRA2 | 0.0034 | 0.2938 | 0.0000 | 0.0001 | 0.0057 | 0.0080 | 0.2799 | 0.0000 | 0.0007 | 0.0117 |
| LILRB1 | 0.1030 | 0.4296 | 0.0324 | 0.0060 | 0.0793 | 0.1264 | 0.3476 | 0.0370 | 0.0083 | 0.0566 |
| LILRB2 | 0.0007 | 0.4840 | 0.0000 | 0.0002 | 0.0000 | 0.0006 | 0.4391 | 0.0000 | 0.0000 | 0.0000 |
| LILRB3 | 0.0007 | 0.1775 | 0.0000 | 0.0020 | 0.0012 | 0.0014 | 0.1849 | 0.0135 | 0.0019 | 0.0000 |
| LRRC8C | 0.0204 | 0.1491 | 0.0167 | 0.0612 | 0.0343 | 0.0226 | 0.0450 | 0.0262 | 0.0353 | 0.0235 |
| LRRK2 | 0.0495 | 0.0696 | 0.0000 | 0.0022 | 0.0341 | 0.0433 | 0.1365 | 0.0000 | 0.0027 | 0.0304 |
| NR4A3 | 0.1795 | 0.8630 | 0.5094 | 0.2224 | 0.0850 | 0.0889 | 0.5179 | 0.5823 | 0.2974 | 0.1187 |
| NRG1 | 0.0004 | 0.1539 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.0334 | 0.0000 | 0.0000 | 0.0000 |
| P2RX7 | 0.0088 | 0.0334 | 0.0160 | 0.0159 | 0.0000 | 0.0073 | 0.1158 | 0.0164 | 0.0161 | 0.0041 |
| P2RY13 | 0.0017 | 0.3896 | 0.0000 | 0.0000 | 0.0000 | 0.0000 | 0.4646 | 0.0000 | 0.0010 | 0.0021 |
| PTGS1 | 0.0268 | 0.1202 | 0.0000 | 0.0008 | 0.0199 | 0.0104 | 0.1419 | 0.0000 | 0.0002 | 0.0038 |
| PTGS2 | 0.0005 | 0.6863 | 0.0114 | 0.0012 | 0.0010 | 0.0018 | 0.5978 | 0.1253 | 0.0021 | 0.0000 |
| PTPRC | 0.7497 | 1.3411 | 1.7166 | 1.6567 | 1.2814 | 0.4859 | 1.2535 | 1.4847 | 1.4910 | 1.0130 |
| RAB31 | 0.1073 | 0.7975 | 0.0273 | 0.0036 | 0.0353 | 0.0805 | 0.8161 | 0.0083 | 0.0029 | 0.0274 |
| RBMS1 | 0.0872 | 0.2505 | 0.3564 | 0.2701 | 0.0900 | 0.0584 | 0.1475 | 0.5109 | 0.3487 | 0.1867 |
| RGS18 | 0.0000 | 0.1319 | 0.0000 | 0.0034 | 0.0040 | 0.0005 | 0.1468 | 0.0000 | 0.0059 | 0.0000 |
| RHOQ | 0.0682 | 0.2040 | 0.0383 | 0.0158 | 0.0768 | 0.1008 | 0.1643 | 0.0214 | 0.0191 | 0.0653 |
| RNF144B | 0.0226 | 0.2252 | 0.0066 | 0.0185 | 0.1047 | 0.0048 | 0.2086 | 0.0000 | 0.0082 | 0.0116 |
| SOCS3 | 0.4159 | 0.9533 | 0.2102 | 0.4437 | 0.2326 | 0.3121 | 0.8825 | 0.1475 | 0.3748 | 0.2135 |
| SOD2 | 0.3241 | 2.0325 | 0.3533 | 0.3623 | 0.2898 | 0.2308 | 1.4839 | 0.3894 | 0.2978 | 0.1540 |
| SRGN | 1.0676 | 3.3574 | 3.1176 | 2.7126 | 1.2732 | 1.2793 | 3.0008 | 2.7060 | 2.4694 | 1.4483 |
| TAGAP | 0.7252 | 0.7630 | 1.0112 | 0.9353 | 0.6678 | 0.3557 | 0.7526 | 0.7391 | 0.7867 | 0.3977 |
| TLR1 | 0.0516 | 0.0981 | 0.0112 | 0.0148 | 0.0456 | 0.0346 | 0.1475 | 0.0266 | 0.0133 | 0.0191 |
| ZEB1 | 0.0821 | 0.0288 | 0.0975 | 0.1247 | 0.0931 | 0.0747 | 0.0593 | 0.2006 | 0.1203 | 0.1002 |
