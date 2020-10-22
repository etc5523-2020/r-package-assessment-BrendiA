## code to prepare `tests_raw` dataset goes here

# ------------ U.S States Covid-19 Testing Dataset ---------------

library(readr)
library(dplyr)

tests_raw <- read_csv("data-raw/all-states-history.csv") %>%
  select(date, state, positiveIncrease, positive, totalTestResults, totalTestResultsIncrease, dataQualityGrade) %>%
  rename(daily_cases = positiveIncrease,
         total_cases = positive,
         daily_tests = totalTestResultsIncrease,
         total_tests = totalTestResults,
         data_quality = dataQualityGrade
  ) %>%
  filter(!state %in% c("AS", "GU", "MP", "PR", "VI"))

usethis::use_data(tests_raw, overwrite = TRUE)
