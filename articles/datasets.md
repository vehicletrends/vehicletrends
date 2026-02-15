# Datasets

This article provides detailed data dictionaries and previews for every
dataset in the vehicletrends package.

## `vmt_age`

Cumulative odometer mileage quantiles for used vehicles at 3-month age
bins, computed from vehicle listings data. Only used vehicles with valid
mileage and age up to 15 years (180 months) are included. Quantiles are
provided at the 25th, 50th, and 75th percentiles across various
groupings of powertrain and vehicle type.

| Variable       | Description                                                                                                                                                                                |
|:---------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `age_bin`      | Midpoint of 3-month age bin in months (e.g., 1.5, 4.5, …, up to 180)                                                                                                                       |
| `powertrain`   | Powertrain category: “All”, “Gasoline”, “Battery Electric (BEV)”, “BEV (Tesla)”, “BEV (Non-Tesla)”, “Hybrid Electric (HEV)”, “Plug-In Hybrid Electric (PHEV)”, “Diesel”, “Flex Fuel (E85)” |
| `vehicle_type` | Vehicle type: “All”, “Car”, “CUV”, “SUV”, “Pickup”, “Minivan”                                                                                                                              |
| `quantile`     | Quantile level (25, 50, or 75)                                                                                                                                                             |
| `miles`        | Total odometer miles at the given quantile                                                                                                                                                 |

``` r
head(vmt_age, 10)
#>    age_bin powertrain vehicle_type quantile       miles
#> 1      1.5        All          All       25    7.487188
#> 2      1.5        All          All       50  127.162159
#> 3      1.5        All          All       75 1422.437125
#> 4      4.5        All          All       25   19.418350
#> 5      4.5        All          All       50  803.475768
#> 6      4.5        All          All       75 3162.262634
#> 7      7.5        All          All       25  300.481568
#> 8      7.5        All          All       50 2326.992600
#> 9      7.5        All          All       75 4963.841562
#> 10    10.5        All          All       25 1306.355234
```

## `vmt_daily`

Daily VMT quantiles for used vehicles, computed as total odometer miles
divided by vehicle age in days. Only used vehicles with valid mileage
and age up to 15 years are included. Percentile quantiles from the 1st
through 99th are provided across various groupings of powertrain and
vehicle type.

| Variable       | Description                                                                                                                                                                                |
|:---------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `powertrain`   | Powertrain category: “All”, “Gasoline”, “Battery Electric (BEV)”, “BEV (Tesla)”, “BEV (Non-Tesla)”, “Hybrid Electric (HEV)”, “Plug-In Hybrid Electric (PHEV)”, “Diesel”, “Flex Fuel (E85)” |
| `vehicle_type` | Vehicle type: “All”, “Car”, “CUV”, “SUV”, “Pickup”, “Minivan”                                                                                                                              |
| `quantile`     | Quantile level (1 through 99)                                                                                                                                                              |
| `miles`        | Daily vehicle miles traveled at the given quantile                                                                                                                                         |

``` r
head(vmt_daily, 10)
#>    powertrain vehicle_type quantile     miles
#> 1         All          All        1  2.719209
#> 2         All          All        2  4.637514
#> 3         All          All        3  6.048788
#> 4         All          All        4  7.249902
#> 5         All          All        5  8.233122
#> 6         All          All        6  9.068620
#> 7         All          All        7  9.872219
#> 8         All          All        8 10.630848
#> 9         All          All        9 11.298499
#> 10        All          All       10 11.929582
```

## `vmt_annual_type`

Estimated annual vehicle miles traveled for each combination of
powertrain and vehicle type. Computed by fitting OLS regressions of
total odometer miles on vehicle age (in years) for used vehicle
listings; the slope coefficient represents the estimated annual VMT.

