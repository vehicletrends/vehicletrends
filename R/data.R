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

#' Share of listings by variable pairs and singular variables
#'
#' Share of vehicle listings for combinations of grouping variables, computed
#' across all listing years and inventory types. Includes six pairwise
#' combinations (powertrain by vehicle type, powertrain by price bin, vehicle
#' type by powertrain, vehicle type by price bin, price bin by powertrain, and
#' price bin by vehicle type) plus three singular time trends for powertrain,
#' vehicle type, and price bin individually.
#'
#' @format A tibble with 8 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `listing_year`   | Year of the vehicle listing (2018--2024)
#' `inventory_type`  | Inventory type: "New" or "Used"
#' `group_var`      | Name of the grouping variable: "powertrain", "vehicle_type", or "price_bin"
#' `group_level`    | Level of the grouping variable (e.g., "Gasoline", "Car", "$30k-$40k")
#' `category_var`   | Name of the category variable: "powertrain", "vehicle_type", or "price_bin"; `NA` for singular time trends
#' `category_level` | Level of the category variable; `NA` for singular time trends
#' `n`              | Number of listings in this group-category combination
#' `p`              | Proportion of listings within the group (sums to 1 within each listing year, inventory type, and group level)
#'
#' @docType data
#'
#' @usage data(percent_listings)
#'
#' @keywords datasets
#'
#' @source Computed from vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(percent_listings)
#'
#' head(percent_listings)
"percent_listings"

#' Estimated annual depreciation rate by powertrain and vehicle type
#'
#' Estimated annual depreciation rate for each combination of powertrain
#' and vehicle type. Computed by fitting log-linear regressions of retention
#' rate (price / MSRP) on vehicle age (in years) for used vehicle listings;
#' the annual depreciation rate is \code{1 - exp(b)} where \code{b} is the
#' age coefficient. Only used vehicles aged 1--10 years with valid price and
#' MSRP values are included.
#'
#' @format A data frame with 3 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `dep_annual`   | Estimated annual depreciation rate (proportion, 0--1)
#'
#' @docType data
#'
#' @usage data(dep_annual_type)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(dep_annual_type)
#'
#' head(dep_annual_type)
"dep_annual_type"

#' Estimated annual depreciation rate by make and model
#'
#' Estimated annual depreciation rate for individual vehicle make/model
#' combinations. Computed by fitting log-linear regressions of retention
#' rate (price / MSRP) on vehicle age (in years) for used vehicle listings;
#' the annual depreciation rate is \code{1 - exp(b)} where \code{b} is the
#' age coefficient. Only used vehicles aged 1--10 years with valid price and
#' MSRP values are included. Only make/model combinations with at least 100
#' listings are included, and results are filtered to positive depreciation
#' rates only.
#'
#' @format A data frame with 5 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `make`         | Vehicle manufacturer (e.g., "Toyota", "BMW", "Mercedes-Benz")
#' `model`        | Vehicle model name (e.g., "Camry", "RAV4", "Model 3")
#' `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"
#' `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)"
#' `dep_annual`   | Estimated annual depreciation rate (proportion, 0--1)
#'
#' @docType data
#'
#' @usage data(dep_annual_model)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(dep_annual_model)
#'
#' head(dep_annual_model)
"dep_annual_model"

#' Herfindahl-Hirschman Index (HHI) summary statistics across local markets
#'
#' Summary statistics of the Herfindahl-Hirschman Index (HHI) across US census
#' tracts, measuring market concentration for different vehicle market
#' dimensions. HHI values are computed per census tract based on dealers
#' reachable within a 60-minute drive time isochrone, then summarized across
#' tracts. Higher HHI values indicate greater market concentration (less
#' diversity). Nine grouping-variable combinations are included: for each
#' grouping variable (powertrain, vehicle type, price bin), HHI is computed
#' over the other three variables (make, and the two remaining grouping
#' variables).
#'
#' Census-tract-level HHI values (before summarization) are available as
#' parquet files:
#' \url{https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_pb_60.parquet},
#' \url{https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_pt_60.parquet},
#' \url{https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_vt_60.parquet}.
#'
#' @format A tibble with 11 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `group_var`    | Grouping variable: "powertrain", "vehicle_type", or "price_bin"
#' `group_level`  | Level of the grouping variable (e.g., "Gasoline", "Car", "$30k-$40k")
#' `hhi_var`      | Variable over which HHI is computed: "make", "powertrain", "vehicle_type", or "price_bin"
#' `listing_year` | Year of the vehicle listing
#' `mean`         | Mean HHI across census tracts
#' `median`       | Median HHI across census tracts
#' `q25`          | 25th percentile HHI across census tracts
#' `q75`          | 75th percentile HHI across census tracts
#' `IQR`          | Interquartile range of HHI across census tracts
#' `upper`        | Upper whisker bound (q75 + 1.5 * IQR)
#' `lower`        | Lower whisker bound (q25 - 1.5 * IQR)
#'
#' @docType data
#'
#' @usage data(hhi_local_summary)
#'
#' @keywords datasets
#'
#' @source Computed from vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(hhi_local_summary)
#'
#' head(hhi_local_summary)
"hhi_local_summary"

