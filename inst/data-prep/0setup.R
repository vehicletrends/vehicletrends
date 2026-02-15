# Load packages
library(tidyverse)
library(rvest)
library(arrow)
library(here)
library(data.table)
library(lubridate)
library(janitor)
library(cowplot)
library(logitr)
library(fixest)
library(parallel)
library(ggtext)
library(ggrepel)
library(dplyr)
library(ggplot2)

path_raw_data <- '/Volumes/SSK SSD/marketcheck/db/clean/db'

# Isochrone travel time threshold (minutes) used for HHI calculations
isochrone_min <- 60 # Also can use 30 or 90

options(arrow.unsafe_metadata = TRUE)
options(dplyr.width = Inf)

set.seed(123)

price_levels <- c(
  "$0-$10k",
  "$10k-$20k",
  "$20k-$30k",
  "$30k-$40k",
  "$40k-$50k",
  "$50k-$60k",
  "$60k-$70k",
  "$70k+"
)

us_states <- c(
  "AK",
  "AL",
  "AR",
  "AZ",
  "CA",
  "CO",
  "CT",
  "DE",
  "FL",
  "GA",
  "HI",
  "IA",
  "ID",
  "IL",
  "IN",
  "KS",
  "KY",
  "LA",
  "MA",
  "MD",
  "ME",
  "MI",
  "MN",
  "MO",
  "MS",
  "MT",
  "NC",
  "ND",
  "NH",
  "NJ",
  "NM",
  "NV",
  "NY",
  "OH",
  "OK",
  "OR",
  "PA",
  "RI",
  "SC",
  "SD",
  "TN",
  "TX",
  "UT",
  "VA",
  "VT",
  "WA",
  "WI",
  "WV",
  "WY",
  "NE"
)

# functions ----

`%notin%` = negate(`%in%`)

raw_data_filters <- function(ds) {
  ds %>%
    filter(listing_year < 2026) %>%
    filter(listing_year >= 2018) %>%
    filter(powertrain != 'cng') %>%
    filter(!vehicle_type %in% c('truck', 'van')) %>%
    filter(state %in% us_states) %>%
    filter(!is.na(latitude)) %>%
    filter(!is.na(longitude)) %>%
    filter(age_years <= 15) %>%

    # dealer_id "2202_2504_1102390" is a very large Tesla store in Illinois
    # Since no other Tesla store sales are recorded in this dataset,
    # we chose to filter out this one store as it accounts for a
    # disproportionate number of PEV listings in IL in 2024:
    # 36,425 listings, or 62.2% of all BEVs in IL in 2024.
    # This can be confirmed by running this:
    # ds %>%
    #   filter(state == 'IL') %>%
    #   filter(listing_year == 2024) %>%
    #   filter(powertrain == 'bev') %>%
    #   count(dealer_id) %>%
    #   collect() %>%
    #   arrange(desc(n)) %>%
    #   mutate(p = n / sum(n))
    filter(dealer_id != "2202_2504_1102390") %>%

    # Recode powertrain variable for "hybrid" and "conventional"
    mutate(
      powertrain = ifelse(
        powertrain == 'hybrid',
        'hev',
        ifelse(
          powertrain == 'conventional',
          'cv',
          powertrain
        )
      ),
    ) %>%
    # Remove odd cases that are likely the result of coding errors in the
    # original raw data (very few of these out of 10s of millions of listings)
    # 1) Remove "new" cars that are more than 3 years old
    filter(!(inventory_type == 'new' & age_days > 365 * 3)) %>%
    # 2) Remove "new" cars with prices that are less than 50% of the msrp
    mutate(
      price_diff = msrp - price,
      price_diff_percent = price_diff / msrp
    ) %>%
    filter(!(inventory_type == 'new' & price_diff_percent > 0.5)) %>%
    # 3) Remove "new" listings of Teslas - Tesla doesn't sell new through
    # dealerships. These are likely coding errors, there aren't many of them
    filter(!(make == 'tesla' & inventory_type == 'new'))
}

load_ds <- function() {
  ds <- open_dataset(here::here('data-local', 'listings.parquet')) %>%
    filter(!is.na(powertrain)) %>%
    filter(!is.na(vehicle_type))
  return(ds)
}

