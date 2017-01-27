---
output:
  pdf_document: default
  html_document: default
---
# README #

**R1: Data Toolbox**

Authors: AC

Reviewers: FBB,MH

### Summary ###

R1 Package aggregates a number of data functions that used to exist in R2...R6 while also containing specific functions related to data download, dumping and qc:

v0.1
* market data downloads (run monthly through cron by infra-data)
* data dumping from infra-data to a dropbox folder accessible to researchers
* data quality checks at a company and instrument level: (1) *QC1 - Suspicious or invalid data values*, (2) *QC2 - Data completeness*
* other generic data manipulation functions useful to all researchers

Config.R and run.R are provided so that packages can be deployed in a tractable and standard manner any automated and regular R process designed by researchers. A good example is the infra raw data dump process and its associated QC process    

### To do next

v0.2: summary function of data completeness for minimum data required at (1) company and (2) instrument level
