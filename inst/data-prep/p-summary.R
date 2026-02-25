source(here::here("inst", "data-prep", "0setup.R"))

# Import local market percentage data

p_root <- 'data-local'
iso <- isochrone_min # Global var in 0setup.R
p_pt <- read_parquet(here(p_root, paste0("p_pt_", iso, ".parquet")))
p_vt <- read_parquet(here(p_root, paste0("p_vt_", iso, ".parquet")))
p_pb <- read_parquet(here(p_root, paste0("p_pb_", iso, ".parquet")))

summarise_p <- function(dt, by_cols) {
  dt[,
    .(
      mean = mean(p),
      median = median(p),
      q25 = quantile(p, 0.25),
      q75 = quantile(p, 0.75),
      IQR = IQR(p),
      lower = quantile(p, 0.25) - 1.5 * IQR(p),
      upper = quantile(p, 0.75) + 1.5 * IQR(p)
    ),
    by = by_cols
  ]
}

# Helper to summarise and label one p combination
make_p_summary <- function(dt, group_col) {
  result <- summarise_p(dt, c(group_col, "inventory_type", "listing_year"))
  result[, group_var := group_col]
  setnames(result, group_col, "group_level")
  result[, group_level := as.character(group_level)]
  result
}

# Combine all p summaries into one tidy dataset
p_local <- rbindlist(list(
  make_p_summary(p_pt, "powertrain"),
  make_p_summary(p_vt, "vehicle_type"),
  make_p_summary(p_pb, "price_bin")
))

# Reorder columns
setcolorder(
  p_local,
  c(
    "group_var",
    "group_level",
    "inventory_type",
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
p_local[group_var == "powertrain", group_level := powertrain_labels[group_level]]
p_local[
  group_var == "vehicle_type",
  group_level := vehicle_type_labels[group_level]
]
p_local[, inventory_type := str_to_title(inventory_type)]

# Save CSV to data-raw
write_csv(p_local, here('data-raw', 'p_local.csv'))

# Export as .rda
p_local <- as_tibble(p_local)
usethis::use_data(p_local, overwrite = TRUE)
