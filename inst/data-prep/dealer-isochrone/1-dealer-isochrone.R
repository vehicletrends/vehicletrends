source(here::here("inst", "data-prep", "0setup.R"))

# For a given census tract, find the distances to all the dealerships
# Avoids copy() by building a new data.table from vectors
get_distances <- function(tract, coords_dealer, distance_filter) {
  dists <- linear_dist(
    coords_dealer$lat_d,
    coords_dealer$lng_d,
    tract$lat_c,
    tract$lng_c
  )
  keep <- which(dists <= distance_filter)
  if (length(keep) == 0) {
    return(data.table(
      dealer_id = character(0),
      lat_d = numeric(0),
      lng_d = numeric(0),
      distance = numeric(0),
      GEOID = character(0),
      lat_c = numeric(0),
      lng_c = numeric(0)
    ))
  }
  ord <- order(dists[keep])
  data.table(
    dealer_id = coords_dealer$dealer_id[keep][ord],
    lat_d = coords_dealer$lat_d[keep][ord],
    lng_d = coords_dealer$lng_d[keep][ord],
    distance = dists[keep][ord],
    GEOID = tract$GEOID,
    lat_c = tract$lat_c,
    lng_c = tract$lng_c
  )
}

# Get travel time for a single (src, dst) pair, with optional caching
# by dealer_id to avoid redundant OSRM calls across thresholds
get_travel_time <- function(
  src_lat,
  src_lng,
  dst_lat,
  dst_lng,
  cache = NULL,
  cache_key = NULL
) {
  if (
    !is.null(cache) && !is.null(cache_key) && exists(cache_key, envir = cache)
  ) {
    return(get(cache_key, envir = cache))
  }

  time <- tryCatch(
    {
      result <- osrmTable(
        src = data.frame(lon = src_lng, lat = src_lat),
        dst = data.frame(lon = dst_lng, lat = dst_lat),
        measure = "duration"
      )
      if (is.null(result) || is.null(result$durations)) NA else result$durations
    },
    error = function(e) {
      NA
    }
  )

  if (!is.null(cache) && !is.null(cache_key)) {
    assign(cache_key, time, envir = cache)
  }

  return(time)
}

# Find the closest dealer_id that is approximately time_threshold minutes away
# Uses a travel time cache (keyed by dealer_id) so that OSRM results computed
# for one threshold can be reused when processing smaller thresholds.
find_closest_dealer_by_time <- function(
  distance_dt,
  time_threshold,
  time_cache = NULL
) {
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

    # Get the travel time for the current guess (uses cache if available)
    time <- get_travel_time(
      distance_dt$lat_c[guess_row],
      distance_dt$lng_c[guess_row],
      distance_dt$lat_d[guess_row],
      distance_dt$lng_d[guess_row],
      cache = time_cache,
      cache_key = distance_dt$dealer_id[guess_row]
    )

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

# Check if a GEOID already has output in all threshold directories
is_geoid_done <- function(geoid) {
  partition <- paste0("GEOID=", geoid)
  all(vapply(
    time_thresholds,
    function(time) {
      dir.exists(
        file.path(
          here('data-local', paste0('dealers_in_', time, '_min')),
          partition
        )
      )
    },
    logical(1)
  ))
}

# Define the function to process a single tract
process_tract <- function(i) {
  tract <- coords_tract[i, ]

  # Skip if already processed (resume support)
  if (is_geoid_done(tract$GEOID)) {
    return(NULL)
  }

  # Get distances to all dealerships within the largest filter
  distance_dt <- get_distances(
    tract,
    coords_dealer,
    max(distance_filters)
  )

  # Per-tract cache for OSRM travel times (keyed by dealer_id).
  # Processing thresholds largest-first maximises cache hits since
  # dealers queried for 90-min are often re-queried for 60 and 30-min.
  time_cache <- new.env(hash = TRUE, parent = emptyenv())

  for (j in rev(seq_along(time_thresholds))) {
    # Find dealers within time threshold
    nearby_dealers <- find_closest_dealer_by_time(
      distance_dt[distance < distance_filters[j]],
      time_thresholds[j],
      time_cache
    )

    # Write results (always write, even if empty, so resume can detect completion)
    data.table(
      GEOID = tract$GEOID,
      dealer_id = if (!is.null(nearby_dealers)) {
        nearby_dealers
      } else {
        NA_character_
      }
    ) %>%
      write_dataset(
        here('data-local', paste0('dealers_in_', time_thresholds[j], '_min')),
        partitioning = 'GEOID'
      )
  }
}

# Threshold settings
time_thresholds <- c(30, 60, 90) # minutes
distance_filters <- time_thresholds * 1.6 * 1.5
if (!isochrone_min %in% time_thresholds) {
  stop(
    "isochrone_min (",
    isochrone_min,
    ") is not in time_thresholds (",
    paste(time_thresholds, collapse = ", "),
    "). Add it to time_thresholds and re-run."
  )
}

# Get coordinates for dealers and census tracts
coords_dealer <- get_coords_dealer()
coords_tract <- get_coords_tract()

# Parameters
max_tracts <- nrow(coords_tract)
max_tracts <- 10
num_cores <- 6

tictoc::tic()

mclapply(
  1:max_tracts,
  function(i) {
    tryCatch(
      process_tract(i),
      error = function(e) NULL
    )
  },
  mc.cores = num_cores
)

tictoc::toc()

# Combine results into individual parquet files (filter out NA placeholders)
for (time in time_thresholds) {
  ds_dir <- here('data-local', paste0('dealers_in_', time, '_min'))
  if (dir.exists(ds_dir)) {
    open_dataset(ds_dir) %>%
      filter(!is.na(dealer_id)) %>%
      write_parquet(
        here::here('data-local', paste0('dealers_in_', time, '_min.parquet'))
      )
  }
}

# Summary: which GEOIDs are missing from output directories
all_geoids <- coords_tract$GEOID
missing_geoids <- all_geoids[!vapply(all_geoids, is_geoid_done, logical(1))]
cat(sprintf(
  "%d of %d GEOIDs processed. %d missing.\n",
  length(all_geoids) - length(missing_geoids),
  length(all_geoids),
  length(missing_geoids)
))
if (length(missing_geoids) > 0) {
  cat("Missing GEOIDs:\n")
  cat(missing_geoids, sep = "\n")
}
