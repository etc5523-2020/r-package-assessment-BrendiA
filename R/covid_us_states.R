#' Provides the Dataset for the Confirmed Covid-19 Cases and Deaths by States in the U.S, reported by The New York Times.
#'
#' @source
#' [NYtimes GitHub](https://github.com/nytimes/covid-19-data)
#'
#' @format a tibble with 11,904 observations and 5 variables:
#'
#' - **date**: Date reported
#' - **state**: Name of U.S. state
#' - **fips**: Two-letter state code
#' - **cases**: Cumulative number of cases per state
#' - **deaths**: Cumulative number of deaths per state
#' - *cases_per_hnd* Cumulative number of cases (per 100,000 population) per state
#' - *deaths_per_hnd* Cumulative number of deaths (per 100,000 population) per state
#'
#'
"covid_us_states"
