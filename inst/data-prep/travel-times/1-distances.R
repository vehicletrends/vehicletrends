tictoc::tic() # Start timer

source(here::here('code', '0-setup.R'))

# For a given census tract, find the distances to all the dealerships
get_distances <- function(tract, dealer_counts) {
  temp <- copy(dealer_counts)
  temp[,
    distance := linear_dist(
      lat_d,
      lng_d,
      tract$lat_c,
      tract$lng_c
    )
  ]
  temp <- temp[distance <= 400] # Filter at 400 km (250 mi)
  temp <- temp[order(distance), -c('lat_d', 'lng_d')]
  temp[,
    c('cum_count', 'past20') := .(
      cumsum(n),
      cumsum(cumsum(n) >= 20)
    ),
    by = c('inventory_type', 'vehicle_type', 'powertrain', 'price_bin')
  ]
  temp <- temp[past20 <= 1]
  temp <- temp[
    order(
      inventory_type,
      vehicle_type,
      powertrain,
      price_bin,
      distance,
      desc(n)
    ),
  ]
  temp$GEOID <- tract$GEOID
  write_dataset(
    temp,
    partitioning = 'GEOID',
    here('data', 'travel_times', 'dealer_distances')
  )
}

# PEV counts by dealer and price bin ----

dealer_counts <- open_dataset(here::here('data', 'listings_2024.parquet')) %>%
  mutate(
    price_bin = case_when(
      price < 30000 ~ "$0-$30k",
      price >= 30000 & price < 40000 ~ "$30k-$40k",
      price >= 40000 & price < 50000 ~ "$40k-$50k",
      price >= 50000 & price < 60000 ~ "$50k-$60k",
      price >= 60000 ~ "$60k+",
      TRUE ~ "Other"
    )
  ) %>%
  count(
    dealer_id,
    inventory_type,
    powertrain,
    vehicle_type,
    price_bin
  ) %>%
  collect() %>%
  ungroup() %>%
  as.data.table()

# Append Tesla stores counts

counts_tesla <- read_parquet(here::here('data', 'tesla.parquet')) %>%
  select(-lat_d, -lng_d, -inventory_type, n = bev, -cv, -hev, -phev) %>%
  mutate(
    inventory_type = 'new',
    powertrain = 'bev',
    n = 2,
    vehicle_type = 'car',
    price_bin = "$50k-$60k"
  )
counts_tesla <- rbind(
  counts_tesla,
  counts_tesla %>% mutate(vehicle_type = 'suv', n = 1, price_bin = "$60k+")
) %>%
  select(names(dealer_counts))
dealer_counts <- dealer_counts %>%
  rbind(counts_tesla) %>%
  # Join on coords
  left_join(get_all_dealer_coords(), by = 'dealer_id') %>%
  as.data.table()

# Compute distances ----

# Compute distances to closest 20 vehicle listings for each
# GEOID, inventory_type, powertrain, vehicle_type, and price_bin

coords_tract <- get_coords_tract()

result <- parallel::mclapply(
  1:nrow(coords_tract),
  function(i) {
    get_distances(coords_tract[i, ], dealer_counts)
  },
  mc.cores = 2
)

# Merge into one parquet file
open_dataset(here('data', 'travel_times', 'dealer_distances')) %>%
  write_parquet(here('data', 'travel_times', 'dealer_distances.parquet'))

tictoc::toc() # Stop timer

# 11400.078 sec elapsed (3.16 hours)
