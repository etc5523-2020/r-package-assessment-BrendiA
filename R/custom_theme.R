#' Custom theme for maps and bar charts
#'
#' @param plot_type The type of plot - "map" or "bar"
#'
#' @return Custom theme that complements the aesthetics of the Shiny App
#'
#' @import ggplot2
#'
#' @export

custome_theme <- function(plot_type) {
  if(plot_type == "map"){
    ggplot2::theme_void() +
    ggplot2::theme(panel.background = element_rect(fill = "#1f1f1f"),
            plot.background = element_rect(fill = "#1f1f1f"),
            axis.line = element_blank(),
            plot.title = element_text(size = 15, face = "bold", colour = "white"),
            legend.position = "none")
  } else if(plot_type == "bar"){
    ggplot2::theme_linedraw() +
      ggplot2::theme(
        panel.background = element_rect(fill = "#1f1f1f"),
        plot.background = element_rect(fill = "#1f1f1f"),
        panel.border = element_blank(),
        axis.title = element_blank(),
        legend.position = "none",
        panel.grid = element_blank(),
        axis.text = element_text(colour = "white",
                                 size = 5)
      )
  }
}
