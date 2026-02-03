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
#>               powertrain vehicle_type vmt_annual
#> 1 Battery Electric (BEV)          CUV   9254.098
#> 2 Battery Electric (BEV)          Car   6311.074
#> 3 Battery Electric (BEV)      Minivan   5675.074
#> 4 Battery Electric (BEV)       Pickup   8346.890
#> 5 Battery Electric (BEV)          SUV   6173.904
#> 6                 Diesel          CUV  10350.614
```
