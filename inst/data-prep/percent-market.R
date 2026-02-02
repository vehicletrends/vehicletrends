source(here::here("inst", "data-prep", "0setup.R"))

ds <- load_ds_prices()

# Compute market share percentages for a pair of grouping variables.
# Returns a long data frame with columns:
#   listing_year, inventory_type, group_var, group_level,
#   category_var, category_level, n, p
get_percent_market <- function(var1, var2, var1_name, var2_name) {
  ds %>%
    count(listing_year, inventory_type, {{ var1 }}, {{ var2 }}) %>%
    collect() %>%
    group_by(listing_year, inventory_type, {{ var1 }}) %>%
    mutate(p = n / sum(n)) %>%
    ungroup() %>%
    rename(
      group_level = {{ var1 }},
      category_level = {{ var2 }}
    ) %>%
    mutate(
      group_var = var1_name,
      category_var = var2_name,
      group_level = as.character(group_level),
      category_level = as.character(category_level)
    ) %>%
    select(
      listing_year,
      inventory_type,
      group_var,
      group_level,
      category_var,
      category_level,
      n,
      p
    )
}

# Build unified dataset from all 6 combinations
percent_market <- bind_rows(
  get_percent_market(
    powertrain,
    vehicle_type,
    "powertrain",
    "vehicle_type"
  ),
  get_percent_market(
    powertrain,
    price_bin,
    "powertrain",
    "price_bin"
  ),
  get_percent_market(
    vehicle_type,
    powertrain,
    "vehicle_type",
    "powertrain"
  ),
  get_percent_market(
    vehicle_type,
    price_bin,
    "vehicle_type",
    "price_bin"
  ),
  get_percent_market(
    price_bin,
    powertrain,
    "price_bin",
    "powertrain"
  ),
  get_percent_market(
    price_bin,
    vehicle_type,
    "price_bin",
    "vehicle_type"
  )
)

# Format labels
powertrain_labels <- c(
  "all" = "All",
  "diesel" = "Diesel",
  "cv" = "Gasoline",
  "flex" = "Flex Fuel (E85)",
  "hev" = "Hybrid Electric (HEV)",
  "phev" = "Plug-In Hybrid Electric (PHEV)",
  "bev" = "Battery Electric (BEV)",
  "bev_tesla" = "BEV (Tesla)",
  "bev_non_tesla" = "BEV (Non-Tesla)",
  "fcev" = "Fuel Cell"
)
vehicle_type_labels <- c(
  "all" = "All",
  "car" = "Car",
  "cuv" = "CUV",
  "suv" = "SUV",
  "pickup" = "Pickup",
  "minivan" = "Minivan"
)

format_level <- function(level, var) {
  case_when(
    var == "powertrain" ~ powertrain_labels[level],
    var == "vehicle_type" ~ vehicle_type_labels[level],
    TRUE ~ level
  )
}

percent_market <- percent_market %>%
  mutate(
    inventory_type = str_to_title(inventory_type),
    group_level = format_level(group_level, group_var),
    category_level = format_level(category_level, category_var)
  )

# Save
write_csv(percent_market, here::here('data-raw', 'percent_market.csv'))
usethis::use_data(percent_market, overwrite = TRUE)
