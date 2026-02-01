# Note: "Roboto Condensed" font must be installed on the machine
library(ggplot2)
library(dplyr)
library(sf)
library(Cairo)

# Function to calculate hexagon vertices
deg2rad <- function(deg) {
  return(deg * (pi / 180))
}

hexagon_vertices <- function(center_x, center_y, radius) {
  angles_deg <- seq(90, -270, by = -60)
  angles_rad <- deg2rad(angles_deg)
  x <- center_x + radius * cos(angles_rad)
  y <- center_y + radius * sin(angles_rad)
  return(data.frame(x = x, y = y))
}

# Hex parameters
radius <- 3
hex <- round(hexagon_vertices(0, 0, radius), 6)

# Create hex as sf polygon (for clipping)
hex_matrix <- as.matrix(rbind(hex, hex[1, ]))
hex_poly <- st_sfc(st_polygon(list(hex_matrix)))

# Colors
col_bg <- "#F0F4F8"
col_border <- "#2D5F8A"
col_text <- "#1B2A4A"
col_grid <- "#D5DDE6"

# Line colors for each powertrain
line_colors <- c(
  "Gasoline" = "#D97706",
  "Hybrid Electric (HEV)" = "#059669",
  "Battery Electric (BEV)" = "#2563EB",
  "Plug-In Hybrid Electric (PHEV)" = "#7C3AED",
  "Diesel" = "#DC2626"
)

# --- Prepare real VMT data ---
data("vmt_age", package = "vehicletrends")

# Helper function to apply loess smoothing
smooth_group <- function(df, span = 0.5) {
  if (nrow(df) < 10) {
    df$miles_smooth <- df$miles
    return(df)
  }
  tryCatch(
    {
      fit <- suppressWarnings(loess(miles ~ age_years, data = df, span = span))
      df$miles_smooth <- predict(fit)
      df
    },
    error = function(e) {
      df$miles_smooth <- df$miles
      df
    }
  )
}

chart_data <- vmt_age |>
  mutate(age_years = age_bin / 12) |>
  filter(
    quantile == 50,
    vehicle_type == "All",
    powertrain %in% names(line_colors)
  ) |>
  group_by(powertrain) |>
  group_modify(~ smooth_group(.x)) |>
  ungroup()

# Scale data to fill the full hex area
x_range <- range(chart_data$age_years, na.rm = TRUE)
y_range <- range(chart_data$miles_smooth, na.rm = TRUE)

# Map to span wider than hex so lines fill edge-to-edge
chart_data <- chart_data |>
  mutate(
    x_scaled = -2.8 + 5.6 * (age_years - x_range[1]) / diff(x_range),
    y_scaled = -2.8 + 5.6 * (miles_smooth - y_range[1]) / diff(y_range)
  )

# --- Clip trend lines to hex ---
chart_lines_sf <- chart_data |>
  arrange(powertrain, age_years) |>
  group_by(powertrain) |>
  summarise(
    geometry = st_sfc(st_linestring(cbind(x_scaled, y_scaled))),
    .groups = "drop"
  ) |>
  st_as_sf() |>
  st_intersection(hex_poly)

# --- Clip grid lines to hex ---
grid_xs <- seq(-2.5, 2.5, by = 1.0)
grid_ys <- seq(-2.5, 2.5, by = 1.0)

grid_v_lines <- lapply(grid_xs, function(x) {
  st_linestring(cbind(c(x, x), c(-4, 4)))
})
grid_h_lines <- lapply(grid_ys, function(y) {
  st_linestring(cbind(c(-4, 4), c(y, y)))
})

grid_sf <- st_sf(
  geometry = st_sfc(c(grid_v_lines, grid_h_lines))
) |>
  st_intersection(hex_poly)

# --- Build plot ---
logo <- ggplot() +
  # Hex background fill
  geom_polygon(
    data = hex,
    aes(x = x, y = y),
    fill = col_bg,
    color = NA
  ) +
  # Clipped grid lines
  geom_sf(
    data = grid_sf,
    color = col_grid,
    linewidth = 0.3
  ) +
  # Clipped VMT trend lines
  geom_sf(
    data = chart_lines_sf,
    aes(color = powertrain),
    linewidth = 1.4,
    alpha = 0.85
  ) +
  scale_color_manual(values = line_colors) +
  # Hex border (on top)
  geom_polygon(
    data = hex,
    aes(x = x, y = y),
    fill = NA,
    color = col_border,
    linewidth = 3
  ) +
  # Package name (along bottom-right hex edge, slope = 30 degrees)
  annotate(
    "text",
    x = 1.15,
    y = -2.0,
    label = "vehicletrends",
    color = col_text,
    size = 10,
    fontface = "bold",
    family = "Roboto Condensed",
    angle = 30
  ) +
  coord_sf(datum = NA) +
  theme_void() +
  guides(color = "none") +
  theme(
    plot.background = element_rect(fill = "transparent", colour = NA),
    panel.background = element_rect(fill = "transparent", colour = NA)
  )

ggsave(
  here::here("man", "figures", "logo.pdf"),
  logo,
  height = 6,
  width = 6,
  bg = "transparent",
  device = cairo_pdf
)
renderthis::to_png(
  here::here("man", "figures", "logo.pdf"),
  here::here("man", "figures", "logo.png"),
  density = 300
)
