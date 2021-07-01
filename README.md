
# The rodent object-in-context task: a systematic review and meta-analysis of important variables

Systematic Review and meta-analysis as described in:
* Milou S.C. Sep, Marijn Vellinga, R. Angela Sarabdjitsingh, Marian Joëls. (2021). _Measuring context-dependent memory in rodents: a systematic review and meta-analysis of important variables in the object-in-context task._ bioRxiv 2021.03.12.435070; doi: https://doi.org/10.1101/2021.03.12.435070 [preprint]
* Milou S.C. Sep, Marijn Vellinga, R. Angela Sarabdjitsingh, Marian Joëls. (in press). _The rodent object-in-context task: a systematic review and meta-analysis of important variables._ PLOS ONE.

## Index
_ `README.md`: an overview of the project    
|___ `data`: data files used in the project   
|___ `processed_data`: intermediate files from the analysis   
|___ `results`: results of the analyses (data, tables, figures)    
|___ `R`: contains all R-code in the project   

## 1. Flowchart

- script: `flowchart.R`
- input (script contains code that retrieves data from OSF):
  - search step:
    - `data/hits.search.thesis.MV.txt`
    - `data/hits.new.search.meta.oic.v25.5.20.txt`
  - screening step:
    - `data/Screening S1 thesis search PMIDs.csv`
    - `data/Screening S2 new.in.new.search.PMIDs.csv`
  - included data:
    - `data/280121_Data_Extraction_RoB.xlsx`
- actions: 
  - count numbers screening & inclusions for flow chart

## 2. Preprocessing
- script: `prepare_data.Rmd` (for Systematic review & meta-analysis)
- input: `data/280121_Data_Extraction_RoB.xlsx`  (script contains code that retrieves data from OSF)
- actions:
  - pre-processing data (and save cleaned data for Systematic review table)
  - missing values.
    1. Variables with more than 1/3 missing are excluded from Random forest-based meta-analysis
    2. Other variables: Missing values are replaced by median value (for numeric) of most prevalent category (for factors)
  - create sum scores: `Arousal.Prior`, `Context.Difference.Score`, `Arousal.Task.Habituation`, `Arousal.Total`
- output: 
  - `processed_data/SR_data.RDS` (for Systematic review table)
  - `processed_data/cleaned_data.RDS` (for meta-analysis)

## 3. Systematic review Table
- script: `systematic_review_table.Rmd`
- action: create systematic review table
- output: `results/Overview_SR.docx`

## 4. Visualize Study Quality and Risk of Bias
- script: `QA_RoB_plots.Rmd`
- action: create waffel plot with SYRCLE’s risk of bias assessment per study (PMID)
- output: `results/QA_ROB.tiff`

## 5. Random-effects meta-analysis
- script: `random_effects_meta_analysis.Rmd`  
- input: 
  - `processed_data/cleaned_data.RDS`
  - `data/280121_Data_Extraction_RoB.xlsx`
- actions:
  - random-effects meta-analysis
  - calculate required sample size for future studies
  - robustness of effects measures
  - sensitivity analyses
- output: 
  - `processed_data/data_with_effect_size.RDS`
  - `results/forest_year.tiff`
  - `results/funnel.colours.tiff`
  - `results/study.quality.jpeg`

## 6. Random forest-based meta-analysis
- script: `MetaForest.Rmd`
- Input: `processed_data/data_with_effect_size.RDS`
- Actions: 
  - tune & run random forest-based meta-analysis (MetaForest)
  - identify important moderators based on variable importance in RF
- Output:  
  - processed data:
    - `processed_data/datForest_for_WS_Plot.RDS`
    - `processed_data/fitted.MetaForest.RDS`
    - `processed_data/important_variables.RDS` 
  - results:
    - `results/metaforest_convergencePlot.jpeg`
    - `results/metaforest_varImportance.jpeg`
    - `results/important_variables_metaforest.csv`
  
## 7. MetaForest follow-up: Partial dependence and Weighted scatter plots
- script: `MetaForest_PD_WS_plots.Rmd`
- input:
  - `processed_data/fitted.MetaForest.RDS`
  - `processed_data/datForest_for_WS_Plot.RDS`
  - `processed_data/important_variables.RDS`
- actions:
  - create partial dependance (PD) and weighted scatter plots to follow-up most important variables MetaForest
- output: 
  - `results/metaforest_adapted_PD_plots.jpeg`
  - `results/metaforest_adapted_WS plots.jpeg`