| Variable       | Description                                                                                                                                       |
|:---------------|:--------------------------------------------------------------------------------------------------------------------------------------------------|
| `vehicle_type` | Vehicle type: “Car”, “CUV”, “SUV”, “Pickup”, “Minivan”                                                                                            |
| `powertrain`   | Powertrain category: “Gasoline”, “Battery Electric (BEV)”, “Hybrid Electric (HEV)”, “Plug-In Hybrid Electric (PHEV)”, “Diesel”, “Flex Fuel (E85)” |
| `vmt_annual`   | Estimated annual vehicle miles traveled                                                                                                           |

``` r
head(vmt_annual_type, 10)
#>                powertrain vehicle_type vmt_annual
#> 1  Battery Electric (BEV)          CUV   9805.068
#> 2  Battery Electric (BEV)          Car   6710.569
#> 3  Battery Electric (BEV)      Minivan   5523.487
#> 4  Battery Electric (BEV)       Pickup   9538.308
#> 5  Battery Electric (BEV)          SUV   7433.105
#> 6                  Diesel          CUV  10124.972
#> 7                  Diesel          Car  10112.002
#> 8                  Diesel      Minivan   4841.334
#> 9                  Diesel       Pickup  12466.379
#> 10                 Diesel          SUV  10947.811
```

## `vmt_annual_model`

Estimated annual vehicle miles traveled for individual vehicle
make/model combinations. Computed by fitting OLS regressions of total
odometer miles on vehicle age (in years) for used vehicle listings; the
slope coefficient represents the estimated annual VMT. Only make/model
combinations with at least 100 listings are included, and results are
filtered to positive annual VMT values only.

| Variable       | Description                                                                                                                                       |
|:---------------|:--------------------------------------------------------------------------------------------------------------------------------------------------|
| `make`         | Vehicle manufacturer (e.g., “Toyota”, “BMW”, “Mercedes-Benz”)                                                                                     |
| `model`        | Vehicle model name (e.g., “Camry”, “RAV4”, “Model 3”)                                                                                             |
| `vehicle_type` | Vehicle type: “Car”, “CUV”, “SUV”, “Pickup”, “Minivan”                                                                                            |
| `powertrain`   | Powertrain category: “Gasoline”, “Battery Electric (BEV)”, “Hybrid Electric (HEV)”, “Plug-In Hybrid Electric (PHEV)”, “Diesel”, “Flex Fuel (E85)” |
| `vmt_annual`   | Estimated annual vehicle miles traveled                                                                                                           |

``` r
head(vmt_annual_model, 10)
#>          make               model                     powertrain vehicle_type
#> 1       Acura                 MDX                       Gasoline          CUV
#> 2       Acura                 RDX                       Gasoline          CUV
#> 3       Acura                  TL                       Gasoline          Car
#> 4       Acura                 TLX                       Gasoline          Car
#> 5  Alfa Romeo              Tonale Plug-In Hybrid Electric (PHEV)          CUV
#> 6        Audi                  A3                         Diesel          Car
#> 7        Audi            A3 Sedan                         Diesel          Car
#> 8        Audi A3 Sportback e-tron Plug-In Hybrid Electric (PHEV)          Car
#> 9        Audi                  A4                Flex Fuel (E85)          Car
#> 10       Audi                  A4                       Gasoline          Car
#>    vmt_annual
#> 1   11334.421
#> 2   10640.250
#> 3    8155.315
#> 4   11107.978
#> 5    7538.852
#> 6    8582.209
#> 7   10542.387
#> 8    8538.215
#> 9    9182.230
#> 10   9070.911
```

## `depreciation`

Retention rate (price / MSRP) quantiles for used vehicles, computed at
3-month age bins from vehicle listings data. Only used vehicles with
valid price and MSRP values are included, with ages ranging from 12 to
180 months (15 years). Quantiles are provided at the 25th, 50th, and
75th percentiles across various groupings of powertrain and vehicle
type.

