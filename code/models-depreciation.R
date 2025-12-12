# Load functions, libraries, and other settings
source(here::here("code", "0-setup.R"))

# Basic exponential decline model: r = a*exp(b1*x1 + b2*x2)
# where
#   r = Retention rate
#   a = Intercept
#   x1, x2 = Covariates (e.g. age, miles, etc.)
#   b1, b2 = Covariate coefficients
#
# Log transformation: ln(r) = ln(a) + b1*x1 + b2*x2
#
# To convert log-space estimated coefficients back to original model:
# a = exp(int)

ds <- load_ds() |>
  filter(age_years >= 1 & age_years <= 8) |>
  filter(inventory_type == 'used') %>%
  filter(!is.na(price), !is.na(msrp)) %>%
  # Compute RR for all vehicles
  mutate(rr = price / msrp) %>%
  # Some outliers have greater than 1 RRs
  filter(rr < 1) %>%
  select(make, model, vehicle_type, powertrain, rr, age_years)

# Mileage coefficient by vehicle type and powertrain ----

# Function to get age coefficient for vehicle type and powertrain
get_dep_predictions <- function(vt, pt) {
  model <- feols(
    fml = log(rr) ~ age_years,
    data = ds |>
      filter(vehicle_type == vt) |>
      filter(powertrain == pt) |>
      select(rr, age_years) |>
      collect()
  )

  # Predict retention rates at different ages
  pred_data <- data.frame(age_years = seq(1, 5, 0.5))
  pred_data$rr_predicted <- exp(predict(model, newdata = pred_data))
  pred_data$vehicle_type <- vt
  pred_data$powertrain <- pt

  return(pred_data)
}

# Get all unique combinations of vehicle_type and powertrain
combinations <- ds |>
  distinct(vehicle_type, powertrain) |>
  collect()

# Loop through each row in combinations
results <- list()
for (i in 1:nrow(combinations)) {
  results[[i]] <- get_dep_predictions(
    combinations$vehicle_type[i],
    combinations$powertrain[i]
  )
}
dep_powertrain_type <- rbindlist(results)

dep_powertrain_type

write_csv(
  dep_powertrain_type,
  here('data', 'depreciation_powertrain_type.csv')
)

# Mileage coefficient by make and model ----

get_dep_predictions_make_model <- function(row) {
  model <- feols(
    fml = log(rr) ~ age_years,
    data = ds |>
      filter(make == row$make) |>
      filter(model == row$model) |>
      filter(powertrain == row$powertrain) |>
      filter(vehicle_type == row$vehicle_type) |>
      select(rr, age_years) |>
      collect()
  )

  # Predict retention rates at different ages
  pred_data <- data.frame(age_years = seq(1, 5, 0.5))
  pred_data$rr_predicted <- exp(predict(model, newdata = pred_data))
  pred_data$make <- row$make
  pred_data$model <- row$model
  pred_data$powertrain <- row$powertrain
  pred_data$vehicle_type <- row$vehicle_type

  return(pred_data)
}

# Get all unique combinations of make and model
combinations_make_model <- ds |>
  distinct(make, model, powertrain, vehicle_type) |>
  collect()

# Loop through each row in combinations
results <- list()
for (i in 1:nrow(combinations_make_model)) {
  results[[i]] <- get_dep_predictions_make_model(
    combinations_make_model[i, ]
  )
}
dep_pred_make_model <- rbindlist(results)

dep_pred_make_model

write_csv(
  dep_pred_make_model,
  here('data', 'depreciation_make_model.csv')
)
