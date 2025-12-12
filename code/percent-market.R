source(here::here('code', '0-setup.R'))

price_levels <- c(
  "$0-$30k",
  "$30k-$40k",
  "$40k-$50k",
  "$50k-$60k",
  "$60k+"
)

# Open
ds <- load_ds() %>%
  filter(inventory_type == 'new') %>%
  filter(listing_year %in% c(2018, 2024)) %>%
  mutate(
    price_bin = case_when(
      price < 30000 ~ "$0-$30k",
      price >= 30000 & price < 40000 ~ "$30k-$40k",
      price >= 40000 & price < 50000 ~ "$40k-$50k",
      price >= 50000 & price < 60000 ~ "$50k-$60k",
      price >= 60000 ~ "$60k+",
      TRUE ~ "Other"
    )
  )

# Price bin by powertrain - compute counts by powertrain
get_dumbbell_data <- function(ds, var1, var2) {
  dumbbell_data <- ds %>%
    count(listing_year, {{ var1 }}, {{ var2 }}) %>%
    collect() %>%
    group_by(listing_year, {{ var1 }}) %>%
    mutate(p = n / sum(n)) %>%
    ungroup() %>%
    select(-n) %>%
    pivot_wider(
      names_from = listing_year,
      values_from = p,
      names_prefix = "year_"
    ) %>%
    mutate(
      year_2018 = ifelse(is.na(year_2018), 0, year_2018),
      year_2024 = ifelse(is.na(year_2024), 0, year_2024)
    )
  return(dumbbell_data)
}

get_dumbbell_data(ds, powertrain, vehicle_type) %>%
  write_csv(here('data', 'p_market_powertrain_vehicle_type.csv'))
get_dumbbell_data(ds, powertrain, price_bin) %>%
  write_csv(here('data', 'p_market_powertrain_price_bin.csv'))
get_dumbbell_data(ds, vehicle_type, powertrain) %>%
  write_csv(here('data', 'p_market_vehicle_type_powertrain.csv'))
get_dumbbell_data(ds, vehicle_type, price_bin) %>%
  write_csv(here('data', 'p_market_vehicle_type_price_bin.csv'))
get_dumbbell_data(ds, price_bin, powertrain) %>%
  write_csv(here('data', 'p_market_price_bin_powertrain.csv'))
get_dumbbell_data(ds, price_bin, vehicle_type) %>%
  write_csv(here('data', 'p_market_price_bin_vehicle_type.csv'))
