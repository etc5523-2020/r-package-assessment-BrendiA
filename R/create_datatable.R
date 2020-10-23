#' Creates a list of 2 elements relating to the spatial data of Covid-19 testing in the U.S
#'
#' @import dplyr
#'
#' @export
#'
create_datatable <- function() {

  ## Include population estimates in US-testing data
  us_state_tests <- covid19usa::covid_us_states %>%
    left_join(us_states_map, by = "fips") %>%
    distinct(abbr, population, state) %>%
    right_join(tests_raw, by = c("abbr" = "state"))

  # Clean names for DT Table --------------------------------------------
  total_tests_df <- us_state_tests %>%
    mutate(total_positive_prop = total_cases/total_tests,
           tests_prop = total_tests/population)

  # Replace Inf, NaN and NAs and incoherent values with 0
  total_tests_df$total_cases[!is.finite(total_tests_df$total_cases)] <- 0
  total_tests_df$total_positive_prop[!is.finite(total_tests_df$total_positive_prop)] <- 0

  total_tests_table <- total_tests_df %>%
    select(date, state, population, tests_prop, total_cases, total_tests, total_positive_prop) %>%
    rename(Date = date,
           State = state,
           `Total Cases` = total_cases,
           `Total Tests` = total_tests,
           `% of Positive Cases` = total_positive_prop,
           `Total Population` = population,
           `% of Tests per Population` = tests_prop)

  list(us_state_tests, total_tests_table)
}


