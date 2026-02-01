#' Vehicle depreciation quantiles by age, powertrain, and vehicle type
#'
#' Retention rate (price / MSRP) quantiles for used vehicles, computed at
#' 3-month age bins from vehicle listings data. Only used vehicles with valid
#' price and MSRP values are included, with ages ranging from 12 to 180 months
#' (15 years). Quantiles are provided at the 25th, 50th, and 75th percentiles
#' across various groupings of powertrain and vehicle type.
#'
#' @format A tibble with 6,486 rows and 5 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `age_bin`      | Midpoint of 3-month age bin in months (e.g., 13.5, 16.5, ..., up to 180)
#' `powertrain`   | Powertrain category: "All", "Gasoline", "Battery Electric (BEV)", "BEV (Tesla)", "BEV (Non-Tesla)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `vehicle_type` | Vehicle type: "All", "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `quantile`     | Quantile level (25, 50, or 75)
#' `rr`           | Retention rate (price / MSRP) at the given quantile
#'
#' @docType data
#'
#' @usage data(depreciation)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(depreciation)
#'
#' head(depreciation)
"depreciation"

#' Alternative fuel vehicle registrations by state
#'
#' Annual vehicle registration counts by US state and powertrain type, scraped
#' from the Alternative Fuels Data Center (AFDC) for years 2016 through 2024.
#'
#' @format A tibble with 5,616 rows and 4 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `year`       | Registration year (2016--2024)
#' `state`      | US state name (e.g., "Alabama", "California")
#' `powertrain` | Fuel/powertrain type (e.g., "Battery Electric (BEV)", "Diesel", "Gasoline", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Biodiesel", "Compressed Natural Gas (CNG)", "Ethanol/Flex Fuel (E85)", "Fuel Cell", "Hydrogen", "Methanol", "Propane")
#' `count`      | Number of registered vehicles
#'
#' @docType data
#'
#' @usage data(registrations)
#'
#' @keywords datasets
#'
#' @source Scraped from the
#' \href{https://afdc.energy.gov/vehicle-registration}{Alternative Fuels Data Center (AFDC)}.
#'
#' @examples
#' data(registrations)
#'
#' head(registrations)
"registrations"

#' Total vehicle miles traveled quantiles by age
#'
#' Cumulative odometer mileage quantiles for used vehicles at 3-month age bins,
#' computed from vehicle listings data. Only used vehicles with valid mileage
#' and age up to 15 years (180 months) are included. Quantiles are provided at
#' the 25th, 50th, and 75th percentiles across various groupings of powertrain
#' and vehicle type.
#'
#' @format A tibble with 8,118 rows and 5 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `age_bin`      | Midpoint of 3-month age bin in months (e.g., 1.5, 4.5, ..., up to 180)
#' `powertrain`   | Powertrain category: "All", "Gasoline", "Battery Electric (BEV)", "BEV (Tesla)", "BEV (Non-Tesla)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `vehicle_type` | Vehicle type: "All", "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `quantile`     | Quantile level (25, 50, or 75)
#' `miles`        | Total odometer miles at the given quantile
#'
#' @docType data
#'
#' @usage data(vmt_age)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(vmt_age)
#'
#' head(vmt_age)
"vmt_age"

#' Daily vehicle miles traveled quantiles
#'
#' Daily VMT quantiles for used vehicles, computed as total odometer miles
#' divided by vehicle age in days. Only used vehicles with valid mileage and
#' age up to 15 years are included. Percentile quantiles from the 1st through
#' 99th are provided across various groupings of powertrain and vehicle type.
#'
#' @format A tibble with 5,346 rows and 4 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `powertrain`   | Powertrain category: "All", "Gasoline", "Battery Electric (BEV)", "BEV (Tesla)", "BEV (Non-Tesla)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `vehicle_type` | Vehicle type: "All", "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `quantile`     | Quantile level (1 through 99)
#' `miles`        | Daily vehicle miles traveled at the given quantile
#'
#' @docType data
#'
#' @usage data(vmt_daily)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(vmt_daily)
#'
#' head(vmt_daily)
"vmt_daily"

#' Estimated annual VMT by powertrain and vehicle type
#'
#' Estimated annual vehicle miles traveled for each combination of powertrain
#' and vehicle type. Computed by fitting OLS regressions of total odometer
#' miles on vehicle age (in years) for used vehicle listings; the slope
#' coefficient represents the estimated annual VMT.
#'
#' @format A data frame with 31 rows and 3 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `vmt_annual`   | Estimated annual vehicle miles traveled
#'
#' @docType data
#'
#' @usage data(vmt_annual_type)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(vmt_annual_type)
#'
#' head(vmt_annual_type)
"vmt_annual_type"

#' Estimated annual VMT by powertrain and vehicle type
#'
#' Estimated annual vehicle miles traveled for each combination of powertrain
#' and vehicle type. This is an alternate name for the same data as
#' [vmt_annual_type].
#'
#' @format A data frame with 31 rows and 3 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `vmt_annual`   | Estimated annual vehicle miles traveled
#'
#' @docType data
#'
#' @usage data(vmt_annual_pt_vt)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(vmt_annual_pt_vt)
#'
#' head(vmt_annual_pt_vt)
"vmt_annual_pt_vt"

#' Estimated annual VMT by make and model
#'
#' Estimated annual vehicle miles traveled for individual vehicle make/model
#' combinations. Computed by fitting OLS regressions of total odometer miles on
#' vehicle age (in years) for used vehicle listings; the slope coefficient
#' represents the estimated annual VMT. Only make/model combinations with at
#' least 100 listings are included, and results are filtered to positive annual
#' VMT values only.
#'
#' @format A data frame with 548 rows and 5 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `make`         | Vehicle manufacturer (e.g., "Toyota", "BMW", "Mercedes-Benz")
#' `model`        | Vehicle model name (e.g., "Camry", "RAV4", "Model 3")
#' `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `vmt_annual`   | Estimated annual vehicle miles traveled
#'
#' @docType data
#'
#' @usage data(vmt_annual_model)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(vmt_annual_model)
#'
#' head(vmt_annual_model)
"vmt_annual_model"

#' Estimated annual VMT by make and model
#'
#' Estimated annual vehicle miles traveled for individual vehicle make/model
#' combinations. This is an alternate name for the same data as
#' [vmt_annual_model].
#'
#' @format A data frame with 551 rows and 5 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `make`         | Vehicle manufacturer (e.g., "Toyota", "BMW", "Mercedes-Benz")
#' `model`        | Vehicle model name (e.g., "Camry", "RAV4", "Model 3")
#' `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `vmt_annual`   | Estimated annual vehicle miles traveled
#'
#' @docType data
#'
#' @usage data(vmt_annual_mm)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(vmt_annual_mm)
#'
#' head(vmt_annual_mm)
"vmt_annual_mm"
