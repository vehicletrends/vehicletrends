source(here::here("R", "setup.R"))

get_quantiles_vmt <- function(df) {
  df %>%
    summarise(
      vmt25 = quantile(miles, 0.25),
      vmt50 = quantile(miles, 0.50),
      vmt75 = quantile(miles, 0.75)
    )
}

# Reshape vmt quantiles to long format (call after collect)
reshape_quantiles_vmt <- function(df) {
  df %>%
    pivot_longer(
      names_to = 'quantile',
      values_to = 'miles',
      cols = starts_with('vmt')
    ) %>%
    mutate(quantile = as.numeric(gsub("vmt", "", quantile)))
}

# Helper to run the full quantile pipeline for vmt by age
collect_vmt_quantiles <- function(df) {
  df %>%
    get_quantiles_vmt() %>%
    collect() %>%
    ungroup() %>%
    reshape_quantiles_vmt()
}

# Summarize dvmt quantiles (works in Arrow)
get_quantiles_dvmt <- function(df) {
  df %>%
    summarise(
      dvmt01 = quantile(dvmt, 0.01),
      dvmt02 = quantile(dvmt, 0.02),
      dvmt03 = quantile(dvmt, 0.03),
      dvmt04 = quantile(dvmt, 0.04),
      dvmt05 = quantile(dvmt, 0.05),
      dvmt06 = quantile(dvmt, 0.06),
      dvmt07 = quantile(dvmt, 0.07),
      dvmt08 = quantile(dvmt, 0.08),
      dvmt09 = quantile(dvmt, 0.09),
      dvmt10 = quantile(dvmt, 0.10),
      dvmt11 = quantile(dvmt, 0.11),
      dvmt12 = quantile(dvmt, 0.12),
      dvmt13 = quantile(dvmt, 0.13),
      dvmt14 = quantile(dvmt, 0.14),
      dvmt15 = quantile(dvmt, 0.15),
      dvmt16 = quantile(dvmt, 0.16),
      dvmt17 = quantile(dvmt, 0.17),
      dvmt18 = quantile(dvmt, 0.18),
      dvmt19 = quantile(dvmt, 0.19),
      dvmt20 = quantile(dvmt, 0.20),
      dvmt21 = quantile(dvmt, 0.21),
      dvmt22 = quantile(dvmt, 0.22),
      dvmt23 = quantile(dvmt, 0.23),
      dvmt24 = quantile(dvmt, 0.24),
      dvmt25 = quantile(dvmt, 0.25),
      dvmt26 = quantile(dvmt, 0.26),
      dvmt27 = quantile(dvmt, 0.27),
      dvmt28 = quantile(dvmt, 0.28),
      dvmt29 = quantile(dvmt, 0.29),
      dvmt30 = quantile(dvmt, 0.30),
      dvmt31 = quantile(dvmt, 0.31),
      dvmt32 = quantile(dvmt, 0.32),
      dvmt33 = quantile(dvmt, 0.33),
      dvmt34 = quantile(dvmt, 0.34),
      dvmt35 = quantile(dvmt, 0.35),
      dvmt36 = quantile(dvmt, 0.36),
      dvmt37 = quantile(dvmt, 0.37),
      dvmt38 = quantile(dvmt, 0.38),
      dvmt39 = quantile(dvmt, 0.39),
      dvmt40 = quantile(dvmt, 0.40),
      dvmt41 = quantile(dvmt, 0.41),
      dvmt42 = quantile(dvmt, 0.42),
      dvmt43 = quantile(dvmt, 0.43),
      dvmt44 = quantile(dvmt, 0.44),
      dvmt45 = quantile(dvmt, 0.45),
      dvmt46 = quantile(dvmt, 0.46),
      dvmt47 = quantile(dvmt, 0.47),
      dvmt48 = quantile(dvmt, 0.48),
      dvmt49 = quantile(dvmt, 0.49),
      dvmt50 = quantile(dvmt, 0.50),
      dvmt51 = quantile(dvmt, 0.51),
      dvmt52 = quantile(dvmt, 0.52),
      dvmt53 = quantile(dvmt, 0.53),
      dvmt54 = quantile(dvmt, 0.54),
      dvmt55 = quantile(dvmt, 0.55),
      dvmt56 = quantile(dvmt, 0.56),
      dvmt57 = quantile(dvmt, 0.57),
      dvmt58 = quantile(dvmt, 0.58),
      dvmt59 = quantile(dvmt, 0.59),
      dvmt60 = quantile(dvmt, 0.60),
      dvmt61 = quantile(dvmt, 0.61),
      dvmt62 = quantile(dvmt, 0.62),
      dvmt63 = quantile(dvmt, 0.63),
      dvmt64 = quantile(dvmt, 0.64),
      dvmt65 = quantile(dvmt, 0.65),
      dvmt66 = quantile(dvmt, 0.66),
      dvmt67 = quantile(dvmt, 0.67),
      dvmt68 = quantile(dvmt, 0.68),
      dvmt69 = quantile(dvmt, 0.69),
      dvmt70 = quantile(dvmt, 0.70),
      dvmt71 = quantile(dvmt, 0.71),
      dvmt72 = quantile(dvmt, 0.72),
      dvmt73 = quantile(dvmt, 0.73),
      dvmt74 = quantile(dvmt, 0.74),
      dvmt75 = quantile(dvmt, 0.75),
      dvmt76 = quantile(dvmt, 0.76),
      dvmt77 = quantile(dvmt, 0.77),
      dvmt78 = quantile(dvmt, 0.78),
      dvmt79 = quantile(dvmt, 0.79),
      dvmt80 = quantile(dvmt, 0.80),
      dvmt81 = quantile(dvmt, 0.81),
      dvmt82 = quantile(dvmt, 0.82),
      dvmt83 = quantile(dvmt, 0.83),
      dvmt84 = quantile(dvmt, 0.84),
      dvmt85 = quantile(dvmt, 0.85),
      dvmt86 = quantile(dvmt, 0.86),
      dvmt87 = quantile(dvmt, 0.87),
      dvmt88 = quantile(dvmt, 0.88),
      dvmt89 = quantile(dvmt, 0.89),
      dvmt90 = quantile(dvmt, 0.90),
      dvmt91 = quantile(dvmt, 0.91),
      dvmt92 = quantile(dvmt, 0.92),
      dvmt93 = quantile(dvmt, 0.93),
      dvmt94 = quantile(dvmt, 0.94),
      dvmt95 = quantile(dvmt, 0.95),
      dvmt96 = quantile(dvmt, 0.96),
      dvmt97 = quantile(dvmt, 0.97),
      dvmt98 = quantile(dvmt, 0.98),
      dvmt99 = quantile(dvmt, 0.99)
    )
}

