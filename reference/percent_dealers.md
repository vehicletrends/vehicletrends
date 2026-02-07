# Percentage of dealers with at least one listing by variable pairs

Percentage of dealers that have at least one listing for each
combination of two grouping variables, computed across all listing years
and inventory types. Three variable-pair combinations are included:
powertrain by vehicle type, powertrain by price bin, and vehicle type by
price bin.

## Usage

``` r
data(percent_dealers)
```

## Format

A data frame with 7 variables:

|                  |                                                                                    |
|------------------|------------------------------------------------------------------------------------|
| Variable         | Description                                                                        |
| `listing_year`   | Year of the vehicle listing (2018–2024)                                            |
| `inventory_type` | Inventory type: "New" or "Used"                                                    |
| `group_var`      | Name of the grouping variable: "powertrain", "vehicle_type", or "price_bin"        |
| `group_level`    | Level of the grouping variable (e.g., "Gasoline", "Car", "\$30k-\$40k")            |
| `category_var`   | Name of the category variable: "powertrain", "vehicle_type", or "price_bin"        |
| `category_level` | Level of the category variable                                                     |
| `p`              | Proportion of dealers with at least one listing in this group-category combination |

## Source

Computed from vehicle listings data from
[Marketcheck](https://www.marketcheck.com/).

## Examples

``` r
data(percent_dealers)

head(percent_dealers)
#> # A tibble: 6 × 7
#>   listing_year inventory_type group_var  group_level category_var category_level
#>          <dbl> <chr>          <chr>      <chr>       <chr>        <chr>         
#> 1         2019 New            powertrain Battery El… vehicle_type Car           
#> 2         2020 New            powertrain Battery El… vehicle_type Car           
#> 3         2021 New            powertrain Battery El… vehicle_type Car           
#> 4         2018 New            powertrain Battery El… vehicle_type Car           
#> 5         2018 New            powertrain Battery El… vehicle_type Minivan       
#> 6         2021 New            powertrain Battery El… vehicle_type CUV           
#> # ℹ 1 more variable: p <dbl>
```
