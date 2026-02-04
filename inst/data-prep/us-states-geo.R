library(tigris)
library(sf)
library(dplyr)
library(data.table)

# Generate simplified US states GeoJSON with Alaska/Hawaii shifted as insets
# Uses tigris::shift_geometry() for proper Albers USA projection layout
# Output is used by the registrations shinylive app on the dashboard

states_sf <- tigris::states(class = "sf", cb = TRUE)

us_sf <- states_sf |>
  shift_geometry() |>
  filter(as.numeric(GEOID) < 60) |> # Exclude territories (Puerto Rico, etc.)
  select(name = NAME, geometry)

# Simplify geometry for smaller file size (~176 KB vs ~15 MB)
us_sf <- st_simplify(us_sf, dTolerance = 5000)

sf::st_write(
  us_sf,
  here::here("data-raw", "us-states-shifted.geojson"),
  driver = "GeoJSON",
  delete_dsn = TRUE
)

# Get census tract centroids for all US states

# Get state FIPS codes
state_fips <- states_sf %>%
  filter(as.numeric(GEOID) < 60) %>% # Exclude territories
  pull(GEOID)

# Initialize an empty list to store tract data
all_tracts_list <- list()

# Loop through each state to get tracts
# Use a subset of states for faster testing/development
# For full run, use `state_fips` instead of `head(state_fips)`
for (fips in state_fips) {
  message("Getting tracts for state: ", fips)
  tryCatch(
    {
      tracts_sf_state <- tigris::tracts(
        state = fips,
        cb = TRUE,
        year = 2020
      )
      all_tracts_list[[fips]] <- tracts_sf_state
    },
    error = function(e) {
      warning(
        "Could not retrieve tracts for state FIPS ",
        fips,
        ": ",
        e$message
      )
    }
  )
}

# Combine all tracts
tract_sf <- bind_rows(all_tracts_list)

# Compute centroids and extract coordinates
tract_dt <- tract_sf %>%
  st_centroid() %>%
  mutate(
    lat_c = st_coordinates(geometry)[, "Y"],
    lng_c = st_coordinates(geometry)[, "X"]
  ) %>%
  st_drop_geometry() %>%
  select(GEOID, lat_c, lng_c) %>% # Select only necessary columns
  as.data.table()

# Save to data-raw as CSV
data.table::fwrite(
  tract_dt,
  here::here("data-raw", "tract_dt.csv")
)
