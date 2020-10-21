#' Reported Covid-19 Testing Data across all U.S States from 2020-01-22 to 2020-10-07
#'
#' @source
#' [NYtimes GitHub](https://github.com/nytimes/covid-19-data)
#'
#' @format a tibble with 11,164 observations and 5 variables:
#'
#' - **date**: Date reported
#' - **state**: Abbreviated name of U.S. state
#' - **daily_cases**: daily number of Covid-19 cases per U.S state
#' - **daily_tests**: Daily number of Covid-19 testing per U.S state
#' - **total_cases**: Total number of cases per U.S State
#' - **total_tests**: Total number of Covid-19 testing per U.S state
#' - **data_quality**: Quality of Covid-19 testing data provided by the U.S state
#'
"tests_raw"
