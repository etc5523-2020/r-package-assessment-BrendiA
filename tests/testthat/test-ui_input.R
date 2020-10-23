test_that("Dates are valid", {
  ui_input("date", "choose_date", covid_us_states)
})

# input_id is not null
# Dates are within a valid range
# Maximum date > minimum date

test_that("States chosen are correct", {
  html_output <- as.character(ui_input("state", "choose_states" ,covid_us_states))
  expect_match(html_output, unique(covid_us_states$state))
})


# states corresponds to
