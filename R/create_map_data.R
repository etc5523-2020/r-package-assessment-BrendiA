#' Creates a list of 2 elements relating to the spatial data of Covid-19 cases in the U.S
#'
#' @example
#' list <- create_map_data()
#'
#' @import dplyr
#'
#' @export
#'

create_map_data <- function() {
  # Join map data and Covid-19 cases data
  covid_map <- covid19usa::covid_us_states %>%
    left_join(us_states_map, by = "fips")

  # Join map data and Covid-19 testing data
  us_tests_map <- covid_map %>%
    distinct(state, abbr, population, lat, long, group) %>%
    right_join(covid19usa::tests_raw, by = c("abbr" = "state")) %>%
    mutate(positive_prop = round((daily_cases/daily_tests)*100,2)) # Proportion of positive cases as a result of testing

  # Replace Inf, NaN and NAs and incoherent values with 0
  us_tests_map$positive_prop [!is.finite(us_tests_map$positive_prop)] <- 0
  us_tests_map$positive_prop [us_tests_map$positive_prop < 0] <- 0
  us_tests_map$positive_prop [us_tests_map$positive_prop > 100] <- 0

  list(covid_map, us_tests_map)
}

