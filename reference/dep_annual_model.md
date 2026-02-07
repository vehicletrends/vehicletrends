# Estimated annual depreciation rate by make and model

Estimated annual depreciation rate for individual vehicle make/model
combinations. Computed by fitting log-linear regressions of retention
rate (price / MSRP) on vehicle age (in years) for used vehicle listings;
the annual depreciation rate is `1 - exp(b)` where `b` is the age
coefficient. Only used vehicles aged 1–10 years with valid price and
MSRP values are included. Only make/model combinations with at least 100
listings are included, and results are filtered to positive depreciation
rates only.

## Usage

``` r
data(dep_annual_model)
```

## Format

A data frame with 5 variables:

|                |                                                                                                                                                   |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| Variable       | Description                                                                                                                                       |
| `make`         | Vehicle manufacturer (e.g., "Toyota", "BMW", "Mercedes-Benz")                                                                                     |
| `model`        | Vehicle model name (e.g., "Camry", "RAV4", "Model 3")                                                                                             |
| `vehicle_type` | Vehicle type: "Car", "CUV", "SUV", "Pickup", "Minivan"                                                                                            |
| `powertrain`   | Powertrain category: "Gasoline", "Battery Electric (BEV)", "Hybrid Electric (HEV)", "Plug-In Hybrid Electric (PHEV)", "Diesel", "Flex Fuel (E85)" |
| `dep_annual`   | Estimated annual depreciation rate (proportion, 0–1)                                                                                              |

## Source

Computed from used vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(dep_annual_model)

head(dep_annual_model)
#>    make model      powertrain vehicle_type dep_annual
#> 1 Acura   MDX        Gasoline          CUV 0.11083871
#> 2 Acura   RDX        Gasoline          CUV 0.09383736
#> 3 Acura    TL        Gasoline          Car 0.07885553
#> 4 Acura   TLX        Gasoline          Car 0.07452962
#> 5  Audi    A4 Flex Fuel (E85)          Car 0.07030819
#> 6  Audi    A4        Gasoline          Car 0.09650968
```
