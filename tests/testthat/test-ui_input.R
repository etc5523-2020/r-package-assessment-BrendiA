context("ui_input.R")

test_that("Correct date range", {
  max_date <- max(covid19usa::covid_us_states$date)
  min_date <- min(covid19usa::covid_us_states$date)

  testthat::expect_true(max_date > min_date)
  testthat::expect_equal(length(min_date), 1)
})

