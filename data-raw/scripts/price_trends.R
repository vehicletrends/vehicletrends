source(here::here("data-raw", "scripts", "0setup.R"))

ds <- load_ds()

# NEW INVENTORY ----

# Create price trends for new inventory
price_trends_new <- ds %>%
  filter(inventory_type == 'new') %>%
  filter(!is.na(price)) %>%
  filter(!is.na(state)) %>%
  filter(!is.na(year)) %>%
  filter(!is.na(vehicle_type)) %>%
  group_by(listing_year, state, year, vehicle_type) %>%
  summarise(
    avg_price = mean(price, na.rm = TRUE),
    n_listings = n()
  ) %>%
  collect()

# Calculate number of unique make-model-year combinations for new inventory
make_model_counts_new <- ds %>%
  filter(inventory_type == 'new') %>%
  filter(!is.na(make)) %>%
  filter(!is.na(model)) %>%
  filter(!is.na(year)) %>%
  count(listing_year, state, make, model, year) %>%
  collect() %>%
  group_by(listing_year, state) %>%
  summarise(n_make_model_year = n()) %>%
  ungroup()

# Join make-model counts to new price trends
price_trends_new <- price_trends_new %>%
  left_join(make_model_counts_new, by = c("listing_year", "state")) %>%
  arrange(listing_year, state, year)

# USED INVENTORY ----

# Create price trends for used inventory
price_trends_used <- ds %>%
  filter(inventory_type == 'used') %>%
  filter(!is.na(price)) %>%
  filter(!is.na(state)) %>%
  filter(!is.na(year)) %>%
  filter(!is.na(vehicle_type)) %>%
  group_by(listing_year, state, year, vehicle_type) %>%
  summarise(
    avg_price = mean(price, na.rm = TRUE),
    n_listings = n()
  ) %>%
  collect()

# Calculate depreciation rates by state and calendar year
# Using used listings to calculate retention rate (price/msrp) by age
depreciation_rates <- ds %>%
  filter(inventory_type == 'used') %>%
  filter(age_years >= 1 & age_years <= 10) %>%
  filter(!is.na(price), !is.na(msrp)) %>%
  mutate(rr = price / msrp) %>%
  filter(rr < 1) %>%
  select(listing_year, state, rr, age_years) %>%
  collect() %>%
  group_by(listing_year, state) %>%
  do({
    # Fit exponential decay model for each state/listing_year
    tryCatch(
      {
        model <- feols(log(rr) ~ age_years, data = .)
        data.frame(
          listing_year = unique(.$listing_year),
          state = unique(.$state),
          dep_annual_rate = 1 - exp(coef(model)["age_years"])
        )
      },
      error = function(e) {
        # Return NA if model fails
        data.frame(
          listing_year = unique(.$listing_year),
          state = unique(.$state),
          dep_annual_rate = NA_real_
        )
      }
    )
  }) %>%
  ungroup()

# Join depreciation rates to used price trends
price_trends_used <- price_trends_used %>%
  left_join(depreciation_rates, by = c("listing_year", "state"))

# Calculate number of unique make-model-year combinations for used inventory
make_model_counts_used <- ds %>%
  filter(inventory_type == 'used') %>%
  filter(!is.na(make)) %>%
  filter(!is.na(model)) %>%
  filter(!is.na(year)) %>%
  count(listing_year, state, make, model, year) %>%
  collect() %>%
  group_by(listing_year, state) %>%
  summarise(n_make_model_year = n()) %>%
  ungroup()

# Join make-model counts to used price trends
price_trends_used <- price_trends_used %>%
  left_join(make_model_counts_used, by = c("listing_year", "state")) %>%
  arrange(listing_year, state, year)

# SAVE ----

# Save to CSV
write_csv(
  price_trends_new,
  here::here('data-raw', 'price_trends_new.csv')
)
write_csv(
  price_trends_used,
  here::here('data-raw', 'price_trends_used.csv')
)

# Save datasets for package
usethis::use_data(price_trends_new, overwrite = TRUE)
usethis::use_data(price_trends_used, overwrite = TRUE)
