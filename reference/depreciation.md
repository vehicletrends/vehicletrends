# Vehicle depreciation quantiles by age, powertrain, and vehicle type

Retention rate (price / MSRP) quantiles for used vehicles, computed at
3-month age bins from vehicle listings data. Only used vehicles with
valid price and MSRP values are included, with ages ranging from 12 to
180 months (15 years). Quantiles are provided at the 25th, 50th, and
75th percentiles across various groupings of powertrain and vehicle
type.

## Usage

``` r
data(depreciation)
```

## Format

A tibble with 6,486 rows and 5 variables:

|                |                                                                                                                                                                                            |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Variable       | Description                                                                                                                                                                                |
| `age_bin`      | Midpoint of 3-month age bin in months (e.g., 13.5, 16.5, ..., up to 180)                                                                                                                   |
| `powertrain`   | Powertrain category: "All", "Gasoline", "Battery Electric (BEV)", "BEV (Tesla)", "BEV (Non-Tesla)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)" |
| `vehicle_type` | Vehicle type: "All", "Car", "CUV", "SUV", "Pickup", "Minivan"                                                                                                                              |
| `quantile`     | Quantile level (25, 50, or 75)                                                                                                                                                             |
| `rr`           | Retention rate (price / MSRP) at the given quantile                                                                                                                                        |

## Source

Computed from used vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(depreciation)

head(depreciation)
#> # A tibble: 6 × 5
#>   age_bin powertrain vehicle_type quantile    rr
#>     <dbl> <chr>      <chr>           <dbl> <dbl>
#> 1    13.5 All        All                25 0.808
#> 2    13.5 All        All                50 0.943
#> 3    13.5 All        All                75 1.09 
#> 4    16.5 All        All                25 0.760
#> 5    16.5 All        All                50 0.901
#> 6    16.5 All        All                75 1.05 
```
