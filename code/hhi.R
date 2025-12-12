# Load functions, libraries, and other settings
source(here::here("code", "0-setup.R"))

font <- "Arial"
col_red <- "#FF0000"
col_blue <- "#0000FF"

# Import counts data to compute HHI

counts_total_18 <- open_dataset(here(
  'data_local',
  'counts-2018',
  'counts_30.parquet'
))

counts_total_24 <- open_dataset(here(
  'data_local',
  'counts-2024',
  'counts_30.parquet'
))

get_hhi <- function(counts, var) {
  result <- counts %>%
    group_by(GEOID, powertrain, {{ var }}) %>%
    summarise(n = sum(n)) %>%
    ungroup() %>%
    collect() %>%
    group_by(GEOID, powertrain) %>%
    mutate(total = sum(n)) %>%
    ungroup() %>%
    mutate(
      p = n / total,
      p2 = p^2
    ) %>%
    group_by(GEOID, powertrain) %>%
    summarise(hhi = sum(p2))
  return(result)
}

summarise_hhi <- function(hhi) {
  hhi %>%
    group_by(powertrain, year) %>%
    summarise(
      median = median(hhi),
      q25 = quantile(hhi, 0.25),
      q75 = quantile(hhi, 0.75),
      IQR = IQR(hhi),
      upper = q75 + 1.5 * IQR,
      lower = q25 - 1.5 * IQR
    )
}

# Compute HHIs

hhi_make <- bind_rows(
  get_hhi(counts_total_18, make) %>%
    mutate(year = "2018"),
  get_hhi(counts_total_24, make) %>%
    mutate(year = "2024")
)

hhi_type <- bind_rows(
  get_hhi(counts_total_18, vehicle_type) %>%
    mutate(year = "2018"),
  get_hhi(counts_total_24, vehicle_type) %>%
    mutate(year = "2024")
)

hhi_price <- bind_rows(
  get_hhi(counts_total_18, price_bin) %>%
    mutate(year = "2018"),
  get_hhi(counts_total_24, price_bin) %>%
    mutate(year = "2024")
)

write_csv(
  summarise_hhi(hhi_make),
  here('data', 'hhi_make.csv')
)

write_csv(
  summarise_hhi(hhi_type),
  here('data', 'hhi_type.csv')
)

write_csv(
  summarise_hhi(hhi_price),
  here('data', 'hhi_price.csv')
)

# ggplots ----

hhi_make %>%
  clean_factors_powertrain() %>%
  ggplot() +
  geom_boxplot(
    aes(
      x = hhi,
      y = powertrain,
      fill = year
    ),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(
    breaks = seq(0, 1, 0.2),
    limits = c(0, 1)
  ) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Powertrain',
    fill = 'Year',
    title = 'Vehicle brand HHI by powertrain',
    subtitle = 'Higher number indicates greater concentration by brand'
  )

hhi_type %>%
  clean_factors_powertrain() %>%
  ggplot() +
  geom_boxplot(
    aes(
      x = hhi,
      y = powertrain,
      fill = year
    ),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(
    breaks = seq(0, 1, 0.2),
    limits = c(0, 1)
  ) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Powertrain',
    fill = 'Year',
    title = 'Vehicle type HHI by powertrain',
    subtitle = 'Higher number indicates greater concentration by brand'
  )

hhi_price %>%
  clean_factors_powertrain() %>%
  ggplot() +
  geom_boxplot(
    aes(
      x = hhi,
      y = powertrain,
      fill = year
    ),
    width = 0.5,
    outlier.shape = NA
  ) +
  scale_x_continuous(
    breaks = seq(0, 1, 0.2),
    limits = c(0, 1)
  ) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme_minimal_vgrid(font_family = font, font_size = 16) +
  theme(
    strip.background = element_rect("grey80"),
    plot.title.position = "plot",
    panel.background = element_rect(fill = 'white', color = NA),
    plot.background = element_rect(fill = 'white', color = NA)
  ) +
  scale_fill_manual(values = c(col_red, col_blue)) +
  panel_border() +
  labs(
    x = 'HHI',
    y = 'Powertrain',
    fill = 'Year',
    title = 'Price bin HHI by powertrain',
    subtitle = 'Higher number indicates greater concentration by brand'
  )
