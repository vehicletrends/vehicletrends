library(tigris)
library(sf)
library(dplyr)

# Generate simplified US states GeoJSON with Alaska/Hawaii shifted as insets
# Uses tigris::shift_geometry() for proper Albers USA projection layout
# Output is used by the registrations shinylive app on the dashboard

us_sf <- tigris::states(class = "sf", cb = TRUE) |>
  shift_geometry() |>
  filter(as.numeric(GEOID) < 60) |>  # Exclude territories (Puerto Rico, etc.)
  select(name = NAME, geometry)

# Simplify geometry for smaller file size (~176 KB vs ~15 MB)
us_sf <- st_simplify(us_sf, dTolerance = 5000)

sf::st_write(
  us_sf,
  here::here("data-raw", "us-states-shifted.geojson"),
  driver = "GeoJSON",
  delete_dsn = TRUE
)
