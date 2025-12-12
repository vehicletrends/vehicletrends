# Load functions, libraries, and other settings
source(here::here("code", "0-setup.R"))

# Open miles arrow dataset

ds <- load_ds() %>%
  filter(!is.na(miles), !is.na(age_years)) %>%
  filter(inventory_type == 'used') %>%
  filter(miles > 0)

# Basic quantiles by age ----

quantiles <- ds %>%
  filter(age_years <= 10) %>%
  mutate(age_months = age_years * 12) %>%
  group_by(age_months, powertrain, vehicle_type) %>%
  summarise(
    miles25 = quantile(miles, 0.25),
    miles50 = quantile(miles, 0.5),
    miles75 = quantile(miles, 0.75)
  ) %>%
  collect()

# Save

write_parquet(
  quantiles,
  here::here('data', 'quantiles_miles.parquet')
)

# Separately compute the quantiles for BEVs only, separating out Tesla

quantiles_bev <- ds %>%
  filter(age_years <= 10) %>%
  mutate(age_months = age_years * 12) %>%
  filter(powertrain == "bev") %>%
  group_by(age_months, vehicle_type, tesla) %>%
  summarise(
    miles25 = quantile(miles, 0.25),
    miles50 = quantile(miles, 0.5),
    miles75 = quantile(miles, 0.75)
  ) %>%
  collect()

# Save

write_parquet(
  quantiles_bev,
  here::here('data', 'quantiles_miles_bev.parquet')
)

# Quantiles of DVMT ----

# First, compute separately by vehicle type and powertrain

quantiles_dvmt_pt <- ds %>%
  mutate(
    age_days = as.numeric(age_years * 365.25),
    dvmt = miles / age_days
  ) %>%
  select(powertrain, vehicle_type, dvmt) %>%
  collect() %>%
  group_by(powertrain, vehicle_type) %>%
  get_quantiles_detailed(dvmt) %>%
  rename(dvmt = val)

# Now just for BEVs, separating out Tesla

quantiles_dvmt_bev <- ds %>%
  filter(powertrain == "bev") %>%
  mutate(
    age_days = as.numeric(age_years * 365.25),
    dvmt = miles / age_days
  ) %>%
  select(powertrain, tesla, vehicle_type, dvmt) %>%
  collect() %>%
  mutate(powertrain = ifelse(tesla == 1, 'bev_tesla', 'bev_non_tesla')) %>%
  group_by(powertrain, vehicle_type) %>%
  get_quantiles_detailed(dvmt) %>%
  rename(dvmt = val)

# Now compute for all vehicles

quantiles_dvmt_all <- ds %>%
  mutate(
    age_days = as.numeric(age_years * 365.25),
    dvmt = miles / age_days
  ) %>%
  select(dvmt) %>%
  collect() %>%
  get_quantiles_detailed(dvmt) %>%
  rename(dvmt = val) %>%
  mutate(
    powertrain = 'all',
    vehicle_type = 'all'
  ) %>%
  select(powertrain, vehicle_type, quantile, dvmt)

# Combine and save

quantiles_dvmt <- rbind(
  quantiles_dvmt_all,
  quantiles_dvmt_pt,
  quantiles_dvmt_bev
)

write_parquet(
  quantiles_dvmt,
  here::here('data', 'quantiles_dvmt.parquet')
)
