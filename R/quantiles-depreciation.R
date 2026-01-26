source(here::here("R", "setup.R"))

# Helper functions ----

get_quantiles_rr <- function(df) {
  df %>%
    summarise(
      rr25 = quantile(rr, 0.25),
      rr50 = quantile(rr, 0.50),
      rr75 = quantile(rr, 0.75)
    )
}

# Reshape rr quantiles to long format (call after collect)
reshape_quantiles_rr <- function(df) {
  df %>%
    pivot_longer(
      names_to = 'quantile',
      values_to = 'rr',
      cols = starts_with('rr')
    ) %>%
    mutate(quantile = as.numeric(gsub("rr", "", quantile)))
}

# Helper to run the full quantile pipeline for rr by age
collect_rr_quantiles <- function(df) {
  df %>%
    get_quantiles_rr() %>%
    collect() %>%
    ungroup() %>%
    reshape_quantiles_rr()
}

names_depreciation <- c(
  "age_bin",
  "powertrain",
  "vehicle_type",
  "quantile",
  "rr"
)

# Load and prepare data ----

ds <- load_ds() %>%
  filter(!is.na(price), !is.na(msrp)) %>%
  filter(inventory_type == 'used') %>%
  mutate(
    rr = price / msrp,
    age_months = age_years * 12
  ) %>%
  filter(age_months >= 12, age_months <= 180) %>% # 15 years old cap
  # Create 3-month age bins out to 180 months using integer division
  mutate(age_bin = floor(age_months / 3) * 3)

# Quantiles for all powertrains and vehicle types by age ----

depreciation_all <- ds %>%
  group_by(age_bin) %>%
  collect_rr_quantiles() %>%
  mutate(
    powertrain = 'all',
    vehicle_type = 'all'
  ) %>%
  select(all_of(names_depreciation))

# Quantiles by powertrain only
depreciation_pt <- ds %>%
  group_by(age_bin, powertrain) %>%
  collect_rr_quantiles() %>%
  mutate(vehicle_type = 'all') %>%
  select(all_of(names_depreciation))

# Quantiles by powertrain, BEV only (Tesla vs non-Tesla)
depreciation_pt_bev <- ds %>%
  select_bev_tesla() %>%
  group_by(age_bin, powertrain) %>%
  collect_rr_quantiles() %>%
  mutate(vehicle_type = 'all') %>%
  select(all_of(names_depreciation))

# Quantiles by vehicle_type only
depreciation_vt <- ds %>%
  group_by(age_bin, vehicle_type) %>%
  collect_rr_quantiles() %>%
  mutate(powertrain = 'all') %>%
  select(all_of(names_depreciation))

# Quantiles by powertrain and vehicle_type
depreciation_both <- ds %>%
  group_by(age_bin, powertrain, vehicle_type) %>%
  collect_rr_quantiles() %>%
  select(all_of(names_depreciation))

# Quantiles by powertrain and vehicle_type, BEV only (Tesla vs non-Tesla)
depreciation_both_bev <- ds %>%
  select_bev_tesla() %>%
  group_by(age_bin, powertrain, vehicle_type) %>%
  collect_rr_quantiles() %>%
  select(all_of(names_depreciation))

# Combine ----

depreciation <- rbind(
  depreciation_all,
  depreciation_vt,
  depreciation_pt,
  depreciation_pt_bev,
  depreciation_both,
  depreciation_both_bev
) %>%
  mutate(age_bin = age_bin + 1.5) %>% # midpoint of each bin
  format_labels() %>%
  arrange(powertrain, vehicle_type, age_bin, quantile)

# Preview
depreciation %>%
  filter(quantile == 50) %>%
  ggplot() +
  geom_smooth(
    aes(
      x = age_bin,
      y = rr,
      color = vehicle_type
    ),
    se = FALSE
  ) +
  facet_wrap(vars(powertrain)) +
  labs(x = "Age (months)", y = "Retention Rate (price / msrp)")

# Save ----

write_csv(
  depreciation,
  here::here('data-raw', 'depreciation.csv')
)

usethis::use_data(depreciation, overwrite = TRUE)
