
# --------------------------------------------- Load Library ---------------------------------------------------

library(covid19usa)
library(tidyverse)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(readr)
library(usmap)
library(stringr)
library(DT)
library(plotly)
library(shinycssloaders)

options(spinner.color = "#c1adea") # Choose Spinner colour


# ------------------------------------------------------------------------------------------------------------------#
# ---------------------------------------------------- Load Data ---------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------------#

## 2019 population estimates data for US counties ------------------------------------
covid19usa::us_pop_ests

## US States Maps data ---------------------------------------------------
covid19usa::us_states_map

## Load Covid-19 in US states data ---------------------------------------------------
covid19usa::covid_us_states

## US States Covid-19 testing data ---------------------------------------------------
covid19usa::tests_raw


# ------------------------------------------------------------------------------------------------------------------#
# --------------------------------------- Covid-19 Testing Across US States ----------------------------------------#
#-------------------------------------------------------------------------------------------------------------------#

# -------------------------------------------- Join Datasets ----------------------------------------------------

## Include GPS coordinates for each state for plotting map
covid_map <- covid_us_states %>%
  left_join(us_states_map, by = "fips")

## Include pop estimates in US-testing data --------------------------------------------
us_state_tests <- covid_map %>%
  distinct(abbr, population, state) %>%
  right_join(tests_raw, by = c("abbr" = "state"))

# Include map data in US-testing data --------------------------------------------
us_tests_map <- covid_map %>%
  distinct(state, abbr, population, lat, long, group) %>%
  right_join(tests_raw, by = c("abbr" = "state")) %>%
  mutate(positive_prop = round((daily_cases/daily_tests)*100,2)) # Proportion of positive cases as a result of testing

# Replace Inf, NaN and NAs and incoherent values with 0
us_tests_map$positive_prop [!is.finite(us_tests_map$positive_prop)] <- 0
us_tests_map$positive_prop [us_tests_map$positive_prop < 0] <- 0
us_tests_map$positive_prop [us_tests_map$positive_prop > 100] <- 0

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


# -------------------------------------------- Create Web App --------------------------------------------------

# ui ----------------------------------------------------------------------

ui <- fluidPage(
  theme = shinythemes::shinytheme("darkly"),
  tabsetPanel(
    tabPanel("About",
             tags$h4("Creator of the App: Brendi Ang"),
             tags$br(),
             tags$h4("Purpose of the App"),
             "The aim of the app is to provide key data visualisations and allow users to
             explore Covid-19 cases across the states in the U.S.  Several interactive features
             are included to allow for the ability to manoeuvre between dates and states across U.S to
             see how the covid-19 outbreak trajectory changes. In both tabs, you can make use of slider inputs
             to choose between dates and input selector to select various US states to compare from.",
             tags$br(),
             "From the first tab, you can total confirmed Covid-19 cases across the US states and establish which state is
             leading in total Covid-19 cases on a given date. To note, These reported may be subjected to significant variations in
             testing and lockdown policy between states. In the second tab, you can compare the proportion (daily and cumulative) of Covid-19
             tests returning positive across the U.S. states. To note, these results may be subjected to significant variations generally
             due to case definitions.",
             tags$h4("Code"),
             "Information on how to run the Web app and the code and input data used to generate this Shiny App are available on my",
             tags$a(href="https://github.com/etc5523-2020/shiny-assessment-BrendiA", "Github."),
             tags$h3("References"),
             "Wickham et al., (2019). Welcome to the tidyverse. Journal of Open Source Software, 4(43), 1686,
             https://doi.org/10.21105/joss.01686",
             tags$br(),
             tags$br(),
             "Hadley Wickham, Jim Hester and Romain Francois (2018). readr: Read Rectangular Text Data. R package version 1.3.1.
             https://CRAN.R-project.org/package=readr",
             tags$br(),
             tags$br(),
             "Paolo Di Lorenzo (2019). usmap: US Maps Including Alaska and Hawaii. R package version 0.5.0.
             https://CRAN.R-project.org/package=usmap",
             tags$br(),
             tags$br(),
             "Hadley Wickham (2019). stringr: Simple, Consistent Wrappers for Common String Operations. R package version 1.4.0.
             https://CRAN.R-project.org/package=stringr",
             tags$br(),
             tags$br(),
             "C. Sievert. Interactive Web-Based Data Visualization with R, plotly, and shiny. Chapman and Hall/CRC Florida,
             2020.",
             tags$br(),
             tags$br(),
             "Yihui Xie, Joe Cheng and Xianying Tan (2020). DT: A Wrapper of the JavaScript Library 'DataTables'. R package
             version 0.15. https://CRAN.R-project.org/package=DT",
             tags$h3("Sources"),
             tags$a(href = "https://github.com/nytimes/covid-19-data", "US State-level Case Data and Population Estimates"),
             tags$br(),
             tags$a(href = "https://covidtracking.com/data/national", "US State-level Covid-19 Testing Outcomes")
             ),
    tabPanel("Comparing Covid-19 Cases Across US States",
             fluidRow(
               column(12,
                      titlePanel("Comparing Confirmed Covid-19 Cases (per 100,000 Population) across U.S States")
               )
             ),
             fluidRow(
               column(4,
                      ui_input("date", "choose_date", covid_us_states)),
               column(4,
                      ui_input("state", "choose_states", covid_us_states))),
             fluidRow(
               column(4,
                      actionButton(inputId = "show_trend", label = "Show Covid Trends"))),
             fluidRow(
               column(3,
                      plotly::plotlyOutput("plot_covid_cases", height = "600px") %>%
                        withSpinner(type = 1)),
               column(9,
                      plotly::plotlyOutput("plot_covid_map", height = "600px") %>%
                        withSpinner(type = 1)
               ))),

    tabPanel("How Much are the US States Finding Through Covid-19 Tests?",
             titlePanel("How Many Positive Tests were Found as a Result of Covid-19 Testing?"),
             sidebarLayout(
               sidebarPanel(
                 ui_input("date", "choose_date2", us_tests_map),
                 ui_input("state", "choose_states2", us_tests_map),
                 actionButton("show_trend2","Show Covid Trends"),
                 plotly::plotlyOutput("plot_covid_tests") %>%
                   withSpinner(type = 1)),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Daily", plotly::plotlyOutput("plot_tests_map", height = "700px") %>%
                              withSpinner(type = 1)),
                   tabPanel("Total (Cumulative)", DT::DTOutput("plot_DT_tests", height = "700px") %>%
                              withSpinner(type = 1))
                 )))
    )
  )
)