| Variable       | Description                                                                                                                                                                                |
|:---------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `age_bin`      | Midpoint of 3-month age bin in months (e.g., 13.5, 16.5, …, up to 180)                                                                                                                     |
| `powertrain`   | Powertrain category: “All”, “Gasoline”, “Battery Electric (BEV)”, “BEV (Tesla)”, “BEV (Non-Tesla)”, “Hybrid Electric (HEV)”, “Plug-In Hybrid Electric (PHEV)”, “Diesel”, “Flex Fuel (E85)” |
| `vehicle_type` | Vehicle type: “All”, “Car”, “CUV”, “SUV”, “Pickup”, “Minivan”                                                                                                                              |
| `quantile`     | Quantile level (25, 50, or 75)                                                                                                                                                             |
| `rr`           | Retention rate (price / MSRP) at the given quantile                                                                                                                                        |

``` r
head(depreciation, 10)
#>    age_bin powertrain vehicle_type quantile        rr
#> 1     13.5        All          All       25 0.8077305
#> 2     13.5        All          All       50 0.9425665
#> 3     13.5        All          All       75 1.0857731
#> 4     16.5        All          All       25 0.7602528
#> 5     16.5        All          All       50 0.9009337
#> 6     16.5        All          All       75 1.0469076
#> 7     19.5        All          All       25 0.7075987
#> 8     19.5        All          All       50 0.8456087
#> 9     19.5        All          All       75 0.9995060
#> 10    22.5        All          All       25 0.7011685
```

## `dep_annual_type`

Estimated annual depreciation rate for each combination of powertrain
and vehicle type. Computed by fitting log-linear regressions of
retention rate (price / MSRP) on vehicle age (in years) for used vehicle
listings; the annual depreciation rate is `1 - exp(b)` where `b` is the
age coefficient. Only used vehicles aged 1–10 years with valid price and
MSRP values are included.

| Variable       | Description                                                                                                                                       |
|:---------------|:--------------------------------------------------------------------------------------------------------------------------------------------------|
| `vehicle_type` | Vehicle type: “Car”, “CUV”, “SUV”, “Pickup”, “Minivan”                                                                                            |
| `powertrain`   | Powertrain category: “Gasoline”, “Battery Electric (BEV)”, “Hybrid Electric (HEV)”, “Plug-In Hybrid Electric (PHEV)”, “Diesel”, “Flex Fuel (E85)” |
| `dep_annual`   | Estimated annual depreciation rate (proportion, 0–1)                                                                                              |

``` r
head(dep_annual_type, 10)
#>                powertrain vehicle_type dep_annual
#> 1  Battery Electric (BEV)          CUV 0.10402026
#> 2  Battery Electric (BEV)          Car 0.10233225
#> 3  Battery Electric (BEV)      Minivan 0.06215965
#> 4  Battery Electric (BEV)       Pickup 0.05573484
#> 5  Battery Electric (BEV)          SUV 0.02428713
#> 6         Flex Fuel (E85)          CUV 0.06586182
#> 7         Flex Fuel (E85)          Car 0.05712966
#> 8         Flex Fuel (E85)      Minivan 0.07188022
#> 9         Flex Fuel (E85)       Pickup 0.04602709
#> 10        Flex Fuel (E85)          SUV 0.09711303
```

## `dep_annual_model`

Estimated annual depreciation rate for individual vehicle make/model
combinations. Computed by fitting log-linear regressions of retention
rate (price / MSRP) on vehicle age (in years) for used vehicle listings;
the annual depreciation rate is `1 - exp(b)` where `b` is the age
coefficient. Only used vehicles aged 1–10 years with valid price and
MSRP values are included. Only make/model combinations with at least 100
listings are included, and results are filtered to positive depreciation
rates only.

