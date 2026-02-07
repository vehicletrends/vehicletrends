source(here::here("inst", "data-prep", "0setup.R"))

# Using "multisession" instead of "multicore" for macOS compatibility
library(future)
library(furrr)
library(progressr)

# Calculate linear distance using lat and lng
linear_dist <- function(lat1, lon1, lat2, lon2) {
  R <- 6371 # Earth's radius in kilometers
  # Convert degrees to radians
  lat1 <- lat1 * pi / 180
  lon1 <- lon1 * pi / 180
  lat2 <- lat2 * pi / 180
  lon2 <- lon2 * pi / 180

  # Haversine formula
  dlat <- lat2 - lat1
  dlon <- lon2 - lon1
  a <- sin(dlat / 2)^2 + cos(lat1) * cos(lat2) * sin(dlon / 2)^2
  c <- 2 * atan2(sqrt(a), sqrt(1 - a))
  # Distance in kilometers
  return(R * c) # Distance in kilometers
}

# For a given census tract, find the distances to all the dealerships
get_distances <- function(tract, coords_dealer, distance_filter) {
  temp <- copy(coords_dealer)
  temp[,
    distance := linear_dist(
      lat_d,
      lng_d,
      tract$lat_c,
      tract$lng_c
    )
  ]
  temp <- temp[distance <= distance_filter]
  temp <- temp[order(distance), ]
  temp$GEOID <- tract$GEOID
  temp$lat_c <- tract$lat_c
  temp$lng_c <- tract$lng_c
  return(temp)
}

get_times <- function(dt, row) {
  # Add error handling
  tryCatch(
    {
      dt <- dt[row, ]
      src <- data.frame(lon = dt$lng_c, lat = dt$lat_c)
      dst <- data.frame(lon = dt$lng_d, lat = dt$lat_d)

      travel_times <- osrmTable(
        src = src,
        dst = dst,
        measure = c("duration")
      )

      # Check if the result is valid
      if (is.null(travel_times) || is.null(travel_times$durations)) {
        return(NA)
      }

      # Travel time (minutes)
      return(travel_times$durations)
    },
    error = function(e) {
      message("Error in get_times: ", e$message)
      return(NA)
    }
  )
}

# Find the closest dealer_id that is approximately time_threshold minutes away
find_closest_dealer_by_time <- function(distance_dt, time_threshold) {
  if (nrow(distance_dt) == 0) {
    return(NULL) # No dealerships within range
  }

  upper_bound <- nrow(distance_dt)
  lower_bound <- 1
  guess_row <- floor((upper_bound + lower_bound) / 2)

  # Define convergence criteria
  max_iterations <- 20
  epsilon <- 5 # Acceptable error in minutes

  iterations <- 0
  best_guess <- guess_row
  best_diff <- Inf

  while (iterations < max_iterations && upper_bound >= lower_bound) {
    iterations <- iterations + 1

    # Get the travel time for the current guess
    time <- get_times(distance_dt, guess_row)

    # Check if time is valid (not NA/NULL)
    if (is.na(time) || is.null(time)) {
      # If we can't get a valid travel time, fall back to using
      # the linear distance as an approximation
      if (iterations == 1) {
        # For the first iteration, just return the first dealer
        # as a fallback
        return(distance_dt[1, dealer_id])
      } else {
        # For subsequent iterations, use the best guess so far
        return(distance_dt[1:best_guess, dealer_id])
      }
    }

    # Update best guess if this is closer to the threshold
    time_diff <- abs(time - time_threshold)
    if (!is.na(time_diff) && time_diff < best_diff) {
      best_diff <- time_diff
      best_guess <- guess_row
    }

    # Convergence check
    if (!is.na(time_diff) && time_diff <= epsilon) {
      break # Close enough to threshold
    }

    # Binary search update
    if (!is.na(time) && time < time_threshold) {
      lower_bound <- guess_row + 1
    } else {
      upper_bound <- guess_row - 1
    }

    guess_row <- floor((upper_bound + lower_bound) / 2)
  }

  # Return all dealerships with equal or less distance than our best guess
  return(distance_dt[1:best_guess, dealer_id])
}

# Define the function to process a single tract
process_tract <- function(i, p = NULL) {
  # Progress reporting
  if (!is.null(p)) {
    p()
  }

  # Get distances to all dealerships within 200km
  distance_dt <- get_distances(
    coords_tract[i, ],
    coords_dealer,
    max(distance_filters)
  )

  for (j in 1:length(time_thresholds)) {
    # Find dealers within time threshold
    nearby_dealers <- find_closest_dealer_by_time(
      distance_dt[distance < distance_filters[j]],
      # distance_dt,
      time_thresholds[j]
    )

    # Return results
    if (!is.null(nearby_dealers)) {
      data.table(
        GEOID = coords_tract[i, ]$GEOID,
        dealer_id = nearby_dealers
      ) %>%
        write_dataset(
          here('data', paste0('dealers_in_', time_thresholds[j], '_min')),
          partitioning = 'GEOID'
        )
    }
  }
}

# Threshold settings
time_thresholds <- c(30, 60, 90) # minutes
distance_filters <- time_thresholds * 1.6 * 1.5

# Format the tesla data
coords_dealer <- get_all_dealer_coords()

# Format census tract data
coords_tract <- get_coords_tract()

# Parameters
max_tracts <- nrow(coords_tract) # Process all tracts, or limit for testing
num_cores <- 6

# Set up the future plan
plan(multisession, workers = num_cores)

cat("Running on", num_cores, "cores using future/furrr\n")

# Set up a progress reporting function
handlers(handler_progress(
  format = "[:bar] :percent :eta :message",
  width = 60
))

# Process using future_map instead of mclapply
tictoc::tic()

with_progress({
  p <- progressor(steps = max_tracts)

  # Using future_map from furrr
  # Added error handling at the map level29
  future_map(
    1:max_tracts,
    ~ tryCatch(
      process_tract(.x, p),
      error = function(e) {
        message("Error in future_map for index ", .x, ": ", e$message)
        return(NULL)
      }
    ),
    .options = furrr_options(seed = TRUE)
  )
})

tictoc::toc()

# 35987.037 sec elapsed
# 10 hours

# Combine results
for (time in time_thresholds) {
  open_dataset(here('data', paste0('dealers_in_', time, '_min'))) %>%
    write_parquet(
      here::here('data', paste0('dealers_in_', time, '_min.parquet'))
    )
}
