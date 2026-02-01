
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vehicletrends <a href='https://pkg.vehicletrends.us/'><img src='man/figures/logo.png' align="right" style="height:139px;"/></a>

<!-- badges: start -->

<!-- badges: end -->

An R data package containing tidy formatted summary data on vehicle
trends in the United States. The primary data source is vehicle listings
from [marketcheck.com](https://www.marketcheck.com/), which have been
processed into summary statistics including depreciation curves, mileage
accumulation, market concentration, and market share breakdowns.

For a live dashboard of the data, visit
[vehicletrends.us](https://vehicletrends.us).

## Installation

You can install vehicletrends from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("vehicletrends/vehicletrends")
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘/private/var/folders/zb/w3yl7b795td3mx1fpy73kbpw0000gn/T/RtmpL5MTem/remotes5a61673a033a/vehicletrends-vehicletrends-dc6a9a6/DESCRIPTION’ ... OK
#> * preparing ‘vehicletrends’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * building ‘vehicletrends_0.0.1.tar.gz’
```

## Usage

``` r
library(vehicletrends)
```

Once loaded, all datasets are available directly by name. See the
[package documentation site](https://pkg.vehicletrends.us/) for details
on each dataset.

## Datasets

### `depreciation`

Retention rate (price / MSRP) quantiles for used vehicles by age,
powertrain, and vehicle type. A retention rate of 1.0 means 100% value
retention; 0.5 means 50% value loss. Quantiles (25th, 50th, 75th) are
provided at 3-month age intervals up to 15 years.

``` r
head(depreciation)
#>   age_bin powertrain vehicle_type quantile        rr
#> 1    13.5        All          All       25 0.8073291
#> 2    13.5        All          All       50 0.9427215
#> 3    13.5        All          All       75 1.0860465
#> 4    16.5        All          All       25 0.7600114
#> 5    16.5        All          All       50 0.9012899
#> 6    16.5        All          All       75 1.0452036
```

### `registrations`

Annual light-duty vehicle registration counts by US state and powertrain
type, sourced from the [Alternative Fuels Data
Center](https://afdc.energy.gov/vehicle-registration) for years
2016–2024.

``` r
head(registrations)
#>   year   state                   powertrain  count
#> 1 2016 Alabama       Battery Electric (BEV)    500
#> 2 2016 Alabama                    Biodiesel      0
#> 3 2016 Alabama Compressed Natural Gas (CNG)  20100
#> 4 2016 Alabama                       Diesel 126500
#> 5 2016 Alabama              Flex Fuel (E85) 428300
#> 6 2016 Alabama                    Fuel Cell      0
```

### `vmt_age`

Cumulative odometer mileage quantiles (25th, 50th, 75th) for used
vehicles at 3-month age intervals up to 15 years, broken out by
powertrain and vehicle type.

``` r
head(vmt_age)
#>   age_bin powertrain vehicle_type quantile       miles
#> 1     1.5        All          All       25    6.661913
#> 2     1.5        All          All       50  105.955773
#> 3     1.5        All          All       75 1413.149703
#> 4     4.5        All          All       25   16.534734
#> 5     4.5        All          All       50  782.400927
#> 6     4.5        All          All       75 3222.299469
```

### `vmt_daily`

Daily vehicle miles traveled (odometer miles / vehicle age in days)
quantiles from the 1st through 99th percentile, by powertrain and
vehicle type.

``` r
head(vmt_daily)
#>   powertrain vehicle_type quantile    miles
#> 1        All          All        1 2.744988
#> 2        All          All        2 4.737732
#> 3        All          All        3 6.107311
#> 4        All          All        4 7.260857
#> 5        All          All        5 8.264062
#> 6        All          All        6 9.157538
```

### `vmt_annual_type`

Estimated annual VMT for each combination of powertrain and vehicle
type, derived from OLS regressions of odometer miles on vehicle age.

``` r
head(vmt_annual_type)
#>   vehicle_type             powertrain vmt_annual
#> 1          Car Battery Electric (BEV)   6311.074
#> 2          CUV Battery Electric (BEV)   9254.098
#> 3          Car               Gasoline   9455.110
#> 4          SUV Battery Electric (BEV)   6173.904
#> 5          CUV               Gasoline  10826.925
#> 6      Minivan               Gasoline  10401.421
```

### `vmt_annual_model`

Estimated annual VMT for individual make/model combinations (minimum 100
listings), derived from OLS regressions of odometer miles on vehicle
age.

``` r
head(vmt_annual_model)
#>        make     model vehicle_type                     powertrain vmt_annual
#> 1     Lexus   RX PHEV          CUV Plug-In Hybrid Electric (PHEV)   6403.802
#> 2 Chevrolet   Venture      Minivan                       Gasoline  16719.519
#> 3     Honda  Prologue          CUV         Battery Electric (BEV)   3943.976
#> 4      Ford    Escape          CUV Plug-In Hybrid Electric (PHEV)   7705.681
#> 5     Lexus TX Hybrid          CUV          Hybrid Electric (HEV)   7951.909
#> 6     Mazda      CX-5          CUV                         Diesel  11223.632
```
