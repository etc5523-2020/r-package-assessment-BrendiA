

#' Creates error message if Shiny App input is empty
#'
#' @param input Shiny user-interface input
#'
#' @return Error message if condition(s) are not met
#'
#' @export
#'

error_msg <- function(input, plot_type){
  if(plot_type == "map") {
  shiny::validate(shiny::need(input != "", "Hello there, be sure to add a state or you'd run into an error"))
  } else if(plot_type == "bar") {
    shiny::validate(shiny::need(input != "", ""))
    }
}

# How can I pass Shiny input into the function?
## Function is in eventReactive
