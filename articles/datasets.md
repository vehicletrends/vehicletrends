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

## `percent_listings`

Share of vehicle listings for combinations of grouping variables,
computed across all listing years and inventory types. Includes six
pairwise combinations (powertrain by vehicle type, powertrain by price
bin, vehicle type by powertrain, vehicle type by price bin, price bin by
powertrain, and price bin by vehicle type) plus three singular time
trends for powertrain, vehicle type, and price bin individually.

| Variable         | Description                                                                                                   |
|:-----------------|:--------------------------------------------------------------------------------------------------------------|
| `listing_year`   | Year of the vehicle listing (2018–2024)                                                                       |
| `inventory_type` | Inventory type: “New” or “Used”                                                                               |
| `group_var`      | Name of the grouping variable: “powertrain”, “vehicle_type”, or “price_bin”                                   |
| `group_level`    | Level of the grouping variable (e.g., “Gasoline”, “Car”, “\$30k-\$40k”)                                       |
| `category_var`   | Name of the category variable: “powertrain”, “vehicle_type”, or “price_bin”; `NA` for singular time trends    |
| `category_level` | Level of the category variable; `NA` for singular time trends                                                 |
| `n`              | Number of listings in this group-category combination                                                         |
| `p`              | Proportion of listings within the group (sums to 1 within each listing year, inventory type, and group level) |

``` r
head(percent_listings, 10)
#>    listing_year inventory_type  group_var            group_level category_var
#> 1          2018            New powertrain Battery Electric (BEV) vehicle_type
#> 2          2025            New powertrain Battery Electric (BEV) vehicle_type
#> 3          2024            New powertrain Battery Electric (BEV) vehicle_type
#> 4          2024            New powertrain Battery Electric (BEV) vehicle_type
#> 5          2025            New powertrain Battery Electric (BEV) vehicle_type
#> 6          2023            New powertrain Battery Electric (BEV) vehicle_type
#> 7          2022            New powertrain Battery Electric (BEV) vehicle_type
#> 8          2023            New powertrain Battery Electric (BEV) vehicle_type
#> 9          2024            New powertrain Battery Electric (BEV) vehicle_type
#> 10         2025            New powertrain Battery Electric (BEV) vehicle_type
#>    category_level     n           p
#> 1         Minivan    31 0.001001163
#> 2         Minivan  6115 0.011988104
#> 3         Minivan   933 0.001800251
#> 4             SUV 10858 0.020950834
#> 5             SUV 29138 0.057123365
#> 6             SUV  1341 0.003776146
#> 7          Pickup  7685 0.043135384
#> 8          Pickup 19497 0.054901950
#> 9          Pickup 38112 0.073538237
#> 10         Pickup 51014 0.100009998
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

## `hhi_local_summary`

Herfindahl-Hirschman Index (HHI) summary statistics across US census
tracts, measuring market concentration for different vehicle market
dimensions. HHI values are computed per census tract based on dealers
reachable within a 60-minute drive time isochrone, then summarized
across tracts. Higher HHI values indicate greater market concentration
(less diversity). Nine grouping-variable combinations are included: for
each grouping variable (powertrain, vehicle type, price bin), HHI is
computed over the other three variables (make, and the two remaining
grouping variables). Census-tract-level HHI values (before
summarization) are available as parquet files:
[hhi_pb_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_pb_60.parquet),
[hhi_pt_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_pt_60.parquet),
[hhi_vt_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_vt_60.parquet).

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
head(hhi_local_summary, 10)
#>     group_var            group_level hhi_var listing_year      mean    median
#> 1  powertrain Battery Electric (BEV)    make         2025 0.2281757 0.1922108
#> 2  powertrain Battery Electric (BEV)    make         2024 0.2290159 0.1958011
#> 3  powertrain Battery Electric (BEV)    make         2021 0.2991893 0.2577515
#> 4  powertrain Battery Electric (BEV)    make         2023 0.2503708 0.2178611
#> 5  powertrain Battery Electric (BEV)    make         2022 0.3367828 0.3089308
#> 6  powertrain                 Diesel    make         2023 0.2252425 0.2148836
#> 7  powertrain                 Diesel    make         2022 0.2284639 0.2197895
#> 8  powertrain                 Diesel    make         2025 0.2340765 0.2228044
#> 9  powertrain                 Diesel    make         2024 0.2305378 0.2193800
#> 10 powertrain        Flex Fuel (E85)    make         2022 0.4768817 0.3200439
#>          q25       q75        IQR     upper       lower
#> 1  0.1364988 0.2650060 0.12850720 0.4577668 -0.05626202
#> 2  0.1277967 0.2726680 0.14487134 0.4899751 -0.08951030
#> 3  0.1943984 0.3456040 0.15120567 0.5724125 -0.03241015
#> 4  0.1347314 0.2948265 0.16009508 0.5349691 -0.10541120
#> 5  0.1661640 0.4424988 0.27633481 0.8570010 -0.24833819
#> 6  0.2071404 0.2250711 0.01793070 0.2519672  0.18024436
#> 7  0.2090337 0.2306076 0.02157394 0.2629685  0.17667277
#> 8  0.2175441 0.2327736 0.01522954 0.2556179  0.19469977
#> 9  0.2138155 0.2302501 0.01643458 0.2549020  0.18916363
#> 10 0.2128875 0.7386170 0.52572951 1.5272113 -0.57570677
```

