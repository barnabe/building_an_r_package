#test file
testthat::context("basic tests")
#the first test makes sure that the output of the fars_summarize_years() function is a dataframe
setwd("../..")
testthat::test_that("table is df", testthat::expect_is(fars::fars_summarize_years(c(2013:2015)),"data.frame"))

