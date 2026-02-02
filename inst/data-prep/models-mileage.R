source(here::here("inst", "data-prep", "0setup.R"))

# Open miles arrow dataset

ds <- load_ds() %>%
  filter(!is.na(miles), !is.na(age_years)) %>%
  filter(inventory_type == 'used') %>%
  filter(miles > 0) %>%
  mutate(age_months = age_years * 12) %>%
  filter(age_months <= 180) %>% # 15 years old cap
  select(make, model, vehicle_type, powertrain, miles, age_years)

# Annual VMT by vehicle type and powertrain ----

get_annual_mileage_type <- function(row) {
  model <- feols(
    fml = miles ~ age_years,
    data = ds |>
      filter(vehicle_type == row$vehicle_type) |>
      filter(powertrain == row$powertrain) |>
      select(miles, age_years) |>
      collect()
  )

  # Store result in data frame
  result <- data.frame(
    vehicle_type = row$vehicle_type,
    powertrain = row$powertrain,
    vmt_annual = coef(model)["age_years"]
  )

  return(result)
}

# Get all unique combinations of vehicle_type and powertrain
combinations <- ds |>
  distinct(vehicle_type, powertrain) |>
  collect()

# Loop through each row in combinations to get predictions
results <- list()
for (i in 1:nrow(combinations)) {
  results[[i]] <- get_annual_mileage_type(combinations[i, ])
}
vmt_annual_type <- rbindlist(results)

# Annual VMT by make and model ----

get_annual_mileage_model <- function(row) {
  model <- feols(
    fml = miles ~ age_years,
    data = ds |>
      filter(make == row$make) |>
      filter(model == row$model) |>
      filter(powertrain == row$powertrain) |>
      filter(vehicle_type == row$vehicle_type) |>
      select(miles, age_years) |>
      collect()
  )

  # Store result in data frame
  result <- data.frame(
    make = row$make,
    model = row$model,
    vehicle_type = row$vehicle_type,
    powertrain = row$powertrain,
    vmt_annual = coef(model)["age_years"]
  )

  return(result)
}

# Get all unique combinations of vehicle_type and powertrain
combinations <- ds |>
  count(make, model, vehicle_type, powertrain) |>
  arrange(n) |>
  filter(n >= 100) |>
  collect()

# Loop through each row in combinations to get predictions
results <- list()
for (i in 1:nrow(combinations)) {
  results[[i]] <- get_annual_mileage_model(combinations[i, ])
}
vmt_annual_model <- rbindlist(results)

vmt_annual_type <- vmt_annual_type %>%
  format_labels() %>%
  select(powertrain, vehicle_type, vmt_annual) %>%
  arrange(powertrain, vehicle_type)

vmt_annual_model <- vmt_annual_model %>%
  format_labels() %>%
  mutate(
    make = format_make(make),
    model = format_model_vec(model)
  ) %>%
  filter(vmt_annual > 0) %>%
  select(make, model, powertrain, vehicle_type, vmt_annual) %>%
  arrange(make, model, powertrain, vehicle_type)

# Save
write_csv(
  vmt_annual_type,
  here::here('data-raw', 'vmt_annual_type.csv')
)
write_csv(
  vmt_annual_model,
  here::here('data-raw', 'vmt_annual_model.csv')
)

# Save the datasets for package
usethis::use_data(vmt_annual_type, overwrite = TRUE)
usethis::use_data(vmt_annual_model, overwrite = TRUE)
