# Total vehicle miles traveled quantiles by age

Cumulative odometer mileage quantiles for used vehicles at 3-month age
bins, computed from vehicle listings data. Only used vehicles with valid
mileage and age up to 15 years (180 months) are included. Quantiles are
provided at the 25th, 50th, and 75th percentiles across various
groupings of powertrain and vehicle type.

## Usage

``` r
data(vmt_age)
```

## Format

A tibble with 8,118 rows and 5 variables:

|                |                                                                                                                                                                                            |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Variable       | Description                                                                                                                                                                                |
| `age_bin`      | Midpoint of 3-month age bin in months (e.g., 1.5, 4.5, ..., up to 180)                                                                                                                     |
| `powertrain`   | Powertrain category: "All", "Gasoline", "Battery Electric (BEV)", "BEV (Tesla)", "BEV (Non-Tesla)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)" |
| `vehicle_type` | Vehicle type: "All", "Car", "CUV", "SUV", "Pickup", "Minivan"                                                                                                                              |
| `quantile`     | Quantile level (25, 50, or 75)                                                                                                                                                             |
| `miles`        | Total odometer miles at the given quantile                                                                                                                                                 |

## Source

Computed from used vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(vmt_age)

head(vmt_age)
#> # A tibble: 6 × 5
#>   age_bin powertrain vehicle_type quantile   miles
#>     <dbl> <chr>      <chr>           <dbl>   <dbl>
#> 1     1.5 All        All                25    7.49
#> 2     1.5 All        All                50  127.  
#> 3     1.5 All        All                75 1422.  
#> 4     4.5 All        All                25   19.4 
#> 5     4.5 All        All                50  803.  
#> 6     4.5 All        All                75 3162.  
```
