source(here::here("inst", "data-prep", "0setup.R"))

ds <- load_ds()

listings_summary <- ds %>%
  count(inventory_type, powertrain, vehicle_type) %>%
  collect() %>%
  format_labels() %>%
  arrange(inventory_type, powertrain, vehicle_type)

write_csv(
  listings_summary,
  here::here('data-raw', 'listings_summary.csv')
)
