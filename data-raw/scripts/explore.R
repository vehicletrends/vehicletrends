source(here::here("data-raw", "scripts", "0setup.R"))

ds <- load_ds()

ds %>%
  filter(price <= 100000) %>%
  filter(powertrain == 'bev') %>%
  filter(vehicle_type == 'car') %>%
  filter(inventory_type == 'new') %>%
  select(year, price, range) %>%
  collect() %>%
  ggplot(
    aes(
      x = range,
      y = price
    )
  ) +
  geom_point() +
  geom_smooth(se = FALSE, method = 'lm') +
  facet_wrap(vars(year))


ds %>%
  filter(price <= 30000) %>%
  filter(powertrain == 'bev') %>%
  filter(vehicle_type == 'cuv') %>%
  filter(inventory_type == 'new') %>%
  distinct(make, model, range) %>%
  collect()
