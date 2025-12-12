# Load functions, libraries, and other settings
source(here::here("code", "0-setup.R"))

# Some plot colors
color_cv <- "grey42" # 'indianred1'
color_ev <- "#00BA38" # "forestgreen"
color_tesla <- "#619CFF" # "dodgerblue"

# Price depreciation ----

quantiles_rr <- read_parquet(
    here::here('data', 'quantiles_miles.parquet')
)
quantiles_bev <- read_parquet(
    here::here('data', 'quantiles_miles_bev.parquet')
)

# Annual Mileage (Annual VMT) ----

quantiles_miles <- read_parquet(
    here::here('data', 'quantiles_miles.parquet')
) %>% 
    mutate(age_years = age_months / 12) %>% 
    filter(age_years > 2)

quantiles_bev <- read_parquet(
    here::here('data', 'quantiles_miles_bev.parquet')
)

# Plot of all powertrain-type combos 

quantiles_miles %>%
    ggplot() +
    geom_ribbon(
        aes(
            x = age_years,
            ymin = miles25,
            ymax = miles75
        ),
        fill = color_cv,
        alpha = 0.25) +
    geom_line(
        aes(
            x = age_years,
            y = miles50
        ),
        color = color_cv
    ) +
    facet_grid(vehicle_type ~ powertrain) +
    theme_bw()

# Daily Mileage (DVMT) ----

quantiles_dvmt <- read_parquet(
    here::here('data', 'quantiles_dvmt.parquet')
)

# Compare by vehicle_type

quantiles_dvmt %>%
    filter(powertrain != 'all') %>%
    ggplot() +
    geom_line(aes(x = dvmt, y = quantile, color = powertrain)) +
    facet_wrap(vars(vehicle_type)) +
    geom_line(
        data = quantiles_dvmt %>%
            filter(powertrain == 'all') %>% 
            select(quantile, dvmt),
        aes(x = dvmt, y = quantile), 
        color = 'black'
    ) +
    theme_bw() +
    theme(legend.position = 'right') +
    labs(
        title = "CDF of daily VMT",
        subtitle = "Black line is all vehicles aggregated, which is dominated by conventional vehicles",
        x = 'DVMT',
        y = '%'
    )

# Compare by powertrain

quantiles_dvmt %>%
    filter(powertrain != 'all') %>%
    ggplot() +
    geom_line(aes(x = dvmt, y = quantile, color = vehicle_type)) +
    facet_wrap(vars(powertrain)) +
    geom_line(
        data = quantiles_dvmt %>%
            filter(powertrain == 'all') %>% 
            select(quantile, dvmt),
        aes(x = dvmt, y = quantile), 
        color = 'black'
    ) +
    theme_bw() +
    theme(legend.position = 'right') +
    labs(
        title = "CDF of daily VMT",
        subtitle = "Black line is all vehicles aggregated, which is dominated by conventional vehicles",
        x = 'DVMT',
        y = '%'
    )