load_ds_prices <- function() {
  load_ds() %>%
    mutate(
      price_bin = case_when(
        price < 10000 ~ "$0-$10k",
        price >= 10000 & price < 20000 ~ "$10k-$20k",
        price >= 20000 & price < 30000 ~ "$20k-$30k",
        price >= 30000 & price < 40000 ~ "$30k-$40k",
        price >= 40000 & price < 50000 ~ "$40k-$50k",
        price >= 50000 & price < 60000 ~ "$50k-$60k",
        price >= 60000 & price < 70000 ~ "$60k-$70k",
        price >= 70000 ~ "$70k+",
        TRUE ~ "Other"
      )
    )
}

get_quantiles_summary <- function(df, var) {
  df %>%
    summarise(
      q25 = quantile({{ var }}, 0.25),
      q50 = quantile({{ var }}, 0.5),
      q75 = quantile({{ var }}, 0.75)
    )
}

get_quantiles_detailed <- function(df, var) {
  df %>%
    summarise(
      var01 = fquantile({{ var }}, 0.01),
      var02 = fquantile({{ var }}, 0.02),
      var03 = fquantile({{ var }}, 0.03),
      var04 = fquantile({{ var }}, 0.04),
      var05 = fquantile({{ var }}, 0.05),
      var06 = fquantile({{ var }}, 0.06),
      var07 = fquantile({{ var }}, 0.07),
      var08 = fquantile({{ var }}, 0.08),
      var09 = fquantile({{ var }}, 0.09),
      var10 = fquantile({{ var }}, 0.10),
      var11 = fquantile({{ var }}, 0.11),
      var12 = fquantile({{ var }}, 0.12),
      var13 = fquantile({{ var }}, 0.13),
      var14 = fquantile({{ var }}, 0.14),
      var15 = fquantile({{ var }}, 0.15),
      var16 = fquantile({{ var }}, 0.16),
      var17 = fquantile({{ var }}, 0.17),
      var18 = fquantile({{ var }}, 0.18),
      var19 = fquantile({{ var }}, 0.19),
      var20 = fquantile({{ var }}, 0.20),
      var21 = fquantile({{ var }}, 0.21),
      var22 = fquantile({{ var }}, 0.22),
      var23 = fquantile({{ var }}, 0.23),
      var24 = fquantile({{ var }}, 0.24),
      var25 = fquantile({{ var }}, 0.25),
      var26 = fquantile({{ var }}, 0.26),
      var27 = fquantile({{ var }}, 0.27),
      var28 = fquantile({{ var }}, 0.28),
      var29 = fquantile({{ var }}, 0.29),
      var30 = fquantile({{ var }}, 0.30),
      var31 = fquantile({{ var }}, 0.31),
      var32 = fquantile({{ var }}, 0.32),
      var33 = fquantile({{ var }}, 0.33),
      var34 = fquantile({{ var }}, 0.34),
      var35 = fquantile({{ var }}, 0.35),
      var36 = fquantile({{ var }}, 0.36),
      var37 = fquantile({{ var }}, 0.37),
      var38 = fquantile({{ var }}, 0.38),
      var39 = fquantile({{ var }}, 0.39),
      var40 = fquantile({{ var }}, 0.40),
      var41 = fquantile({{ var }}, 0.41),
      var42 = fquantile({{ var }}, 0.42),
      var43 = fquantile({{ var }}, 0.43),
      var44 = fquantile({{ var }}, 0.44),
      var45 = fquantile({{ var }}, 0.45),
      var46 = fquantile({{ var }}, 0.46),
      var47 = fquantile({{ var }}, 0.47),
      var48 = fquantile({{ var }}, 0.48),
      var49 = fquantile({{ var }}, 0.49),
      var50 = fquantile({{ var }}, 0.50),
      var51 = fquantile({{ var }}, 0.51),
      var52 = fquantile({{ var }}, 0.52),
      var53 = fquantile({{ var }}, 0.53),
      var54 = fquantile({{ var }}, 0.54),
      var55 = fquantile({{ var }}, 0.55),
      var56 = fquantile({{ var }}, 0.56),
      var57 = fquantile({{ var }}, 0.57),
      var58 = fquantile({{ var }}, 0.58),
      var59 = fquantile({{ var }}, 0.59),
      var60 = fquantile({{ var }}, 0.60),
      var61 = fquantile({{ var }}, 0.61),
      var62 = fquantile({{ var }}, 0.62),
      var63 = fquantile({{ var }}, 0.63),
      var64 = fquantile({{ var }}, 0.64),
      var65 = fquantile({{ var }}, 0.65),
      var66 = fquantile({{ var }}, 0.66),
      var67 = fquantile({{ var }}, 0.67),
      var68 = fquantile({{ var }}, 0.68),
      var69 = fquantile({{ var }}, 0.69),
      var70 = fquantile({{ var }}, 0.70),
      var71 = fquantile({{ var }}, 0.71),
      var72 = fquantile({{ var }}, 0.72),
      var73 = fquantile({{ var }}, 0.73),
      var74 = fquantile({{ var }}, 0.74),
      var75 = fquantile({{ var }}, 0.75),
      var76 = fquantile({{ var }}, 0.76),
      var77 = fquantile({{ var }}, 0.77),
      var78 = fquantile({{ var }}, 0.78),
      var79 = fquantile({{ var }}, 0.79),
      var80 = fquantile({{ var }}, 0.80),
      var81 = fquantile({{ var }}, 0.81),
      var82 = fquantile({{ var }}, 0.82),
      var83 = fquantile({{ var }}, 0.83),
      var84 = fquantile({{ var }}, 0.84),
      var85 = fquantile({{ var }}, 0.85),
      var86 = fquantile({{ var }}, 0.86),
      var87 = fquantile({{ var }}, 0.87),
      var88 = fquantile({{ var }}, 0.88),
      var89 = fquantile({{ var }}, 0.89),
      var90 = fquantile({{ var }}, 0.90),
      var91 = fquantile({{ var }}, 0.91),
      var92 = fquantile({{ var }}, 0.92),
      var93 = fquantile({{ var }}, 0.93),
      var94 = fquantile({{ var }}, 0.94),
      var95 = fquantile({{ var }}, 0.95),
      var96 = fquantile({{ var }}, 0.96),
      var97 = fquantile({{ var }}, 0.97),
      var98 = fquantile({{ var }}, 0.98),
      var99 = fquantile({{ var }}, 0.99)
    ) %>%
    pivot_longer(
      names_to = 'quantile',
      values_to = 'val',
      cols = starts_with('var')
    ) %>%
    separate(quantile, into = c('drop', 'quantile'), sep = 'var') %>%
    select(-drop) %>%
    mutate(quantile = as.numeric(quantile))
}

