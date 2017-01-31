#test file
testthat::context("basic tests")
#the first test makes sure that the output of the fars_summarize_years() function is a dataframe
test_that("table is df", expect_is(fars_summarize_years(c(2013:2015)),"data.frame"))