| Variable       | Description                                                                                                                                       |
|:---------------|:--------------------------------------------------------------------------------------------------------------------------------------------------|
| `make`         | Vehicle manufacturer (e.g., “Toyota”, “BMW”, “Mercedes-Benz”)                                                                                     |
| `model`        | Vehicle model name (e.g., “Camry”, “RAV4”, “Model 3”)                                                                                             |
| `vehicle_type` | Vehicle type: “Car”, “CUV”, “SUV”, “Pickup”, “Minivan”                                                                                            |
| `powertrain`   | Powertrain category: “Gasoline”, “Battery Electric (BEV)”, “Hybrid Electric (HEV)”, “Plug-In Hybrid Electric (PHEV)”, “Diesel”, “Flex Fuel (E85)” |
| `dep_annual`   | Estimated annual depreciation rate (proportion, 0–1)                                                                                              |

``` r
head(dep_annual_model, 10)
#>     make        model      powertrain vehicle_type dep_annual
#> 1  Acura          MDX        Gasoline          CUV 0.11083871
#> 2  Acura          RDX        Gasoline          CUV 0.09383736
#> 3  Acura           TL        Gasoline          Car 0.07885553
#> 4  Acura          TLX        Gasoline          Car 0.07452962
#> 5   Audi           A4 Flex Fuel (E85)          Car 0.07030819
#> 6   Audi           A4        Gasoline          Car 0.09650968
#> 7   Audi           A5 Flex Fuel (E85)          Car 0.05352090
#> 8   Audi A5 Cabriolet Flex Fuel (E85)          Car 0.07388719
#> 9   Audi     A5 Coupe Flex Fuel (E85)          Car 0.07335039
#> 10  Audi      Allroad Flex Fuel (E85)          Car 0.08773891
```

## `percent_market`

Market share (proportion) of vehicle listings for each combination of
two grouping variables, computed across all listing years and inventory
types. Six variable-pair combinations are included: powertrain by
vehicle type, powertrain by price bin, vehicle type by powertrain,
vehicle type by price bin, price bin by powertrain, and price bin by
vehicle type.

| Variable         | Description                                                                                                   |
|:-----------------|:--------------------------------------------------------------------------------------------------------------|
| `listing_year`   | Year of the vehicle listing (2018–2024)                                                                       |
| `inventory_type` | Inventory type: “New” or “Used”                                                                               |
| `group_var`      | Name of the grouping variable: “powertrain”, “vehicle_type”, or “price_bin”                                   |
| `group_level`    | Level of the grouping variable (e.g., “Gasoline”, “Car”, “\$30k-\$40k”)                                       |
| `category_var`   | Name of the category variable: “powertrain”, “vehicle_type”, or “price_bin”                                   |
| `category_level` | Level of the category variable                                                                                |
| `n`              | Number of listings in this group-category combination                                                         |
| `p`              | Proportion of listings within the group (sums to 1 within each listing year, inventory type, and group level) |

``` r
head(percent_market, 10)
#>    listing_year inventory_type  group_var            group_level category_var
#> 1          2019            New powertrain Battery Electric (BEV) vehicle_type
#> 2          2020            New powertrain Battery Electric (BEV) vehicle_type
#> 3          2021            New powertrain Battery Electric (BEV) vehicle_type
#> 4          2018            New powertrain Battery Electric (BEV) vehicle_type
#> 5          2018            New powertrain Battery Electric (BEV) vehicle_type
#> 6          2021            New powertrain Battery Electric (BEV) vehicle_type
#> 7          2020            New powertrain Battery Electric (BEV) vehicle_type
#> 8          2019            New powertrain Battery Electric (BEV) vehicle_type
#> 9          2022            New powertrain Battery Electric (BEV) vehicle_type
#> 10         2024            New powertrain Battery Electric (BEV) vehicle_type
#>    category_level     n           p
#> 1             Car 32849 0.809427593
#> 2             Car 27343 0.683028577
#> 3             Car 38370 0.398029046
#> 4             Car 30747 0.992991862
#> 5         Minivan    31 0.001001163
#> 6             CUV 58030 0.601970954
#> 7             CUV 12689 0.316971423
#> 8             CUV  7733 0.190547766
#> 9          Pickup  7685 0.043135384
#> 10         Pickup 38112 0.073538237
```