# Reshape dvmt quantiles to long format (call after collect)
reshape_quantiles_dvmt <- function(df) {
  df %>%
    pivot_longer(
      names_to = 'quantile',
      values_to = 'miles',
      cols = starts_with('dvmt')
    ) %>%
    mutate(quantile = as.numeric(gsub("dvmt", "", quantile)))
}

# Helper to run the full quantile pipeline
collect_dvmt_quantiles <- function(df) {
  df %>%
    get_quantiles_dvmt() %>%
    collect() %>%
    reshape_quantiles_dvmt()
}

select_bev_tesla <- function(df) {
  df %>%
    filter(powertrain == "bev") %>%
    mutate(powertrain = ifelse(tesla == 1, 'bev_tesla', 'bev_non_tesla'))
}

names_vmt_age <- c(
  "age_bin",
  "powertrain",
  "vehicle_type",
  "quantile",
  "miles"
)

names_vmt_daily <- c(
  "powertrain",
  "vehicle_type",
  "quantile",
  "miles"
)

# Open miles arrow dataset

ds <- load_ds() %>%
  filter(!is.na(miles), !is.na(age_years)) %>%
  filter(inventory_type == 'used') %>%
  filter(miles > 0) %>%
  mutate(age_months = age_years * 12) %>%
  filter(age_months <= 180) %>% # 15 years old cap
  # Create 3-month age bins out to 180 months using integer division
  mutate(age_bin = floor(age_months / 3) * 3)

# Quantiles for all powertrains by age
vmt_age_all <- ds %>%
  group_by(age_bin) %>%
  collect_vmt_quantiles() %>%
  mutate(
    powertrain = 'all',
    vehicle_type = 'all'
  ) %>%
  select(all_of(names_vmt_age))

# Quantiles for all powertrains by age
vmt_age_pt <- ds %>%
  group_by(age_bin, powertrain) %>%
  collect_vmt_quantiles() %>%
  mutate(vehicle_type = 'all') %>%
  select(all_of(names_vmt_age))

