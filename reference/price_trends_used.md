# Price trends for used vehicle listings by state, year, and vehicle type

Average prices, listing counts, and depreciation rates for used vehicle
inventory by listing year, state, model year, and vehicle type. Includes
annual depreciation rates calculated using exponential decay modeling on
retention rates (price/MSRP) and the number of unique make-model-year
combinations available in each state.

## Usage

``` r
data(price_trends_used)
```

## Format

A tibble with 8 variables:

|                     |                                                                            |
|---------------------|----------------------------------------------------------------------------|
| Variable            | Description                                                                |
| `listing_year`      | Calendar year when listing was scraped (2018–2025)                         |
| `state`             | US state abbreviation (e.g., "CA", "TX", "NY")                             |
| `year`              | Model year of the vehicle                                                  |
| `vehicle_type`      | Vehicle type: "car", "cuv", "suv", "pickup", "minivan"                     |
| `avg_price`         | Average listing price (USD)                                                |
| `n_listings`        | Number of listings                                                         |
| `dep_annual_rate`   | Annual depreciation rate (proportion, 0–1) for this state and listing year |
| `n_make_model_year` | Number of unique make-model-year combinations in this state                |

## Source

Computed from used vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(price_trends_used)

head(price_trends_used)
#> # A tibble: 6 × 8
#>   listing_year state  year vehicle_type avg_price n_listings dep_annual_rate
#>          <dbl> <chr> <dbl> <chr>            <dbl>      <int>           <dbl>
#> 1         2018 AK     2004 cuv              9563.          8          0.0649
#> 2         2018 AK     2004 pickup          14245.         31          0.0649
#> 3         2018 AK     2004 minivan          9606.          1          0.0649
#> 4         2018 AK     2004 car              9885.          7          0.0649
#> 5         2018 AK     2004 suv             10516.         13          0.0649
#> 6         2018 AK     2005 cuv              9596.         19          0.0649
#> # ℹ 1 more variable: n_make_model_year <int>
```