## `percent_dealers`

Percentage of dealers that have at least one listing for each
combination of two grouping variables, computed across all listing years
and inventory types. Three variable-pair combinations are included:
powertrain by vehicle type, powertrain by price bin, and vehicle type by
price bin.

| Variable         | Description                                                                        |
|:-----------------|:-----------------------------------------------------------------------------------|
| `listing_year`   | Year of the vehicle listing (2018–2024)                                            |
| `inventory_type` | Inventory type: “New” or “Used”                                                    |
| `group_var`      | Name of the grouping variable: “powertrain”, “vehicle_type”, or “price_bin”        |
| `group_level`    | Level of the grouping variable (e.g., “Gasoline”, “Car”, “\$30k-\$40k”)            |
| `category_var`   | Name of the category variable: “powertrain”, “vehicle_type”, or “price_bin”        |
| `category_level` | Level of the category variable                                                     |
| `p`              | Proportion of dealers with at least one listing in this group-category combination |

``` r
head(percent_dealers, 10)
#>    listing_year inventory_type  group_var            group_level category_var
#> 1          2019            New powertrain Battery Electric (BEV) vehicle_type
#> 2          2020            New powertrain Battery Electric (BEV) vehicle_type
#> 3          2021            New powertrain Battery Electric (BEV) vehicle_type
#> 4          2018            New powertrain Battery Electric (BEV) vehicle_type
#> 5          2018            New powertrain Battery Electric (BEV) vehicle_type
#> 6          2021            New powertrain Battery Electric (BEV) vehicle_type
#> 7          2020            New powertrain Battery Electric (BEV) vehicle_type
#> 8          2019            New powertrain Battery Electric (BEV) vehicle_type
#> 9          2022            New powertrain Battery Electric (BEV) vehicle_type
#> 10         2024            New powertrain Battery Electric (BEV) vehicle_type
#>    category_level           p
#> 1             Car 0.146704506
#> 2             Car 0.158801921
#> 3             Car 0.191919192
#> 4             Car 0.151886245
#> 5         Minivan 0.001160766
#> 6             CUV 0.318823595
#> 7             CUV 0.064255439
#> 8             CUV 0.054558091
#> 9          Pickup 0.110011107
#> 10         Pickup 0.215214411
```

## `hhi`