## `p_local_summary`

Local market share summary statistics across US census tracts, measuring
the distribution of the share of vehicle listings (`p`) for different
vehicle market segments. Values are computed per census tract based on
dealers reachable within a 60-minute drive time isochrone, then
summarized across tracts. Three grouping variables are included:
powertrain, vehicle type, and price bin. Census-tract-level values
(before summarization) are available as parquet files:
[p_pb_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_pb_60.parquet),
[p_pt_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_pt_60.parquet),
[p_vt_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_vt_60.parquet).

| Variable         | Description                                                             |
|:-----------------|:------------------------------------------------------------------------|
| `group_var`      | Grouping variable: “powertrain”, “vehicle_type”, or “price_bin”         |
| `group_level`    | Level of the grouping variable (e.g., “Gasoline”, “Car”, “\$30k-\$40k”) |
| `inventory_type` | Inventory type: “New” or “Used”                                         |
| `listing_year`   | Year of the vehicle listing                                             |
| `mean`           | Mean local market share across census tracts                            |
| `median`         | Median local market share across census tracts                          |
| `q25`            | 25th percentile local market share across census tracts                 |
| `q75`            | 75th percentile local market share across census tracts                 |
| `IQR`            | Interquartile range of local market share across census tracts          |
| `upper`          | Upper whisker bound (q75 + 1.5 \* IQR)                                  |
| `lower`          | Lower whisker bound (q25 - 1.5 \* IQR)                                  |

``` r
head(p_local_summary, 10)
#>     group_var            group_level inventory_type listing_year        mean
#> 1  powertrain Battery Electric (BEV)            New         2025 0.042667113
#> 2  powertrain Battery Electric (BEV)            New         2024 0.046262512
#> 3  powertrain Battery Electric (BEV)           Used         2021 0.005406185
#> 4  powertrain Battery Electric (BEV)           Used         2024 0.020051480
#> 5  powertrain Battery Electric (BEV)           Used         2023 0.013141464
#> 6  powertrain Battery Electric (BEV)           Used         2022 0.008715149
#> 7  powertrain Battery Electric (BEV)           Used         2025 0.026557616
#> 8  powertrain                 Diesel           Used         2023 0.032129920
#> 9  powertrain                 Diesel           Used         2022 0.031783710
#> 10 powertrain                 Diesel           Used         2025 0.034581686
#>         median         q25         q75         IQR      upper         lower
#> 1  0.041085481 0.034037533 0.048416693 0.014379160 0.06998543  0.0124687935
#> 2  0.044353099 0.037626658 0.051068453 0.013441795 0.07123115  0.0174639654
#> 3  0.004586378 0.003447483 0.006252421 0.002804938 0.01045983 -0.0007599233
#> 4  0.015735710 0.012542852 0.020185771 0.007642919 0.03165015  0.0010784724
#> 5  0.011312013 0.008820033 0.014142383 0.005322350 0.02212591  0.0008365081
#> 6  0.007060302 0.005785052 0.009307720 0.003522668 0.01459172  0.0005010506
#> 7  0.022417082 0.017587623 0.028387948 0.010800325 0.04458844  0.0013871352
#> 8  0.031125883 0.028097768 0.034741198 0.006643430 0.04470634  0.0181326232
#> 9  0.031086034 0.027303897 0.034463712 0.007159815 0.04520343  0.0165641749
#> 10 0.033097019 0.029682575 0.037742402 0.008059828 0.04983214  0.0175928328
```

## Large Raw Data Files

The following large files are hosted on Cloudflare R2 and can be
downloaded directly. The `hhi_*` and `p_*` parquet files are the
census-tract-level source data used to compute the `hhi_local_summary`
and `p_local_summary` package datasets. File name suffixes indicate the
grouping variable (`pb` = price bin, `pt` = powertrain, `vt` = vehicle
type) and isochrone radius (`60` = 60-minute drive time).

| File                                                                                               | Description                                                                   |
|:---------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------|
| [hhi_pb_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_pb_60.parquet)         | HHI per census tract, grouped by price bin (60-min isochrone)                 |
| [hhi_pt_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_pt_60.parquet)         | HHI per census tract, grouped by powertrain (60-min isochrone)                |
| [hhi_vt_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_vt_60.parquet)         | HHI per census tract, grouped by vehicle type (60-min isochrone)              |
| [p_pb_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_pb_60.parquet)             | Market share (p) per census tract, grouped by price bin (60-min isochrone)    |
| [p_pt_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_pt_60.parquet)             | Market share (p) per census tract, grouped by powertrain (60-min isochrone)   |
| [p_vt_60.parquet](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/p_vt_60.parquet)             | Market share (p) per census tract, grouped by vehicle type (60-min isochrone) |
| [tracts.rds](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/tracts.rds)                       | US census tract geometries (full resolution)                                  |
| [tracts_simplified.rds](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/tracts_simplified.rds) | US census tract geometries (simplified for faster rendering)                  |
| [hhi_tracts.pmtiles](https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_tracts.pmtiles)       | HHI per census tract as PMTiles for interactive map visualization             |

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
