#test file

#the first test makes sure that the output of the fars_summarize_years() function is a dataframe
testthat::test_that("table is df", testthat::expect_is(test_output,"data.frame"))

