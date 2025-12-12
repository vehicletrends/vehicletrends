source(here::here('code', '0-setup.R'))

# Open
ds <- load_ds() %>%
  filter(inventory_type == 'new') %>%
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

get_dealer_percentages <- function(var1, var2) {
  dealers_all <- ds %>%
    distinct(dealer_id, listing_year) %>%
    count(listing_year, name = "total_dealers")

  ds %>%
    # Get distinct dealers that have at least one of each var1/var2 combo
    distinct(dealer_id, listing_year, {{ var1 }}, {{ var2 }}) %>%
    # Count dealers per year/var1/var2
    count(listing_year, {{ var1 }}, {{ var2 }}) %>%
    # Get total dealers per year and join
    left_join(dealers_all, by = "listing_year") %>%
    # Calculate percentage
    mutate(p = n / total_dealers) %>%
    select(listing_year, {{ var1 }}, {{ var2 }}, p) %>%
    collect() %>%
    arrange(listing_year, {{ var1 }}, {{ var2 }}) %>%
    as.data.table()
}

# Example usage for powertrain and vehicle_type
p_one_powertrain_vehicle_type <- get_dealer_percentages(
  powertrain,
  vehicle_type
)

p_one_vehicle_type_price_bin <- get_dealer_percentages(
  vehicle_type,
  price_bin
)

p_one_powertrain_price_bin <- get_dealer_percentages(
  powertrain,
  price_bin
)

p_one_powertrain_vehicle_type %>%
  write_csv(here('data', 'p_one_powertrain_vehicle_type.csv'))

p_one_powertrain_price_bin %>%
  write_csv(here('data', 'p_one_powertrain_price_bin.csv'))

p_one_vehicle_type_price_bin %>%
  write_csv(here('data', 'p_one_vehicle_type_price_bin.csv'))

# Visualize

p_one_powertrain_vehicle_type %>%
  ggplot() +
  geom_line(
    aes(
      x = listing_year,
      y = p
    )
  ) +
  facet_grid(powertrain ~ vehicle_type)

p_one_powertrain_price_bin %>%
  ggplot() +
  geom_line(
    aes(
      x = listing_year,
      y = p
    )
  ) +
  facet_grid(powertrain ~ price_bin)

p_one_vehicle_type_price_bin %>%
  ggplot() +
  geom_line(
    aes(
      x = listing_year,
      y = p
    )
  ) +
  facet_grid(vehicle_type ~ price_bin)
