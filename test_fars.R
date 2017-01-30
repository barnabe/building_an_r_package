#test file
#the first test makes sure that the output of the fars_summarize_years() function is a dataframe
test_output=fars_summarize_years(c(2013:2015))
test_that("table is df", expect_is(test_output,"data.frame"))

