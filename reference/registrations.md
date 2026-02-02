# Alternative fuel vehicle registrations by state

Annual vehicle registration counts by US state and powertrain type,
scraped from the Alternative Fuels Data Center (AFDC) for years 2016
through 2024.

## Usage

``` r
data(registrations)
```

## Format

A tibble with 5,616 rows and 4 variables:

|              |                                                                                                                                                                                                                                                                |
|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Variable     | Description                                                                                                                                                                                                                                                    |
| `year`       | Registration year (2016–2024)                                                                                                                                                                                                                                  |
| `state`      | US state name (e.g., "Alabama", "California")                                                                                                                                                                                                                  |
| `powertrain` | Fuel/powertrain type (e.g., "Battery Electric (BEV)", "Diesel", "Gasoline", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Biodiesel", "Compressed Natural Gas (CNG)", "Ethanol/Flex Fuel (E85)", "Fuel Cell", "Hydrogen", "Methanol", "Propane") |
| `count`      | Number of registered vehicles                                                                                                                                                                                                                                  |

## Source

Scraped from the [Alternative Fuels Data Center
(AFDC)](https://afdc.energy.gov/vehicle-registration).

## Examples

``` r
data(registrations)

head(registrations)
#> # A tibble: 6 × 4
#>    year state   powertrain                    count
#>   <int> <chr>   <chr>                         <dbl>
#> 1  2016 Alabama Battery Electric (BEV)          500
#> 2  2016 Alabama Biodiesel                         0
#> 3  2016 Alabama Compressed Natural Gas (CNG)  20100
#> 4  2016 Alabama Diesel                       126500
#> 5  2016 Alabama Flex Fuel (E85)              428300
#> 6  2016 Alabama Fuel Cell                         0
```
