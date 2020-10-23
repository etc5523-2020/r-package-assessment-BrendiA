test_that("All U.S state population is included and correct", {
  df <- covid19usa::covid_us_states %>%
    distinct(fips, population) %>%
    arrange(fips)

  pop_estimates <- us_pop_ests %>% arrange(fips)

  expect_setequal(df$population, pop_estimates$population)
  expect_setequal(df$fips, pop_estimates$fips)
})
