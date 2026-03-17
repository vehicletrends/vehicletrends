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

dt <- ds %>%
  filter(make == 'nissan') %>%
  filter(model %in% c('leaf', 'versa sedan')) %>%
  filter(year == 2022) %>%
  filter(inventory_type == 'used') %>%
  select(price, miles, age_years, model) %>%
  collect()

dt %>%
  ggplot(aes(x = miles, y = price, color = model)) +
  geom_smooth(
    method = 'lm',
    se = FALSE
  ) +
  geom_point(size = 0.1)

model_leaf <- feols(
  miles ~ price,
  data = dt[model == 'leaf']
)
model_versa <- feols(
  miles ~ price,
  data = dt[model != 'leaf']
)

dt %>%
  group_by(model) %>%
  summarise(
    price = mean(price),
    miles = mean(miles),
    age = mean(age_years)
  )
