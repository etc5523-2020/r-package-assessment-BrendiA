## code to prepare `us_states_map` dataset goes here

library(usmap)
library(dplyr)


# ------------ U.S states map data ----------------------

us_states_map <- us_map(regions = "states") %>%
  select(x, y, group, fips, abbr) %>%
  rename(lat = x,
         long = y)

usethis::use_data(us_states_map, overwrite = TRUE)
