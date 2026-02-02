# Daily vehicle miles traveled quantiles

Daily VMT quantiles for used vehicles, computed as total odometer miles
divided by vehicle age in days. Only used vehicles with valid mileage
and age up to 15 years are included. Percentile quantiles from the 1st
through 99th are provided across various groupings of powertrain and
vehicle type.

## Usage

``` r
data(vmt_daily)
```

## Format

A tibble with 5,346 rows and 4 variables:

|                |                                                                                                                                                                                            |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Variable       | Description                                                                                                                                                                                |
| `powertrain`   | Powertrain category: "All", "Gasoline", "Battery Electric (BEV)", "BEV (Tesla)", "BEV (Non-Tesla)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)" |
| `vehicle_type` | Vehicle type: "All", "Car", "CUV", "SUV", "Pickup", "Minivan"                                                                                                                              |
| `quantile`     | Quantile level (1 through 99)                                                                                                                                                              |
| `miles`        | Daily vehicle miles traveled at the given quantile                                                                                                                                         |

## Source

Computed from used vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(vmt_daily)

head(vmt_daily)
#> # A tibble: 6 × 4
#>   powertrain vehicle_type quantile miles
#>   <chr>      <chr>           <dbl> <dbl>
#> 1 All        All                 1  2.74
#> 2 All        All                 2  4.74
#> 3 All        All                 3  6.11
#> 4 All        All                 4  7.26
#> 5 All        All                 5  8.26
#> 6 All        All                 6  9.16
```
