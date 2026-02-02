# Estimated annual VMT by powertrain and vehicle type

Estimated annual vehicle miles traveled for each combination of
powertrain and vehicle type. Computed by fitting OLS regressions of
total odometer miles on vehicle age (in years) for used vehicle
listings; the slope coefficient represents the estimated annual VMT.

## Usage

``` r
data(vmt_annual_type)
```

## Format

A data frame with 31 rows and 3 variables:

|                |                                                                                                                                                   |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| Variable       | Description                                                                                                                                       |
| `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"                                                                                            |
| `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)" |
| `vmt_annual`   | Estimated annual vehicle miles traveled                                                                                                           |

## Source

Computed from used vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(vmt_annual_type)

head(vmt_annual_type)
#>   vehicle_type             powertrain vmt_annual
#> 1          Car Battery Electric (BEV)   6311.074
#> 2          CUV Battery Electric (BEV)   9254.098
#> 3          Car               Gasoline   9455.110
#> 4          SUV Battery Electric (BEV)   6173.904
#> 5          CUV               Gasoline  10826.925
#> 6      Minivan               Gasoline  10401.421
```
