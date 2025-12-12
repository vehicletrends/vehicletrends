# Load functions, libraries, and other settings
source(here::here("code", "0-setup.R"))

ds <- load_ds()

ds <- ds %>%
  # Compute RR for all vehicles
  filter(!is.na(price), !is.na(msrp)) %>%
  mutate(
    age_months = round(age_years * 12),
    rr = price / msrp
  )

# Compute quantiles of RR

quantiles <- ds %>%
  group_by(age_months, powertrain, vehicle_type) %>%
  summarise(
    rr25 = quantile(rr, 0.25),
    rr50 = quantile(rr, 0.5),
    rr75 = quantile(rr, 0.75)
  ) %>%
  collect()

# Save

write_parquet(
  quantiles,
  here::here('data', 'quantiles_rr.parquet')
)


# Separately compute the quantiles for BEVs only, separating out Tesla

quantiles_bev <- ds %>%
  filter(powertrain == "bev", vehicle_type == 'car') %>%
  group_by(age_months, tesla) %>%
  summarise(
    rr25 = quantile(rr, 0.25),
    rr50 = quantile(rr, 0.5),
    rr75 = quantile(rr, 0.75)
  ) %>%
  collect()

# Save

write_parquet(
  quantiles_bev,
  here::here('data', 'quantiles_rr_bev.parquet')
)
