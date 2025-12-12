source(here::here('code', '0-setup.R'))

# The raw listings are stored on an external drive. Since they are
# under a license agreement, they cannot be made publicly
# available. This script is included in this repository to show
# the calculations made to produce the "data/listings.parquet"
# file that is generated from the raw data. It also produces the
# "data/data_summary.parquet" file that is used to create Table 1

# Open arrow dataset

ds <- open_dataset(path_raw_data) %>%
  raw_data_filters() # Function in '0-setup.R'

# # Number of powertrain-vehicle_type listings
# ds %>%
#   count(powertrain, vehicle_type) %>%
#   collect() %>%
#   arrange(powertrain, vehicle_type) %>%
#   data.frame()

# # Number of make-model combinations for each powertrain-vehicle_type:
# ds %>%
#   count(vehicle_type, powertrain, make, model) %>%
#   count(powertrain, vehicle_type) %>%
#   collect() %>%
#   arrange(powertrain, vehicle_type) %>%
#   data.frame()

# Add other variables

ds <- ds %>%
  mutate(tesla = ifelse(make == 'tesla', 1, 0))

# Merge duplicate dealer_ids based on common state and coordinates
# to form a harmonized dealer_id variable

dealers <- ds %>%
  distinct(state, latitude, longitude) %>%
  collect() %>%
  mutate(dealer_id_clean = row_number())

# Finalize the data

ds <- ds %>%
  left_join(dealers, by = c('state', 'latitude', 'longitude')) %>%
  select(-dealer_id) %>%
  # Select final variables
  select(
    dealer_id = dealer_id_clean,
    vehicle_id,
    inventory_type,
    powertrain,
    vehicle_type,
    year,
    make,
    model,
    msrp,
    price,
    class,
    miles,
    range,
    body_type,
    status_date,
    listing_year,
    state,
    latitude,
    longitude,
    tesla,
    age_years,
    mpg,
    gal100mi,
    kwhp100mi
  )

# Inflation adjust the listing prices and MSRPs

cpi <- read_csv(here::here('data_local', 'inflation-cpi.csv')) %>%
  clean_names() %>%
  pivot_longer(
    names_to = 'month',
    values_to = 'cpi',
    cols = -year
  ) %>%
  # Convert month to number and add a date
  mutate(
    date = mdy(paste(month, '01,', year)),
    month = month(date)
  )

# Adjust to 2024 as reference year
cpi2024 <- cpi %>%
  filter(year == 2024, month == 1) %>%
  pull(cpi)
cpi$cpi <- cpi$cpi / cpi2024
cpi <- cpi %>%
  filter(!is.na(cpi)) %>%
  rename(
    listing_year = year,
    cpi_listing = cpi
  ) %>%
  select(-date)

ds <- ds %>%
  mutate(month = as.integer(month(status_date))) %>%
  # Join CPI factors
  left_join(cpi, by = c('listing_year', 'month')) %>%
  mutate(
    price_raw = price,
    price = price_raw / cpi_listing,
    msrp_raw = msrp,
    msrp = msrp / cpi_listing
  )

# Write the "data/listings.parquet" file
ds %>%
  write_parquet(here::here('data_local', 'listings.parquet'))
