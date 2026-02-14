source(here::here("inst", "data-prep", "0setup.R"))

font <- "Arial"
col_red <- "#FF0000"
col_blue <- "#0000FF"

# Import HHI data

hhi_root <- 'data-local'
iso <- isochrone_min # Global var in 0setup.R
hhi_pt <- read_parquet(here(hhi_root, paste0("hhi_pt_", iso, ".parquet")))
hhi_vt <- read_parquet(here(hhi_root, paste0("hhi_vt_", iso, ".parquet")))
hhi_pb <- read_parquet(here(hhi_root, paste0("hhi_pb_", iso, ".parquet")))

summarise_hhi <- function(dt, col, by_cols) {
  dt[,
    .(
      median = median(get(col)),
      q25 = quantile(get(col), 0.25),
      q75 = quantile(get(col), 0.75),
      IQR = IQR(get(col)),
      upper = quantile(get(col), 0.75) + 1.5 * IQR(get(col)),
      lower = quantile(get(col), 0.25) - 1.5 * IQR(get(col))
    ),
    by = by_cols
  ]
}

# Helper to summarise and label one HHI combination
make_hhi_summary <- function(dt, hhi_col, group_col) {
  result <- summarise_hhi(dt, hhi_col, c(group_col, "listing_year"))
  result[, group_var := group_col]
  setnames(result, group_col, "group_level")
  result[, hhi_var := gsub("^hhi_", "", hhi_col)]
  result[, group_level := as.character(group_level)]
  result
}

# Combine all HHI summaries into one tidy dataset
hhi <- rbindlist(list(
  # By powertrain
  make_hhi_summary(hhi_pt, "hhi_make", "powertrain"),
  make_hhi_summary(hhi_pt, "hhi_vehicle_type", "powertrain"),
  make_hhi_summary(hhi_pt, "hhi_price_bin", "powertrain"),
  # By vehicle_type
  make_hhi_summary(hhi_vt, "hhi_make", "vehicle_type"),
  make_hhi_summary(hhi_vt, "hhi_powertrain", "vehicle_type"),
  make_hhi_summary(hhi_vt, "hhi_price_bin", "vehicle_type"),
  # By price_bin
  make_hhi_summary(hhi_pb, "hhi_make", "price_bin"),
  make_hhi_summary(hhi_pb, "hhi_powertrain", "price_bin"),
  make_hhi_summary(hhi_pb, "hhi_vehicle_type", "price_bin")
))

# Reorder columns
setcolorder(hhi, c(
  "group_var", "group_level", "hhi_var", "listing_year",
  "median", "q25", "q75", "IQR", "upper", "lower"
))

# Save CSV to data-raw
write_csv(hhi, here('data-raw', 'hhi.csv'))

# Export as .rda
hhi <- as_tibble(hhi)
usethis::use_data(hhi, overwrite = TRUE)

# ggplots ----

# By powertrain

hhi_pt %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_make, y = powertrain, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Powertrain',
    fill = 'Listing Year',
    title = 'Vehicle brand HHI by powertrain',
    subtitle = 'Higher number indicates greater concentration'
  )

hhi_pt %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_vehicle_type, y = powertrain, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Powertrain',
    fill = 'Listing Year',
    title = 'Vehicle type HHI by powertrain',
    subtitle = 'Higher number indicates greater concentration'
  )

hhi_pt %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_price_bin, y = powertrain, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Powertrain',
    fill = 'Listing Year',
    title = 'Price bin HHI by powertrain',
    subtitle = 'Higher number indicates greater concentration'
  )

# By vehicle_type

hhi_vt %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_make, y = vehicle_type, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Vehicle Type',
    fill = 'Listing Year',
    title = 'Vehicle brand HHI by vehicle type',
    subtitle = 'Higher number indicates greater concentration'
  )

hhi_vt %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_powertrain, y = vehicle_type, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Vehicle Type',
    fill = 'Listing Year',
    title = 'Powertrain HHI by vehicle type',
    subtitle = 'Higher number indicates greater concentration'
  )

hhi_vt %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_price_bin, y = vehicle_type, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Vehicle Type',
    fill = 'Listing Year',
    title = 'Price bin HHI by vehicle type',
    subtitle = 'Higher number indicates greater concentration'
  )

# By price_bin

hhi_pb %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_make, y = price_bin, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Price Bin',
    fill = 'Listing Year',
    title = 'Vehicle brand HHI by price bin',
    subtitle = 'Higher number indicates greater concentration'
  )

hhi_pb %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_powertrain, y = price_bin, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Price Bin',
    fill = 'Listing Year',
    title = 'Powertrain HHI by price bin',
    subtitle = 'Higher number indicates greater concentration'
  )

hhi_pb %>%
  ggplot() +
  geom_boxplot(
    aes(x = hhi_vehicle_type, y = price_bin, fill = listing_year),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Price Bin',
    fill = 'Listing Year',
    title = 'Vehicle type HHI by price bin',
    subtitle = 'Higher number indicates greater concentration'
  )
