#' Creates datatable to render interactive data table
#'
#'
#'
#' @export
#'
#'

create_datatable <- function() {
  ## Include population estimates in US-testing data
  us_state_tests <- covid_map %>%
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
}

# How can I save the data frame?
# return(covid_map)
# return(us_tests_map)
# When I type covid19usa::covid_map() -> returns map data
