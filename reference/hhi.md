# Herfindahl-Hirschman Index (HHI) summary statistics by census tract

Summary statistics of the Herfindahl-Hirschman Index (HHI) across US
census tracts, measuring market concentration for different vehicle
market dimensions. HHI values are computed per census tract based on
dealers reachable within a 60-minute drive time isochrone, then
summarized across tracts. Higher HHI values indicate greater market
concentration (less diversity). Nine grouping-variable combinations are
included: for each grouping variable (powertrain, vehicle type, price
bin), HHI is computed over the other three variables (make, and the two
remaining grouping variables).

## Usage

``` r
data(hhi)
```

## Format

A tibble with 11 variables:

|                |                                                                                           |
|----------------|-------------------------------------------------------------------------------------------|
| Variable       | Description                                                                               |
| `group_var`    | Grouping variable: "powertrain", "vehicle_type", or "price_bin"                           |
| `group_level`  | Level of the grouping variable (e.g., "Gasoline", "Car", "\$30k-\$40k")                   |
| `hhi_var`      | Variable over which HHI is computed: "make", "powertrain", "vehicle_type", or "price_bin" |
| `listing_year` | Year of the vehicle listing                                                               |
| `mean`         | Mean HHI across census tracts                                                             |
| `median`       | Median HHI across census tracts                                                           |
| `q25`          | 25th percentile HHI across census tracts                                                  |
| `q75`          | 75th percentile HHI across census tracts                                                  |
| `IQR`          | Interquartile range of HHI across census tracts                                           |
| `upper`        | Upper whisker bound (q75 + 1.5 \* IQR)                                                    |
| `lower`        | Lower whisker bound (q25 - 1.5 \* IQR)                                                    |

## Source

Computed from vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Details

Census-tract-level HHI values (before summarization) are available as
parquet files on GitHub at
<https://github.com/vehicletrends/vehicletrends/releases/tag/data-v1>.

## Examples

``` r
data(hhi)

head(hhi)
#> # A tibble: 6 × 11
#>   group_var  group_level   hhi_var listing_year  mean median    q25   q75    IQR
#>   <chr>      <chr>         <chr>          <dbl> <dbl>  <dbl>  <dbl> <dbl>  <dbl>
#> 1 powertrain Battery Elec… make            2022 0.203  0.145 0.126  0.207 0.0810
#> 2 powertrain Battery Elec… make            2023 0.153  0.106 0.0939 0.144 0.0496
#> 3 powertrain Battery Elec… make            2024 0.157  0.110 0.0887 0.148 0.0593
#> 4 powertrain Battery Elec… make            2025 0.164  0.120 0.0967 0.170 0.0737
#> 5 powertrain Diesel        make            2022 0.220  0.213 0.188  0.244 0.0561
#> 6 powertrain Plug-In Hybr… make            2023 0.218  0.174 0.144  0.220 0.0763
#> # ℹ 2 more variables: upper <dbl>, lower <dbl>
```
