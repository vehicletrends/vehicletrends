# Load functions, libraries, and other settings
source(here::here("code", "0-setup.R"))

ds <- load_ds() |>
  filter(age_years >= 2 & age_years <= 9) |>
  filter(inventory_type == 'used') %>%
  select(make, model, vehicle_type, powertrain, miles, age_years)

# Mileage by vehicle type and powertrain ----

get_annual_mileage_powertrain <- function(row) {
  model <- feols(
    fml = miles ~ age_years,
    data = ds |>
      filter(vehicle_type == row$vehicle_type) |>
      filter(powertrain == row$powertrain) |>
      select(miles, age_years) |>
      collect()
  )

  # Predict retention rates at different ages
  pred_data <- data.frame(age_years = seq(2, 9, 0.5))
  pred_data$mileage_predicted <- predict(model, newdata = pred_data)
  pred_data$vehicle_type <- row$vehicle_type
  pred_data$powertrain <- row$powertrain
  pred_data$coef <- coef(model)["age_years"]

  return(pred_data)
}

# Get all unique combinations of vehicle_type and powertrain
combinations <- ds |>
  distinct(vehicle_type, powertrain) |>
  collect()

# Loop through each row in combinations to get predictions
results <- list()
for (i in 1:nrow(combinations)) {
  results[[i]] <- get_annual_mileage_powertrain(combinations[i, ])
}

mileage <- rbindlist(results)

mileage %>%
  distinct(vehicle_type, powertrain, coef) %>%
  mutate(coef = round(coef))

write_csv(
  mileage,
  here('data', 'mileage_powertrain_type.csv')
)

# Mileage coefficient by make and model ----

get_annual_mileage_make_model <- function(row) {
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

  # Predict retention rates at different ages
  pred_data <- data.frame(
    make = row$make,
    model = row$model,
    vehicle_type = row$vehicle_type,
    powertrain = row$powertrain
  )

  pred_data$coef <- coef(model)["age_years"]

  return(pred_data)
}

# Get all unique combinations of vehicle_type and powertrain
combinations <- ds |>
  distinct(make, model, vehicle_type, powertrain) |>
  collect()

# Loop through each row in combinations to get predictions
results <- list()
for (i in 1:nrow(combinations)) {
  results[[i]] <- get_annual_mileage_make_model(combinations[i, ])
}

mileage <- rbindlist(results)

mileage

write_csv(
  mileage,
  here('data', 'mileage_make_model.csv')
)
