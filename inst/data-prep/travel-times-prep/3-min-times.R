tictoc::tic() # Start timer

source(here::here('code', '0-setup.R'))

# Rearranges rows by duration and then compute cumulative vehicle
# counts so that we can know how long it takes to get to 1, 5, 10, and 20
# vehicles for each GEOID, listing_year, inventory_type, technology, & price_bin

dealer_dt <- read_parquet(
  # Start with the linear distances data
  here('data', 'travel_times', 'dealer_distances.parquet')
) %>%
  filter(inventory_type == 'new') %>%
  select(-cum_count, -past20, -distance) %>%
  # Join on trip duration and distances
  left_join(
    read_parquet(here::here('data', 'travel_times', 'dealer_times.parquet')) %>%
      filter(!is.na(duration_min)) %>%
      mutate(GEOID = as.character(GEOID)),
    by = c('GEOID', 'dealer_id')
  ) %>%
  filter(!is.na(duration_min))

# Now get the min times
dealer_dt <- dealer_dt[order(
  GEOID,
  powertrain,
  vehicle_type,
  price_bin,
  duration_min
)]
dealer_dt[,
  c('cum_count', 'past1', 'past5', 'past10', 'past20') := .(
    cumsum(n),
    cumsum(cumsum(n) >= 1),
    cumsum(cumsum(n) >= 5),
    cumsum(cumsum(n) >= 10),
    cumsum(cumsum(n) >= 20)
  ),
  by = c(
    'GEOID',
    'powertrain',
    'vehicle_type', 
    'price_bin'
  )
]
dealer_dt <- dealer_dt[
  (past1 == 1) | (past5 == 1) | (past10 == 1) | (past20 == 1)
]

write_parquet(dealer_dt, here('data', 'travel_times', 'min_times.parquet'))

tictoc::toc() # Stop timer