# Format powertrain and vehicle_type labels for display
format_labels <- function(df) {
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
  df %>%
    mutate(
      powertrain = powertrain_labels[powertrain],
      vehicle_type = vehicle_type_labels[vehicle_type]
    )
}

# Format make names for display
format_make <- function(make) {
  # Lookup table for special cases
  make_labels <- c(
    "alfa romeo" = "Alfa Romeo",
    "bmw" = "BMW",
    "gmc" = "GMC",
    "land rover" = "Land Rover",
    "mercedes-benz" = "Mercedes-Benz",
    "mini" = "MINI",
    "ram" = "RAM"
  )

  # Use lookup if exists, otherwise title case
  ifelse(
    make %in% names(make_labels),
    make_labels[make],
    str_to_title(make)
  )
}

# Format model names for display
format_model <- function(model) {
  # Special full-model replacements
  model_labels <- c(
    "ev9" = "EV9",
    "bz4x" = "bZ4X",
    "i-miev" = "i-MiEV",
    "id.4" = "ID.4",
    "rav4" = "RAV4"
  )

  # Check for exact matches first
  if (model %in% names(model_labels)) {
    return(model_labels[model])
  }

  # Start with the original model
  result <- model

  # Apply title case as base
  result <- str_to_title(result)

  # Fix powertrain suffixes (case-insensitive replacement)
  result <- str_replace(result, "(?i)\\bev\\b", "EV")
  result <- str_replace(result, "(?i)\\bbev\\b", "BEV")
  result <- str_replace(result, "(?i)\\bphev\\b", "PHEV")
  result <- str_replace(result, "(?i)\\bhev\\b", "HEV")
  result <- str_replace(result, "(?i)\\bfcev\\b", "FCEV")

  # Fix class names (S-Class, C-Class, etc.)
  result <- str_replace(result, "(?i)-class\\b", "-Class")

  # Fix short letter codes at start (2-3 uppercase letters before space/hyphen/number)
  # Examples: RX, TX, NX, GLE, GLK, etc.
  result <- str_replace(result, "^([A-Za-z]{2,3})(?=[ -]|$)", function(x) {
    toupper(x)
  })

  # Fix Mazda CX- models
  result <- str_replace(result, "(?i)^cx-", "CX-")

  # Fix Audi/Mercedes letter-number combos (A4, Q5, S5, E350, etc.)
  result <- str_replace(result, "^([A-Za-z])([0-9])", function(x) toupper(x))

  # Fix BMW i-series (should be lowercase i)
  result <- str_replace(result, "^I([0-9x])", "i\\1")

  # Fix e-tron (Audi styling)
  result <- str_replace(result, "(?i)\\be-tron\\b", "e-tron")
  result <- str_replace(result, "(?i)\\bE-Tron\\b", "e-tron")

  # Fix "Plug-in" to "Plug-In"
  result <- str_replace(result, "(?i)plug-in", "Plug-In")

  # Fix number series (3 Series, 5 Series)
  result <- str_replace(result, "(?i)\\bseries\\b", "Series")

  # Fix common model name capitalizations
  result <- str_replace(result, "(?i)\\bsuv\\b", "SUV")
  result <- str_replace(result, "(?i)\\bxl\\b", "XL")
  result <- str_replace(result, "(?i)\\bxd\\b", "XD")
  result <- str_replace(result, "(?i)\\bhd\\b", "HD")
  result <- str_replace(result, "(?i)\\bld\\b", "LD")
  result <- str_replace(result, "(?i)\\besv\\b", "ESV")
  result <- str_replace(result, "(?i)\\beqs\\b", "EQS")
  result <- str_replace(result, "(?i)\\beqe\\b", "EQE")
  result <- str_replace(result, "(?i)\\beqb\\b", "EQB")
  result <- str_replace(result, "(?i)\\b4xe\\b", "4xe")
  result <- str_replace(result, "(?i)\\b4-door\\b", "4-Door")
  result <- str_replace(result, "(?i)\\b2-door\\b", "2-Door")
  result <- str_replace(result, "(?i)\\blr4\\b", "LR4")
  result <- str_replace(result, "(?i)\\beuv\\b", "EUV")

  return(result)
}

