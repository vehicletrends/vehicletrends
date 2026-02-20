# Share of listings by variable pairs and singular variables

Share of vehicle listings for combinations of grouping variables,
computed across all listing years and inventory types. Includes six
pairwise combinations (powertrain by vehicle type, powertrain by price
bin, vehicle type by powertrain, vehicle type by price bin, price bin by
powertrain, and price bin by vehicle type) plus three singular time
trends for powertrain, vehicle type, and price bin individually.

## Usage

``` r
data(percent_listings)
```

## Format

A tibble with 8 variables:

|                  |                                                                                                               |
|------------------|---------------------------------------------------------------------------------------------------------------|
| Variable         | Description                                                                                                   |
| `listing_year`   | Year of the vehicle listing (2018–2024)                                                                       |
| `inventory_type` | Inventory type: "New" or "Used"                                                                               |
| `group_var`      | Name of the grouping variable: "powertrain", "vehicle_type", or "price_bin"                                   |
| `group_level`    | Level of the grouping variable (e.g., "Gasoline", "Car", "\$30k-\$40k")                                       |
| `category_var`   | Name of the category variable: "powertrain", "vehicle_type", or "price_bin"; `NA` for singular time trends    |
| `category_level` | Level of the category variable; `NA` for singular time trends                                                 |
| `n`              | Number of listings in this group-category combination                                                         |
| `p`              | Proportion of listings within the group (sums to 1 within each listing year, inventory type, and group level) |

## Source

Computed from vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(percent_listings)

head(percent_listings)
#> # A tibble: 6 × 8
#>   listing_year inventory_type group_var  group_level category_var category_level
#>          <dbl> <chr>          <chr>      <chr>       <chr>        <chr>         
#> 1         2018 New            powertrain Battery El… vehicle_type Minivan       
#> 2         2025 New            powertrain Battery El… vehicle_type Minivan       
#> 3         2024 New            powertrain Battery El… vehicle_type Minivan       
#> 4         2024 New            powertrain Battery El… vehicle_type SUV           
#> 5         2025 New            powertrain Battery El… vehicle_type SUV           
#> 6         2023 New            powertrain Battery El… vehicle_type SUV           
#> # ℹ 2 more variables: n <int>, p <dbl>
```
