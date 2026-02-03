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
#> 1      1.5        All          All       25    6.661913
#> 2      1.5        All          All       50  105.955773
#> 3      1.5        All          All       75 1413.149703
#> 4      4.5        All          All       25   16.534734
#> 5      4.5        All          All       50  782.400927
#> 6      4.5        All          All       75 3222.299469
#> 7      7.5        All          All       25  319.801939
#> 8      7.5        All          All       50 2363.317418
#> 9      7.5        All          All       75 4982.525678
#> 10    10.5        All          All       25 1402.481325
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
#> 1         All          All        1  2.744988
#> 2         All          All        2  4.737732
#> 3         All          All        3  6.107311
#> 4         All          All        4  7.260857
#> 5         All          All        5  8.264062
#> 6         All          All        6  9.157538
#> 7         All          All        7  9.957316
#> 8         All          All        8 10.702454
#> 9         All          All        9 11.360159
#> 10        All          All       10 11.970550
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
#> 1  Battery Electric (BEV)          CUV   9254.098
#> 2  Battery Electric (BEV)          Car   6311.074
#> 3  Battery Electric (BEV)      Minivan   5675.074
#> 4  Battery Electric (BEV)       Pickup   8346.890
#> 5  Battery Electric (BEV)          SUV   6173.904
#> 6                  Diesel          CUV  10350.614
#> 7                  Diesel          Car  10157.129
#> 8                  Diesel      Minivan   5641.567
#> 9                  Diesel       Pickup  12510.755
#> 10                 Diesel          SUV  11291.680
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
#> 1   11439.057
#> 2   10757.562
#> 3    8313.543
#> 4   11357.799
#> 5    2678.829
#> 6    9029.751
#> 7   10771.148
#> 8    8687.849
#> 9    9907.146
#> 10   9203.896
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
#> 1     13.5        All          All       25 0.8073291
#> 2     13.5        All          All       50 0.9427215
#> 3     13.5        All          All       75 1.0860465
#> 4     16.5        All          All       25 0.7600114
#> 5     16.5        All          All       50 0.9012899
#> 6     16.5        All          All       75 1.0452036
#> 7     19.5        All          All       25 0.6969381
#> 8     19.5        All          All       50 0.8365147
#> 9     19.5        All          All       75 1.0007048
#> 10    22.5        All          All       25 0.6918902
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
#> 1  Battery Electric (BEV)          CUV 0.09482215
#> 2  Battery Electric (BEV)          Car 0.10086081
#> 3  Battery Electric (BEV)      Minivan 0.05807725
#> 4  Battery Electric (BEV)       Pickup 0.04463694
#> 5  Battery Electric (BEV)          SUV 0.02958732
#> 6         Flex Fuel (E85)          CUV 0.06405950
#> 7         Flex Fuel (E85)          Car 0.05714146
#> 8         Flex Fuel (E85)      Minivan 0.07145816
#> 9         Flex Fuel (E85)       Pickup 0.04531542
#> 10        Flex Fuel (E85)          SUV 0.09706353
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
#> 1  Acura          MDX        Gasoline          CUV 0.11100674
#> 2  Acura          RDX        Gasoline          CUV 0.09427202
#> 3  Acura           TL        Gasoline          Car 0.07883295
#> 4  Acura          TLX        Gasoline          Car 0.07436195
#> 5   Audi           A4 Flex Fuel (E85)          Car 0.06927778
#> 6   Audi           A4        Gasoline          Car 0.09856575
#> 7   Audi           A5 Flex Fuel (E85)          Car 0.05353769
#> 8   Audi A5 Cabriolet Flex Fuel (E85)          Car 0.07067091
#> 9   Audi     A5 Coupe Flex Fuel (E85)          Car 0.06737299
#> 10  Audi      Allroad Flex Fuel (E85)          Car 0.08653034
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
#> 1          2023            New powertrain Battery Electric (BEV) vehicle_type
#> 2          2024            New powertrain Battery Electric (BEV) vehicle_type
#> 3          2022            New powertrain Battery Electric (BEV) vehicle_type
#> 4          2018            New powertrain Battery Electric (BEV) vehicle_type
#> 5          2023            New powertrain Battery Electric (BEV) vehicle_type
#> 6          2024            New powertrain Battery Electric (BEV) vehicle_type
#> 7          2023            New powertrain Battery Electric (BEV) vehicle_type
#> 8          2024            New powertrain Battery Electric (BEV) vehicle_type
#> 9          2022            New powertrain Battery Electric (BEV) vehicle_type
#> 10         2021            New powertrain               Gasoline vehicle_type
#>    category_level       n           p
#> 1             CUV  266235 0.754818351
#> 2             CUV  395155 0.765348911
#> 3             CUV  138423 0.784853261
#> 4         Minivan      31 0.001001421
#> 5             SUV    1340 0.003799112
#> 6             SUV   10860 0.021033997
#> 7          Pickup   19499 0.055282750
#> 8          Pickup   38114 0.073820421
#> 9          Pickup    7686 0.043579334
#> 10            Car 1568596 0.222999993
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
#>    listing_year inventory_type  group_var group_level category_var
#> 1          2018           Used powertrain    Gasoline vehicle_type
#> 2          2021           Used powertrain    Gasoline vehicle_type
#> 3          2019           Used powertrain    Gasoline vehicle_type
#> 4          2020           Used powertrain    Gasoline vehicle_type
#> 5          2020           Used powertrain    Gasoline vehicle_type
#> 6          2019           Used powertrain    Gasoline vehicle_type
#> 7          2021           Used powertrain    Gasoline vehicle_type
#> 8          2018           Used powertrain    Gasoline vehicle_type
#> 9          2018           Used powertrain    Gasoline vehicle_type
#> 10         2020           Used powertrain    Gasoline vehicle_type
#>    category_level         p
#> 1          Pickup 0.8387126
#> 2          Pickup 0.7811082
#> 3          Pickup 0.8406557
#> 4          Pickup 0.8123635
#> 5             Car 0.9530050
#> 6             Car 0.9492858
#> 7             Car 0.9410631
#> 8             Car 0.9576325
#> 9             CUV 0.9225687
#> 10            CUV 0.9220349
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