# Vectorized version for use in mutate
format_model_vec <- function(models) {
  sapply(models, format_model, USE.NAMES = FALSE)
}

select_bev_tesla <- function(df) {
  df %>%
    filter(powertrain == "bev") %>%
    mutate(powertrain = ifelse(tesla == 1, 'bev_tesla', 'bev_non_tesla'))
}

make_dealer_dict <- function() {
  load_ds() %>%
    distinct(dealer_id, state, latitude, longitude) %>%
    collect()
}

get_coords_dealer <- function() {
  make_dealer_dict() %>%
    select(dealer_id, lat_d = latitude, lng_d = longitude) %>%
    distinct() %>%
    as.data.table()
}

get_coords_tract <- function() {
  return(read_csv(here::here('data-raw', 'tract_centroids.csv')))
}

#caculate linear distance using lat and lng
linear_dist <- function(lat1, lon1, lat2, lon2) {
  R <- 6371 # Earth's radius in kilometers
  # Convert degrees to radians
  lat1 <- lat1 * pi / 180
  lon1 <- lon1 * pi / 180
  lat2 <- lat2 * pi / 180
  lon2 <- lon2 * pi / 180

  # Haversine formula
  dlat <- lat2 - lat1
  dlon <- lon2 - lon1
  a <- sin(dlat / 2)^2 + cos(lat1) * cos(lat2) * sin(dlon / 2)^2
  c <- 2 * atan2(sqrt(a), sqrt(1 - a))
  # Distance in kilometers
  return(R * c) # Distance in kilometers
}

make_dir <- function(dir) {
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
}