Herfindahl-Hirschman Index (HHI) summary statistics across US census
tracts, measuring market concentration for different vehicle market
dimensions. HHI values are computed per census tract based on dealers
reachable within a 60-minute drive time isochrone, then summarized
across tracts. Higher HHI values indicate greater market concentration
(less diversity). Nine grouping-variable combinations are included: for
each grouping variable (powertrain, vehicle type, price bin), HHI is
computed over the other three variables (make, and the two remaining
grouping variables). Census-tract-level HHI values (before
summarization) are also available as parquet files on
[GitHub](https://github.com/vehicletrends/vehicletrends/releases/tag/data-v1).

| Variable       | Description                                                                               |
|:---------------|:------------------------------------------------------------------------------------------|
| `group_var`    | Grouping variable: “powertrain”, “vehicle_type”, or “price_bin”                           |
| `group_level`  | Level of the grouping variable (e.g., “Gasoline”, “Car”, “\$30k-\$40k”)                   |
| `hhi_var`      | Variable over which HHI is computed: “make”, “powertrain”, “vehicle_type”, or “price_bin” |
| `listing_year` | Year of the vehicle listing                                                               |
| `mean`         | Mean HHI across census tracts                                                             |
| `median`       | Median HHI across census tracts                                                           |
| `q25`          | 25th percentile HHI across census tracts                                                  |
| `q75`          | 75th percentile HHI across census tracts                                                  |
| `IQR`          | Interquartile range of HHI across census tracts                                           |
| `upper`        | Upper whisker bound (q75 + 1.5 \* IQR)                                                    |
| `lower`        | Lower whisker bound (q25 - 1.5 \* IQR)                                                    |

``` r
head(hhi, 10)
#>     group_var                    group_level hhi_var listing_year       mean
#> 1  powertrain         Battery Electric (BEV)    make         2022 0.20312602
#> 2  powertrain         Battery Electric (BEV)    make         2023 0.15328833
#> 3  powertrain         Battery Electric (BEV)    make         2024 0.15696601
#> 4  powertrain         Battery Electric (BEV)    make         2025 0.16444612
#> 5  powertrain                         Diesel    make         2022 0.21996845
#> 6  powertrain Plug-In Hybrid Electric (PHEV)    make         2023 0.21815277
#> 7  powertrain          Hybrid Electric (HEV)    make         2024 0.24772064
#> 8  powertrain          Hybrid Electric (HEV)    make         2022 0.24089100
#> 9  powertrain                       Gasoline    make         2022 0.09468131
#> 10 powertrain                       Gasoline    make         2023 0.09733042
#>        median        q25        q75        IQR     upper         lower
#> 1  0.14537291 0.12569731 0.20665352 0.08095621 0.3280878  0.0042629983
#> 2  0.10563205 0.09391663 0.14352344 0.04960681 0.2179337  0.0195064116
#> 3  0.10964525 0.08868479 0.14803217 0.05934738 0.2370532 -0.0003362752
#> 4  0.12047871 0.09665293 0.17031514 0.07366221 0.2808085 -0.0138403851
#> 5  0.21260221 0.18776975 0.24389814 0.05612839 0.3280907  0.1035771613
#> 6  0.17352926 0.14372901 0.22007527 0.07634626 0.3345947  0.0292096194
#> 7  0.22115182 0.19967534 0.25606102 0.05638568 0.3406395  0.1150968290
#> 8  0.21350351 0.19184023 0.25497530 0.06313507 0.3496779  0.0971376127
#> 9  0.08149692 0.07339856 0.09731230 0.02391374 0.1331829  0.0375279508
#> 10 0.08568870 0.07502934 0.09976942 0.02474007 0.1368795  0.0379192299
```

## `registrations`

Annual vehicle registration counts by US state and powertrain type,
scraped from the [Alternative Fuels Data Center
(AFDC)](https://afdc.energy.gov/vehicle-registration) for years 2016
through 2024.

| Variable     | Description                                                                                                                                                                                                                                                    |
|:-------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `year`       | Registration year (2016–2024)                                                                                                                                                                                                                                  |
| `state`      | US state name (e.g., “Alabama”, “California”)                                                                                                                                                                                                                  |
| `powertrain` | Fuel/powertrain type (e.g., “Battery Electric (BEV)”, “Diesel”, “Gasoline”, “Hybrid Electric (HEV)”, “Plug-In Hybrid Electric (PHEV)”, “Biodiesel”, “Compressed Natural Gas (CNG)”, “Ethanol/Flex Fuel (E85)”, “Fuel Cell”, “Hydrogen”, “Methanol”, “Propane”) |
| `count`      | Number of registered vehicles                                                                                                                                                                                                                                  |

``` r
head(registrations, 10)
#>    year   state                     powertrain   count
#> 1  2016 Alabama         Battery Electric (BEV)     500
#> 2  2016 Alabama                      Biodiesel       0
#> 3  2016 Alabama   Compressed Natural Gas (CNG)   20100
#> 4  2016 Alabama                         Diesel  126500
#> 5  2016 Alabama                Flex Fuel (E85)  428300
#> 6  2016 Alabama                      Fuel Cell       0
#> 7  2016 Alabama                       Gasoline 3777300
#> 8  2016 Alabama          Hybrid Electric (HEV)   29100
#> 9  2016 Alabama                       Methanol       0
#> 10 2016 Alabama Plug-In Hybrid Electric (PHEV)     900
```
