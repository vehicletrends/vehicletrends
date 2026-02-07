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
#>         make  model                     powertrain vehicle_type vmt_annual
#> 1      Acura    MDX                       Gasoline          CUV  11334.421
#> 2      Acura    RDX                       Gasoline          CUV  10640.250
#> 3      Acura     TL                       Gasoline          Car   8155.315
#> 4      Acura    TLX                       Gasoline          Car  11107.978
#> 5 Alfa Romeo Tonale Plug-In Hybrid Electric (PHEV)          CUV   7538.852
#> 6       Audi     A3                         Diesel          Car   8582.209
```
