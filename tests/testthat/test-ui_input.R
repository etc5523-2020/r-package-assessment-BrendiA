test_that("States chosen are correct", {

  html_output <- ui_input("state", "choose_states" , covid_us_states)
  html_output <- as.character(html_output)
  expect_match(html_output, sample(covid_us_states$state, 1))

  expect_error(ui_input("state", "choose_states")) # missing data argument
  expect_invisible(ui_input("", "choose_states" , covid_us_states))

})

test_that("Dates are valid", {
  expect_error(ui_input("state", "choose_states")) # missing data argument
  expect_invisible(ui_input("", "choose_date", covid_us_states)) # no output if input_type not given
})
