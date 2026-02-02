source(here::here("inst", "data-prep", "0setup.R"))

ds <- load_ds_prices()

# Compute the percentage of dealers that have at least one listing
# for each combination of two grouping variables, broken out by
# listing_year and inventory_type.
get_dealer_percentages <- function(var1, var2, var1_name, var2_name) {
  dealers_all <- ds %>%
    distinct(dealer_id, listing_year, inventory_type) %>%
    count(listing_year, inventory_type, name = "total_dealers")

  ds %>%
    distinct(
      dealer_id,
      listing_year,
      inventory_type,
      {{ var1 }},
      {{ var2 }}
    ) %>%
    count(listing_year, inventory_type, {{ var1 }}, {{ var2 }}) %>%
    left_join(dealers_all, by = c("listing_year", "inventory_type")) %>%
    mutate(p = n / total_dealers) %>%
    select(listing_year, inventory_type, {{ var1 }}, {{ var2 }}, p) %>%
    collect() %>%
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
      p
    )
}

# Build unified dataset from all 3 combinations
percent_dealers <- bind_rows(
  get_dealer_percentages(
    powertrain,
    vehicle_type,
    "powertrain",
    "vehicle_type"
  ),
  get_dealer_percentages(
    powertrain,
    price_bin,
    "powertrain",
    "price_bin"
  ),
  get_dealer_percentages(
    vehicle_type,
    price_bin,
    "vehicle_type",
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

percent_dealers <- percent_dealers %>%
  mutate(
    inventory_type = str_to_title(inventory_type),
    group_level = format_level(group_level, group_var),
    category_level = format_level(category_level, category_var)
  )

# Save
write_csv(percent_dealers, here::here('data-raw', 'percent_dealers.csv'))
usethis::use_data(percent_dealers, overwrite = TRUE)

# Visualize ----

plot_dealer_grid <- function(data, gvar, cvar) {
  data %>%
    filter(group_var == gvar, category_var == cvar) %>%
    ggplot(aes(x = listing_year, y = p, color = inventory_type)) +
    geom_line() +
    facet_grid(group_level ~ category_level) +
    labs(
      x = "Listing Year",
      y = "% of Dealers",
      color = "Inventory Type"
    ) +
    theme_minimal_grid()
}

plot_dealer_grid(percent_dealers, "powertrain", "vehicle_type")
plot_dealer_grid(percent_dealers, "powertrain", "price_bin")
plot_dealer_grid(percent_dealers, "vehicle_type", "price_bin")
