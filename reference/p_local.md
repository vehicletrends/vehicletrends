# Local market share summary statistics by census tract

Summary statistics of the share of vehicle listings (`p`) across US
census tracts, measuring the distribution of local market shares for
different vehicle market segments. Values are computed per census tract
based on dealers reachable within a 60-minute drive time isochrone, then
summarized across tracts. Three grouping variables are included:
powertrain, vehicle type, and price bin, each crossed with inventory
type and listing year.

## Usage

``` r
data(p_local)
```

## Format

A tibble with 11 variables:

|                  |                                                                         |
|------------------|-------------------------------------------------------------------------|
| Variable         | Description                                                             |
| `group_var`      | Grouping variable: "powertrain", "vehicle_type", or "price_bin"         |
| `group_level`    | Level of the grouping variable (e.g., "Gasoline", "Car", "\$30k-\$40k") |
| `inventory_type` | Inventory type: "New" or "Used"                                         |
| `listing_year`   | Year of the vehicle listing                                             |
| `mean`           | Mean local market share across census tracts                            |
| `median`         | Median local market share across census tracts                          |
| `q25`            | 25th percentile local market share across census tracts                 |
| `q75`            | 75th percentile local market share across census tracts                 |
| `IQR`            | Interquartile range of local market share across census tracts          |
| `upper`          | Upper whisker bound (q75 + 1.5 \* IQR)                                  |
| `lower`          | Lower whisker bound (q25 - 1.5 \* IQR)                                  |

## Source

Computed from vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Details

Census-tract-level values (before summarization) are available as
parquet files on GitHub at
<https://github.com/vehicletrends/vehicletrends/releases/tag/data-v1>.

## Examples

``` r
data(p_local)

head(p_local)
#> # A tibble: 6 × 11
#>   group_var  group_level     inventory_type listing_year    mean  median     q25
#>   <chr>      <chr>           <chr>                 <dbl>   <dbl>   <dbl>   <dbl>
#> 1 powertrain Battery Electr… New                    2025 0.0427  0.0411  0.0340 
#> 2 powertrain Battery Electr… New                    2024 0.0463  0.0444  0.0376 
#> 3 powertrain Battery Electr… Used                   2021 0.00541 0.00459 0.00345
#> 4 powertrain Battery Electr… Used                   2024 0.0201  0.0157  0.0125 
#> 5 powertrain Battery Electr… Used                   2023 0.0131  0.0113  0.00882
#> 6 powertrain Battery Electr… Used                   2022 0.00872 0.00706 0.00579
#> # ℹ 4 more variables: q75 <dbl>, IQR <dbl>, upper <dbl>, lower <dbl>
```
