test_that("Proportion of Covid-19 tests per population is correct", {
  df <- create_datatable()
  df <- df[[2]]

  # Remove NAs
  df <- df %>% filter(!is.na(`% of Tests per Population`))

  total_proportion <- df$`% of Tests per Population`

  total_tests <- df$`Total Tests`
  population <- df$`Total Population`
  test_proportion = total_tests/population

  testthat::expect_identical(test_proportion, total_proportion)
})
