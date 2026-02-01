source(here::here("inst", "data-prep", "0setup.R"))

# Scrape registration tables from AFDC for years 2016-2024

years <- 2016:2024

registrations_raw <- map_dfr(years, function(y) {
  url <- paste0("https://afdc.energy.gov/vehicle-registration?year=", y)
  page <- read_html(url)
  tbl <- page %>%
    html_table() %>%
    .[[1]]
  tbl <- tbl %>% mutate(across(-State, as.character))
  tbl$year <- y
  return(tbl)
})

# Tidy up into long format

registrations <- registrations_raw %>%
  pivot_longer(
    cols = -c(State, year),
    names_to = "powertrain",
    values_to = "count"
  ) %>%
  rename(state = State) %>%
  # Parse count values (remove commas, convert to numeric)
  mutate(
    count = as.numeric(gsub(",", "", count)),
    year = as.integer(year),
    powertrain = recode(
      powertrain,
      "Electric (EV)" = "Battery Electric (BEV)",
      "Ethanol/Flex (E85)" = "Flex Fuel (E85)",
      "Hydrogen" = "Fuel Cell",
      "Unknown Fuel" = "Unknown"
    )
  ) %>%
  select(year, state, powertrain, count) %>%
  arrange(year, state, powertrain)

# Save

write_csv(
  registrations,
  here::here('data-raw', 'registrations.csv')
)

usethis::use_data(registrations, overwrite = TRUE)
