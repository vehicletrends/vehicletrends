# Herfindahl-Hirschman Index (HHI) summary statistics across local markets

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
data(hhi_local_summary)
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
parquet files:
<https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_pb_60.parquet>,
<https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_pt_60.parquet>,
<https://pub-17d608be304c4976845ab692fc09de91.r2.dev/hhi_vt_60.parquet>.

## Examples

``` r
data(hhi_local_summary)

head(hhi_local_summary)
#> # A tibble: 6 × 11
#>   group_var  group_level    hhi_var listing_year  mean median   q25   q75    IQR
#>   <chr>      <chr>          <chr>          <dbl> <dbl>  <dbl> <dbl> <dbl>  <dbl>
#> 1 powertrain Battery Elect… make            2025 0.228  0.192 0.136 0.265 0.129 
#> 2 powertrain Battery Elect… make            2024 0.229  0.196 0.128 0.273 0.145 
#> 3 powertrain Battery Elect… make            2021 0.299  0.258 0.194 0.346 0.151 
#> 4 powertrain Battery Elect… make            2023 0.250  0.218 0.135 0.295 0.160 
#> 5 powertrain Battery Elect… make            2022 0.337  0.309 0.166 0.442 0.276 
#> 6 powertrain Diesel         make            2023 0.225  0.215 0.207 0.225 0.0179
#> # ℹ 2 more variables: upper <dbl>, lower <dbl>
```
