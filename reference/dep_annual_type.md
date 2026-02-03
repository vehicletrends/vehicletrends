# Estimated annual depreciation rate by powertrain and vehicle type

Estimated annual depreciation rate for each combination of powertrain
and vehicle type. Computed by fitting log-linear regressions of
retention rate (price / MSRP) on vehicle age (in years) for used vehicle
listings; the annual depreciation rate is `1 - exp(b)` where `b` is the
age coefficient. Only used vehicles aged 1–10 years with valid price and
MSRP values are included.

## Usage

``` r
data(dep_annual_type)
```

## Format

A data frame with 3 variables:

|                |                                                                                                                                                   |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| Variable       | Description                                                                                                                                       |
| `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"                                                                                            |
| `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)" |
| `dep_annual`   | Estimated annual depreciation rate (proportion, 0–1)                                                                                              |

## Source

Computed from used vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(dep_annual_type)

head(dep_annual_type)
#>               powertrain vehicle_type dep_annual
#> 1 Battery Electric (BEV)          CUV 0.09482215
#> 2 Battery Electric (BEV)          Car 0.10086081
#> 3 Battery Electric (BEV)      Minivan 0.05807725
#> 4 Battery Electric (BEV)       Pickup 0.04463694
#> 5 Battery Electric (BEV)          SUV 0.02958732
#> 6        Flex Fuel (E85)          CUV 0.06405950
```
