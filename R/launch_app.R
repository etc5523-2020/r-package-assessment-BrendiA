#' Load Shiny Application from inst/app directory
#'
#'
#' @return
#' A Shiny App
#'
#'
#' @export

launch_app <- function() {
  # Locates all the app that exists in covid19usa package
  appDir <- system.file("app", package = "covid19usa")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `covid19usa`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
