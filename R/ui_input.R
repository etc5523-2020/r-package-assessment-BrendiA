#' Creates user interface input for Shiny app
#'
#' @param data A data frame
#' @param input_type Character string specifying type of input, "date" or "state"
#' @param input_id A string specifying the label Id
#' @param input_label A string specifying the label name for the reactive input
#'
#' @return
#' Creates a reactive slider/picker input for Shiny App
#'
#' @examples
#' ui_input("date", "choose_dates", us_tests_map, "Choose a Date")
#'
#' @importFrom shiny sliderInput
#' @importFrom shinyWidgets pickerInput
#'
#' @export

ui_input <- function(data, input_type, input_id, input_label) {
  if(input_type == "date"){
    sliderInput(inputId = input_id,
                label = input_label,
                min = min(data$date),
                max = max(data$date),
                value = max(data$date))
  } else if(input_type == "state"){
    pickerInput(inputId = input_id,
                label = input_label,
                choices = sort(unique(data$state)),
                selected = unique(data$state),
                options = list(`actions-box` = TRUE),
                multiple = T)
  }
}


