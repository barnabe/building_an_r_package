#this script runs the test in test_fars.R
#library(fars)
library(testthat)

#create test output
test_output=fars_summarize_years(c(2013:2015))
#run test files in tests/ directory
test_dir("tests/")