#' Local market share summary statistics across local markets
#'
#' Summary statistics of the share of vehicle listings (`p`) across US census
#' tracts, measuring the distribution of local market shares for different
#' vehicle market segments. Values are computed per census tract based on
#' dealers reachable within a 60-minute drive time isochrone, then summarized
#' across tracts. Three grouping variables are included: powertrain, vehicle
#' type, and price bin, each crossed with inventory type and listing year.
#'
#' Census-tract-level values (before summarization) are available as
#' parquet files:
#' \url{https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_pb_60.parquet},
#' \url{https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_pt_60.parquet},
#' \url{https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_vt_60.parquet}.
#'
#' @format A tibble with 11 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `group_var`      | Grouping variable: "powertrain", "vehicle_type", or "price_bin"
#' `group_level`    | Level of the grouping variable (e.g., "Gasoline", "Car", "$30k-$40k")
#' `inventory_type` | Inventory type: "New" or "Used"
#' `listing_year`   | Year of the vehicle listing
#' `mean`           | Mean local market share across census tracts
#' `median`         | Median local market share across census tracts
#' `q25`            | 25th percentile local market share across census tracts
#' `q75`            | 75th percentile local market share across census tracts
#' `IQR`            | Interquartile range of local market share across census tracts
#' `upper`          | Upper whisker bound (q75 + 1.5 * IQR)
#' `lower`          | Lower whisker bound (q25 - 1.5 * IQR)
#'
#' @docType data
#'
#' @usage data(p_local_summary)
#'
#' @keywords datasets
#'
#' @source Computed from vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(p_local_summary)
#'
#' head(p_local_summary)
"p_local_summary"

#' Percentage of dealers with at least one listing by variable pairs
#'
#' Percentage of dealers that have at least one listing for each combination of
#' two grouping variables, computed across all listing years and inventory types.
#' Three variable-pair combinations are included: powertrain by vehicle type,
#' powertrain by price bin, and vehicle type by price bin.
#'
#' @format A data frame with 7 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `listing_year`   | Year of the vehicle listing (2018--2024)
#' `inventory_type`  | Inventory type: "New" or "Used"
#' `group_var`      | Name of the grouping variable: "powertrain", "vehicle_type", or "price_bin"
#' `group_level`    | Level of the grouping variable (e.g., "Gasoline", "Car", "$30k-$40k")
#' `category_var`   | Name of the category variable: "powertrain", "vehicle_type", or "price_bin"
#' `category_level` | Level of the category variable
#' `p`              | Proportion of dealers with at least one listing in this group-category combination
#'
#' @docType data
#'
#' @usage data(percent_dealers)
#'
#' @keywords datasets
#'
#' @source Computed from vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(percent_dealers)
#'
#' head(percent_dealers)
"percent_dealers"

#' Price trends for new vehicle listings by state, year, and vehicle type
#'
#' Average prices and listing counts for new vehicle inventory by listing year,
#' state, model year, and vehicle type. Includes the number of unique
#' make-model-year combinations available in each state.
#'
#' @format A tibble with 7 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `listing_year`       | Calendar year when listing was scraped (2018--2025)
#' `state`              | US state abbreviation (e.g., "CA", "TX", "NY")
#' `year`               | Model year of the vehicle
#' `vehicle_type`       | Vehicle type: "car", "cuv", "suv", "pickup", "minivan"
#' `avg_price`          | Average listing price (USD)
#' `n_listings`         | Number of listings
#' `n_make_model_year`  | Number of unique make-model-year combinations in this state
#'
#' @docType data
#'
#' @usage data(price_trends_new)
#'
#' @keywords datasets
#'
#' @source Computed from new vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(price_trends_new)
#'
#' head(price_trends_new)
"price_trends_new"

#' Price trends for used vehicle listings by state, year, and vehicle type
#'
#' Average prices, listing counts, and depreciation rates for used vehicle
#' inventory by listing year, state, model year, and vehicle type. Includes
#' annual depreciation rates calculated using exponential decay modeling on
#' retention rates (price/MSRP) and the number of unique make-model-year
#' combinations available in each state.
#'
#' @format A tibble with 8 variables:
#'
#' Variable | Description
#' -------- | -------------------------------------------
#' `listing_year`       | Calendar year when listing was scraped (2018--2025)
#' `state`              | US state abbreviation (e.g., "CA", "TX", "NY")
#' `year`               | Model year of the vehicle
#' `vehicle_type`       | Vehicle type: "car", "cuv", "suv", "pickup", "minivan"
#' `avg_price`          | Average listing price (USD)
#' `n_listings`         | Number of listings
#' `dep_annual_rate`    | Annual depreciation rate (proportion, 0--1) for this state and listing year
#' `n_make_model_year`  | Number of unique make-model-year combinations in this state
#'
#' @docType data
#'
#' @usage data(price_trends_used)
#'
#' @keywords datasets
#'
#' @source Computed from used vehicle listings data from
#' \href{https://www.marketcheck.com/}{Marketcheck}.
#'
#' @examples
#' data(price_trends_used)
#'
#' head(price_trends_used)
"price_trends_used"