# Quantiles for all powertrains by age, BEV only
vmt_age_pt_bev <- ds %>%
  select_bev_tesla() %>%
  group_by(age_bin, powertrain) %>%
  collect_vmt_quantiles() %>%
  mutate(vehicle_type = 'all') %>%
  select(all_of(names_vmt_age))

# Quantiles for all vehicle_types by age
vmt_age_vt <- ds %>%
  group_by(age_bin, vehicle_type) %>%
  collect_vmt_quantiles() %>%
  mutate(powertrain = 'all') %>%
  select(all_of(names_vmt_age))

# Quantiles for all powertrains and vehicle_types by age
vmt_age_both <- ds %>%
  group_by(age_bin, powertrain, vehicle_type) %>%
  collect_vmt_quantiles() %>%
  select(all_of(names_vmt_age))

# Quantiles for all powertrains and vehicle_types by age, BEV only
vmt_age_both_bev <- ds %>%
  select_bev_tesla() %>%
  group_by(age_bin, powertrain, vehicle_type) %>%
  collect_vmt_quantiles() %>%
  select(all_of(names_vmt_age))

# Combine
vmt_age <- rbind(
  vmt_age_all,
  vmt_age_vt,
  vmt_age_pt,
  vmt_age_pt_bev,
  vmt_age_both,
  vmt_age_both_bev
) %>%
  mutate(age_bin = age_bin + 1.5) %>% # midpoint of each bin
  format_labels() %>%
  arrange(powertrain, vehicle_type, age_bin, quantile)

# Preview
vmt_age %>%
  filter(quantile == 50) %>%
  ggplot() +
  geom_smooth(
    aes(
      x = age_bin,
      y = miles,
      color = vehicle_type
    ),
    se = FALSE
  ) +
  facet_wrap(vars(powertrain)) +
  labs(x = "Age (months)")


# Quantiles of daily VMT ----

# Prepare dataset with daily vmt calculated
ds_daily <- ds %>%
  mutate(
    age_days = age_years * 365.25,
    dvmt = miles / age_days
  )

# Quantiles for all powertrains
vmt_daily_pt <- ds_daily %>%
  group_by(powertrain) %>%
  collect_dvmt_quantiles() %>%
  mutate(vehicle_type = 'all') %>%
  select(all_of(names_vmt_daily))

# Quantiles for all powertrains, BEV only
vmt_daily_pt_bev <- ds_daily %>%
  select_bev_tesla() %>%
  group_by(powertrain) %>%
  collect_dvmt_quantiles() %>%
  mutate(vehicle_type = 'all') %>%
  select(all_of(names_vmt_daily))

# Quantiles for all vehicle_types
vmt_daily_vt <- ds_daily %>%
  group_by(vehicle_type) %>%
  collect_dvmt_quantiles() %>%
  mutate(powertrain = 'all') %>%
  select(all_of(names_vmt_daily))

# Quantiles for all powertrains and vehicle_types
vmt_daily_both <- ds_daily %>%
  group_by(powertrain, vehicle_type) %>%
  collect_dvmt_quantiles() %>%
  select(all_of(names_vmt_daily))

# Quantiles for all powertrains and vehicle_types, BEV only
vmt_daily_both_bev <- ds_daily %>%
  select_bev_tesla() %>%
  group_by(powertrain, vehicle_type) %>%
  collect_dvmt_quantiles() %>%
  select(all_of(names_vmt_daily))

# Quantiles for all vehicles
vmt_daily_all <- ds_daily %>%
  collect_dvmt_quantiles() %>%
  mutate(
    powertrain = 'all',
    vehicle_type = 'all'
  ) %>%
  select(all_of(names_vmt_daily))

# Combine
vmt_daily <- rbind(
  vmt_daily_all,
  vmt_daily_pt,
  vmt_daily_vt,
  vmt_daily_pt_bev,
  vmt_daily_both,
  vmt_daily_both_bev
) %>%
  format_labels() %>%
  arrange(powertrain, vehicle_type, quantile)

# Save
write_csv(
  vmt_age,
  here::here('data-raw', 'vmt_age.csv')
)
write_csv(
  vmt_daily,
  here::here('data-raw', 'vmt_daily.csv')
)

# Save the datasets for package
usethis::use_data(vmt_age, overwrite = TRUE)
usethis::use_data(vmt_daily, overwrite = TRUE)
