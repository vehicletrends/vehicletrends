# Price trends for new vehicle listings by state, year, and vehicle type

Average prices and listing counts for new vehicle inventory by listing
year, state, model year, and vehicle type. Includes the number of unique
make-model-year combinations available in each state.

## Usage

``` r
data(price_trends_new)
```

## Format

A tibble with 7 variables:

|                     |                                                             |
|---------------------|-------------------------------------------------------------|
| Variable            | Description                                                 |
| `listing_year`      | Calendar year when listing was scraped (2018–2025)          |
| `state`             | US state abbreviation (e.g., "CA", "TX", "NY")              |
| `year`              | Model year of the vehicle                                   |
| `vehicle_type`      | Vehicle type: "car", "cuv", "suv", "pickup", "minivan"      |
| `avg_price`         | Average listing price (USD)                                 |
| `n_listings`        | Number of listings                                          |
| `n_make_model_year` | Number of unique make-model-year combinations in this state |

## Source

Computed from new vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(price_trends_new)

head(price_trends_new)
#> # A tibble: 6 × 7
#>   listing_year state  year vehicle_type avg_price n_listings n_make_model_year
#>          <dbl> <chr> <dbl> <chr>            <dbl>      <int>             <int>
#> 1         2018 AK     2016 pickup          44916.          1               407
#> 2         2018 AK     2016 car             31867.          6               407
#> 3         2018 AK     2016 suv             57234.          1               407
#> 4         2018 AK     2017 car             35670.        359               407
#> 5         2018 AK     2017 cuv             42770.        230               407
#> 6         2018 AK     2017 minivan         40072.         25               407
```
