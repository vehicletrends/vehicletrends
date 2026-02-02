# Estimated annual VMT by make and model

Estimated annual vehicle miles traveled for individual vehicle
make/model combinations. Computed by fitting OLS regressions of total
odometer miles on vehicle age (in years) for used vehicle listings; the
slope coefficient represents the estimated annual VMT. Only make/model
combinations with at least 100 listings are included, and results are
filtered to positive annual VMT values only.

## Usage

``` r
data(vmt_annual_model)
```

## Format

A data frame with 548 rows and 5 variables:

|                |                                                                                                                                                   |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| Variable       | Description                                                                                                                                       |
| `make`         | Vehicle manufacturer (e.g., "Toyota", "BMW", "Mercedes-Benz")                                                                                     |
| `model`        | Vehicle model name (e.g., "Camry", "RAV4", "Model 3")                                                                                             |
| `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"                                                                                            |
| `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)" |
| `vmt_annual`   | Estimated annual vehicle miles traveled                                                                                                           |

## Source

Computed from used vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(vmt_annual_model)

head(vmt_annual_model)
#>        make     model vehicle_type                     powertrain vmt_annual
#> 1     Lexus   RX PHEV          CUV Plug-In Hybrid Electric (PHEV)   6403.802
#> 2 Chevrolet   Venture      Minivan                       Gasoline  16719.519
#> 3     Honda  Prologue          CUV         Battery Electric (BEV)   3943.976
#> 4      Ford    Escape          CUV Plug-In Hybrid Electric (PHEV)   7705.681
#> 5     Lexus TX Hybrid          CUV          Hybrid Electric (HEV)   7951.909
#> 6     Mazda      CX-5          CUV                         Diesel  11223.632
```
