source(here::here("inst", "data-prep", "0setup.R"))

ds <- load_ds_prices()

# Compute market share percentages for a pair of grouping variables.
# Returns a long data frame with columns:
#   listing_year, inventory_type, group_var, group_level,
#   category_var, category_level, n, p
get_percent_listings <- function(var1, var2, var1_name, var2_name) {
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

# Compute time trends for singular metrics
# Returns a long data frame with columns:
#   listing_year, inventory_type, group_var, group_level, n, p
get_percent_listings_single <- function(var, var_name) {
  ds %>%
    count(listing_year, inventory_type, {{ var }}) %>%
    collect() %>%
    group_by(listing_year, inventory_type) %>%
    mutate(p = n / sum(n)) %>%
    ungroup() %>%
    rename(group_level = {{ var }}) %>%
    mutate(
      group_var = var_name,
      category_var = NA_character_,
      group_level = as.character(group_level),
      category_level = NA_character_
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

# Build unified dataset from all 6 pairwise combinations + 3 singular metrics
percent_listings <- bind_rows(
  get_percent_listings(
    powertrain,
    vehicle_type,
    "powertrain",
    "vehicle_type"
  ),
  get_percent_listings(
    powertrain,
    price_bin,
    "powertrain",
    "price_bin"
  ),
  get_percent_listings(
    vehicle_type,
    powertrain,
    "vehicle_type",
    "powertrain"
  ),
  get_percent_listings(
    vehicle_type,
    price_bin,
    "vehicle_type",
    "price_bin"
  ),
  get_percent_listings(
    price_bin,
    powertrain,
    "price_bin",
    "powertrain"
  ),
  get_percent_listings(
    price_bin,
    vehicle_type,
    "price_bin",
    "vehicle_type"
  ),
  get_percent_listings_single(
    powertrain,
    "powertrain"
  ),
  get_percent_listings_single(
    vehicle_type,
    "vehicle_type"
  ),
  get_percent_listings_single(
    price_bin,
    "price_bin"
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

percent_listings <- percent_listings %>%
  mutate(
    inventory_type = str_to_title(inventory_type),
    group_level = format_level(group_level, group_var),
    category_level = format_level(category_level, category_var)
  )

# Save
write_csv(percent_listings, here::here('data-raw', 'percent_listings.csv'))
usethis::use_data(percent_listings, overwrite = TRUE)
