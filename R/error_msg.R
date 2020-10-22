

#' Title
#'
#' @param input Shiny user-interface input
#'
#' @return Error message if condition(s) are not met
#'
#' @export
#'
#' @examples
#' error_msg(input$choose_states, plot_type == "map")

error_msg <- function(input, plot_type){
  if(plot_type == "map") {
  validate(need(input != "", "Hello there, be sure to add a state or you'd run into an error"))
  } else if(plot_type == "bar") {
    validate(need(input != "", ""))
    }
}

# How can I pass Shiny input into the function?
## Function is in eventReactive
