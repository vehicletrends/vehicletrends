# Load functions, libraries, and other settings
source(here::here("code", "0-setup.R"))

ds <- load_ds() %>%
  filter(age_years >= 1 & age_years <= 9) |>
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
  collect() %>%
  clean_factors_powertrain() %>%
  clean_factors_vehicle_type()

# Save

write_csv(
  quantiles,
  here::here('data', 'quantiles_rr.csv')
)


# Separately compute the quantiles for BEVs only, separating out Tesla

quantiles_bev <- ds %>%
  filter(powertrain == "bev") %>%
  mutate(powertrain = ifelse(tesla == 1, 'bev_tesla', 'bev_non_tesla')) %>%
  group_by(age_months, powertrain, vehicle_type) %>%
  summarise(
    rr25 = quantile(rr, 0.25),
    rr50 = quantile(rr, 0.5),
    rr75 = quantile(rr, 0.75)
  ) %>%
  collect()

# Save

write_csv(
  quantiles_bev,
  here::here('data', 'quantiles_rr_bev.csv')
)
