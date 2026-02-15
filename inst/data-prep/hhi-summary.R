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
      mean = mean(get(col)),
      median = median(get(col)),
      q25 = quantile(get(col), 0.25),
      q75 = quantile(get(col), 0.75),
      IQR = IQR(get(col)),
      lower = quantile(get(col), 0.25) - 1.5 * IQR(get(col)),
      upper = quantile(get(col), 0.75) + 1.5 * IQR(get(col))
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
setcolorder(
  hhi,
  c(
    "group_var",
    "group_level",
    "hhi_var",
    "listing_year",
    "mean",
    "median",
    "q25",
    "q75",
    "IQR",
    "upper",
    "lower"
  )
)

# Format group_level labels based on group_var
powertrain_labels <- c(
  "cv" = "Gasoline",
  "diesel" = "Diesel",
  "flex" = "Flex Fuel (E85)",
  "hev" = "Hybrid Electric (HEV)",
  "phev" = "Plug-In Hybrid Electric (PHEV)",
  "bev" = "Battery Electric (BEV)",
  "fcev" = "Fuel Cell"
)
vehicle_type_labels <- c(
  "car" = "Car",
  "cuv" = "CUV",
  "suv" = "SUV",
  "pickup" = "Pickup",
  "minivan" = "Minivan"
)
hhi[group_var == "powertrain", group_level := powertrain_labels[group_level]]
hhi[
  group_var == "vehicle_type",
  group_level := vehicle_type_labels[group_level]
]

# Save CSV to data-raw
write_csv(hhi, here('data-raw', 'hhi.csv'))

# Export as .rda
hhi <- as_tibble(hhi)
usethis::use_data(hhi, overwrite = TRUE)

# ggplots ----

hhi_plot <- function(data, group_name, y_label) {
  data %>%
    filter(group_var == group_name) %>%
    mutate(
      listing_year = factor(listing_year),
      group_level = str_wrap(group_level, width = 15)
    ) %>%
    ggplot(aes(
      x = median,
      y = group_level,
      color = listing_year
    )) +
    geom_pointrange(
      aes(xmin = q25, xmax = q75),
      position = position_dodge(width = 0.5),
      size = 0.4
    ) +
    scale_x_continuous(breaks = seq(0, 1, 0.2), limits = c(0, 1)) +
    facet_wrap(vars(hhi_var), scales = "free_y") +
    guides(color = guide_legend(reverse = TRUE)) +
    theme_minimal_vgrid(font_family = font, font_size = 16) +
    theme(
      strip.background = element_rect("grey80"),
      plot.title.position = "plot",
      panel.background = element_rect(fill = 'white', color = NA),
      plot.background = element_rect(fill = 'white', color = NA)
    ) +
    scale_color_viridis_d() +
    panel_border() +
    labs(
      x = 'HHI (median with IQR)',
      y = y_label,
      color = 'Listing Year',
      subtitle = 'Higher number indicates greater concentration'
    )
}

hhi_plot(hhi, "powertrain", "Powertrain")
hhi_plot(hhi, "vehicle_type", "Vehicle Type")
hhi_plot(hhi, "price_bin", "Price Bin")
