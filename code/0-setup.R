# Load packages
library(tidyverse)
library(arrow)
library(here)
library(data.table)
library(lubridate)
library(janitor)
library(cowplot)
library(logitr)
library(fixest)
library(osrm)
library(parallel)
library(ggtext)
library(ggrepel)
library(dplyr)
library(ggplot2)

path_raw_data <- '/Volumes/SSK SSD/marketcheck/db/clean/db'

options(arrow.unsafe_metadata = TRUE)
options(dplyr.width = Inf)

set.seed(123)

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
    filter(listing_year < 2025) %>%
    filter(listing_year >= 2018) %>%
    filter(!powertrain %in% c('cng', 'fcev')) %>%
    filter(!vehicle_type %in% c('truck', 'van')) %>%
    filter(state %in% us_states) %>%
    filter(!is.na(latitude)) %>%
    filter(!is.na(longitude)) %>%

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
    # Merge together flex and cv powertrains
    mutate(
      powertrain = ifelse(powertrain == 'flex', 'cv', powertrain)
    ) %>%
    # filter(vehicle_type %in% c('car', 'suv')) %>%
    # filter(powertrain %in% c('cv', 'hev', 'phev', 'bev')) %>%
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
  ds <- open_dataset(here::here('data_local', 'listings.parquet')) %>%
    filter(listing_year < 2025) %>%
    filter(!is.na(powertrain)) %>%
    filter(!is.na(vehicle_type))
  return(ds)
}

get_quantiles_detailed <- function(df, var) {
  result <- df %>%
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
  return(result)
}

clean_factors_powertrain <- function(ds) {
    ds %>%
        mutate(
            powertrain = factor(
                powertrain,
                levels = c("cv", "flex", "hev", "phev", "bev"),
                labels = c("Conventional", "Flex-fuel", "Hybrid", "PHEV", "BEV")
            )
        )
}

clean_factors_vehicle_type <- function(ds) {
    ds %>%
        mutate(
            vehicle_type = factor(
                vehicle_type,
                levels = c("car", "cuv", "suv", "pickup", "minivan"),
                labels = c("Car", "CUV", "SUV", "Pickup", "Minivan")
            )
        )
}

