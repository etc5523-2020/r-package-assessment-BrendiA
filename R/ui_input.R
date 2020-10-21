#' Creates reactive input for Shiny app
#'
#' @param data A data frame
#' @param input_type Character string specifying type of input, "date" or "state"
#' @param input_id A string specifying the label Id
#'
#' @return
#' Creates a reactive slider/picker input for Shiny App
#'
#' @importFrom shiny sliderInput
#' @importFrom shinyWidgets pickerInput
#'
#' @export

ui_input <- function(input_type, input_id, data){
  if(input_type == "date"){
    sliderInput(inputId = input_id,
                label = "Choose a Date",
                min = min(data$date),
                max = max(data$date),
                value = max(data$date))
  } else if(input_type == "state"){
    pickerInput(inputId = input_id,
                label = "Choose state(s)",
                choices = sort(unique(data$state)),
                selected = unique(data$state),
                options = list(`actions-box` = TRUE),
                multiple = T)
  }
}


