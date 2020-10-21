## code to prepare `covid_us_states` dataset goes here

library(readr)
library(dplyr)
library(stringr)

# ----------------------------- U.S population estimates for U.S. counties in 2019 dataset ----------------------

us_pop_ests <- readr::read_csv("https://raw.githubusercontent.com/kingaa/covid-19-data/master/pop_est_2019.csv")

# Extract first two digits to get state's FIPS
us_pop_ests <- us_pop_ests %>%
  mutate(fips = stringr::str_extract(fips, "..")) %>%
  filter(fips != "36") # Remove NY county data (error in data)

# Replace NY data with actual state population estimates
us_pop_ests$fips <- dplyr::recode(us_pop_ests$fips, "NY" = "36")

# Find population estimates for each U.S. state
us_pop_ests <- us_pop_ests %>%
  group_by(fips) %>%
  summarise(population = sum(population))

usethis::use_data(us_pop_ests, overwrite = TRUE)

# ----------------------------- Covid-19 reported cases in U.S dataset -----------------------------------------

covid_us_states <- readr::read_csv("data-raw/covid_us_states.csv") %>%
  # Remove states not in map data
  filter(!state %in% c("Puerto Rico", "Virgin Islands", "Guam", "Northern Mariana Islands"))

# Include population estimates
covid_us_states <- covid_us_states %>%
  left_join(us_pop_ests, by = "fips")

# Find cases per million
covid_us_states <- covid_us_states %>%
  mutate(cases_per_mil = round(cases * (1000000 / population), 2),
         deaths_per_mil = round(deaths * (1000000 / population), 2)
  )

usethis::use_data(covid_us_states, overwrite = TRUE)
