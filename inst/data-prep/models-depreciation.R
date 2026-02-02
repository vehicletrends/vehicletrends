source(here::here("inst", "data-prep", "0setup.R"))

# Basic exponential decline model: r = a*exp(b1*x1 + b2*x2)
# where
#   r = Retention rate
#   a = Intercept
#   x1, x2 = Covariates (e.g. age, miles, etc.)
#   b1, b2 = Covariate coefficients
#
# Log transformation: ln(r) = ln(a) + b1*x1 + b2*x2
#
# Annual depreciation rate = 1 - exp(b), where b is the age_years coefficient

ds <- load_ds() |>
  filter(age_years >= 1 & age_years <= 10) |>
  filter(inventory_type == 'used') %>%
  filter(!is.na(price), !is.na(msrp)) %>%
  mutate(rr = price / msrp) %>%
  filter(rr < 1) %>%
  select(make, model, vehicle_type, powertrain, rr, age_years)

# Annual depreciation by vehicle type and powertrain ----

get_dep_annual_type <- function(row) {
  model <- feols(
    fml = log(rr) ~ age_years,
    data = ds |>
      filter(vehicle_type == row$vehicle_type) |>
      filter(powertrain == row$powertrain) |>
      select(rr, age_years) |>
      collect()
  )

  result <- data.frame(
    vehicle_type = row$vehicle_type,
    powertrain = row$powertrain,
    dep_annual = 1 - exp(coef(model)["age_years"])
  )

  return(result)
}

# Get all unique combinations of vehicle_type and powertrain
combinations <- ds |>
  distinct(vehicle_type, powertrain) |>
  collect()

# Loop through each row in combinations to get estimates
results <- list()
for (i in 1:nrow(combinations)) {
  results[[i]] <- get_dep_annual_type(combinations[i, ])
}
dep_annual_type <- rbindlist(results)

# Annual depreciation by make and model ----

get_dep_annual_model <- function(row) {
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

  result <- data.frame(
    make = row$make,
    model = row$model,
    vehicle_type = row$vehicle_type,
    powertrain = row$powertrain,
    dep_annual = 1 - exp(coef(model)["age_years"])
  )

  return(result)
}

# Get all unique combinations of make, model, vehicle_type, and powertrain
combinations <- ds |>
  count(make, model, vehicle_type, powertrain) |>
  arrange(n) |>
  filter(n >= 100) |>
  collect()

# Loop through each row in combinations to get estimates
results <- list()
for (i in 1:nrow(combinations)) {
  results[[i]] <- get_dep_annual_model(combinations[i, ])
}
dep_annual_model <- rbindlist(results)

dep_annual_type <- dep_annual_type %>%
  format_labels() %>%
  select(powertrain, vehicle_type, dep_annual) %>%
  arrange(powertrain, vehicle_type)
dep_annual_model <- dep_annual_model %>%
  format_labels() %>%
  mutate(
    make = format_make(make),
    model = format_model_vec(model)
  ) %>%
  filter(dep_annual > 0) %>%
  select(make, model, powertrain, vehicle_type, dep_annual) %>%
  arrange(make, model, powertrain, vehicle_type)

# Save
write_csv(
  dep_annual_type,
  here::here('data-raw', 'dep_annual_type.csv')
)
write_csv(
  dep_annual_model,
  here::here('data-raw', 'dep_annual_model.csv')
)

# Save the datasets for package
usethis::use_data(dep_annual_type, overwrite = TRUE)
usethis::use_data(dep_annual_model, overwrite = TRUE)