# server ----------------------------------------------------------------------

server <- function(input, output, session) {

  plot_map <- eventReactive(input$show_trend, {
    validate(need(input$choose_states != "", "Hey, be sure to add a state or you'd run into an error :)"))

    covid_map %>%
      filter(date == input$choose_date) %>%
      filter(state %in% input$choose_states) %>%
      ggplot(aes(x = lat, y = long, group = group)) +
      # Base map
      geom_polygon(data = us_states_map, colour = "#d3d3d3") +
      geom_polygon(aes(group = group,
                       fill = cases_per_hnd,
                       text = paste('</br> Date:', date,
                                    '</br> State:', state,
                                    '</br> Total Cases:', scales::comma(cases_per_hnd, accuracy = 0.01),
                                    '</br> Total Deaths:', scales::comma(deaths_per_hnd, accuracy = 0.01),
                                    '</br> Population', scales::comma(population, accuracy = 1)
                       )),
                   colour = "#d3d3d3") +
      scale_fill_distiller(palette = "Purples", direction = 1) +
      ggtitle(paste0("Confirmed Covid-19 Cases Reported as of ", input$choose_date)) +
      custome_theme("map")
  })

  ## Render US Covid-19 Cases Map
  output$plot_covid_map <- renderPlotly({
    plotly::ggplotly(plot_map(), tooltip = c("text")) %>%
      config(displayModeBar = F)
  })

  ## US Cases Bar Plot
  plot_bar <- eventReactive(input$show_trend, {
    validate(need(input$choose_states != "", "Be sure to add a state"))

    plot_bar <- covid_us_states %>%
      filter(date == input$choose_date) %>%
      filter(state %in% input$choose_states) %>%
      ggplot(aes(x = cases_per_hnd,
                 y = fct_reorder(state, cases_per_hnd, .desc = TRUE))) +
      geom_col(aes(fill = cases_per_hnd,
                   text = paste('</br> State:', state,
                                '</br> Total Cases:', cases_per_hnd,
                                '</br> Population', scales::comma(population, accuracy = 1))),
               width = 0.8) +
      scale_fill_distiller(palette = "Purples", direction = 1) +
      labs(x = "Total cases (in '000s)", y = "") +
      scale_x_continuous(expand = c(0,0)) +
      custome_theme("bar")
  })

  ## Render US Cases Bar plot
  output$plot_covid_cases <- renderPlotly ({

    plotly::ggplotly(plot_bar(), tooltip = c("text")) %>%
      config(displayModeBar = F)
  })

  ## US Testing Map
  plot_tests_map <- eventReactive(input$show_trend2, {
    validate(need(input$choose_states2 != "", "Hey, be sure to add a state or you'd run into an error :)"))

    plot_tests <- us_tests_map %>%
      filter(date == input$choose_date2) %>%
      filter(state %in% input$choose_states2) %>%
      ggplot(aes(x = lat, y = long, group = group)) +
      geom_polygon(data = us_states_map, colour = "#d3d3d3")+
      geom_polygon(aes(group = group,
                       fill = positive_prop,
                       text = paste('</br> Date:', date,
                                    '</br> State:', state,
                                    '</br> Tests Conducted:', daily_tests,
                                    '</br> New Cases:', daily_cases,
                                    '</br> % of Covid-19 Tests Returning Positive:', paste0(positive_prop, "%"))),
                   colour = "#d3d3d3") +
      scale_fill_distiller(type = "seq",
                           palette = "Purples",
                           direction = 1,
                           limits = c(0, 40),
                           na.value = "#402060") +
      ggtitle("Daily % of Covid-19 Tests Returning Positive") +
      custome_theme("map")
  })

  ## Render US Testing Map
  output$plot_tests_map <- renderPlotly ({
    plotly::ggplotly(plot_tests_map(), tooltip = c("text")) %>%
      config(displayModeBar = F)
  })

  ## US Testing Table
  plot_dt <- eventReactive(input$show_trend2, {
    total_tests_table <- total_tests_table %>%
      filter(Date == input$choose_date2) %>%
      filter(State %in% input$choose_states2) %>%
      arrange(desc(`% of Positive Cases`))
  })

  ## US Tests Bar Plot
  plot_bar2 <- eventReactive(input$show_trend2, {
    validate(need(input$choose_states2 != "", "Be sure to add a state"))

    plot_bar2 <- us_state_tests %>%
      filter(date == input$choose_date2) %>%
      filter(state %in% input$choose_states2) %>%
      ggplot(aes(x = daily_cases,
                 y = fct_reorder(state, daily_cases, .desc = TRUE))) +
      geom_col(aes(fill = daily_cases,
                   text = paste('</br> Date:', date,
                                '</br> State:', state,
                                '</br> Tests Conducted:', daily_tests,
                                '</br> New Cases:', daily_cases)),
               width = 0.8) +
      scale_fill_distiller(palette = "Purples", direction = 1) +
      labs(x = "Total cases (in '000s)", y = "") +
      scale_x_continuous(expand = c(0,0)) +
      custome_theme("bar")
  })

  ## Render US Tests Bar plot
  output$plot_covid_tests <- renderPlotly ({

    plotly::ggplotly(plot_bar2(), tooltip = c("text")) %>%
      config(displayModeBar = F)
  })

  ## Render DT Table
  output$plot_DT_tests <- DT::renderDT({
    plot_dt() %>%
      DT::datatable(
        class = 'cell-border stripe',
        rownames = FALSE,
        filter = 'top',
        selection = "multiple",
        escape = FALSE,
        options = list(
          pageLength = 10,
          sDom  = '<"top">lrt<"bottom">ip',
          initComplete = JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': '#1f1f1f', 'color': 'white'});",
            "}"
          )
        ),
        caption = htmltools::tags$caption(
          color = "white",
          style = 'caption-side: top; text-align: left;',
          'Table 1: ',
          em(paste0('Proportion of Positive Covid-19 Cases through Testing as of ', input$choose_date2))
        )) %>%
      formatPercentage('% of Tests per Population', digits = 2) %>%
      formatPercentage('% of Positive Cases', digits = 2) %>%
      formatCurrency(c('Total Cases','Total Tests'),currency = "", interval = 3, mark = ",", digits = 0) %>%
      formatStyle(
        c('Date', 'State','Total Cases', 'Total Tests', '% of Positive Cases', 'Total Population', '% of Tests per Population'),
        color = 'white',
        backgroundColor = '#1f1f1f'
      ) %>%
      formatStyle('% of Positive Cases',
                  backgroundColor = styleInterval(c(0, 0.03, 0.06, 0.09, 0.12, 0.15),
                                                  c('#dfdfff', '#b299e5', '#a284e0', '#9370db', '#845cd6', '#7447d1', '#4d2673')))
  })
}

# Create Shiny App Object -----------------------------------------------------------------

shinyApp(ui, server)

