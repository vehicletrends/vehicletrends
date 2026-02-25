tictoc::tic() # Start timer

source(here::here('code', '0-setup.R'))
library(osrm)

# Function to process a single GEOID
process_geoid <- function(geoid, df, chunk_size = 100) {
  tryCatch(
    {
      # Filter data for this GEOID
      geoid_data <- df[GEOID == geoid]

      # Process in chunks of chunk_size
      n_rows <- nrow(geoid_data)
      n_chunks <- ceiling(n_rows / chunk_size)

      # Initialize result columns
      geoid_data$duration_minutes <- NA_real_
      geoid_data$distance_trip_km <- NA_real_
      geoid_data$attempt_successful <- FALSE

      # Rename distance to distance_linear
      geoid_data <- geoid_data %>%
        rename(distance_linear = distance)

      for (i in 1:n_chunks) {
        start_idx <- (i - 1) * chunk_size + 1
        end_idx <- min(i * chunk_size, n_rows)

        chunk_data <- geoid_data[start_idx:end_idx, ]

        # Create source and destination matrices for chunk
        src <- data.frame(
          lon = chunk_data$lng_c,
          lat = chunk_data$lat_c
        )

        dst <- data.frame(
          lon = chunk_data$lng_d,
          lat = chunk_data$lat_d
        )

        # Get travel times for chunk
        travel_times <- osrmTable(
          src = src,
          dst = dst,
          measure = c("duration", "distance")
        )

        # Add results to chunk
        geoid_data$duration_minutes[start_idx:end_idx] <- diag(
          travel_times$durations
        )
        geoid_data$distance_trip_km[start_idx:end_idx] <- diag(
          travel_times$distances
        ) /
          1000
        geoid_data$attempt_successful[
          start_idx:end_idx
        ] <- !is.na(geoid_data$duration_minutes[start_idx:end_idx])
      }

      # Save results for this GEOID using write_dataset with partitioning
      write_dataset(
        geoid_data,
        path = output_dir,
        partitioning = "GEOID",
        format = "parquet"
      )

      invisible()
    },
    error = function(e) {
      # On error, save the data with NA values
      geoid_data <- df[df$GEOID == geoid, ]
      geoid_data$duration_minutes <- NA_real_
      geoid_data$distance_trip_km <- NA_real_
      geoid_data$attempt_successful <- FALSE

      # Save failed results using write_dataset with partitioning
      write_dataset(
        geoid_data,
        path = output_dir,
        partitioning = "GEOID",
        format = "parquet"
      )

      invisible()
    }
  )
}

# Read in coords data

coords_dealer <- get_all_dealer_coords()
coords_tract <- get_coords_tract()

# Get unique set of pairs ----

pairs <- read_parquet(
  here('data', 'travel_times', 'dealer_distances.parquet')
) %>%
  filter(inventory_type == 'new') %>%
  distinct(dealer_id, GEOID, distance) %>%
  # Join on coords
  left_join(coords_tract, by = 'GEOID') %>%
  left_join(coords_dealer, by = 'dealer_id')

nrow(pairs)

# Process all the pairs ----

output_dir <- file.path("temp")

# Create directory structure if it doesn't exist
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# Get all unique GEOIDs
geoids <- unique(pairs$GEOID)
# geoids <- sample(geoids, 50) # For testing

# Filter out GEOIDs that have already been processed
geoids_to_process <- geoids[
  !sapply(geoids, function(geoid) {
    geoid_output_path <- file.path(output_dir, paste0("GEOID=", geoid))
    dir.exists(geoid_output_path)
  })
]

length(geoids_to_process)

# Process GEOIDs in series - can take ~15 hours (!!)
# lapply(
#   geoids_to_process,
#   process_geoid,
#   df = pairs
# )

# Process GEOIDs in parallel
# **WARNING: This takes ~3-4 hours**

cl <- makeCluster(6)

# Load libraries on each worker
clusterEvalQ(cl, {
  invisible(source(here::here('code', '0-setup.R')))
})

# Export necessary objects to workers
clusterExport(cl, c("output_dir", "pairs", "process_geoid"))

# Run parallel processing
invisible(parLapply(cl, geoids_to_process, process_geoid, df = pairs))

# Clean up
stopCluster(cl)

# Combine ----

# Once all batches are done, combine them

df <- open_dataset(output_dir) %>%
  collect()

# Check for any failures
failed <- df %>%
  filter(attempt_successful == FALSE)

nrow(failed)

cat(
  "Number of failed attempts: ",
  scales::comma(nrow(failed)),
  " out of ",
  scales::comma(nrow(df)),
  "\n",
  "Percent failed: ",
  scales::percent(nrow(failed) / nrow(df), accuracy = 0.001),
  sep = ''
)

# Final merge
df %>%
  select(
    GEOID,
    dealer_id,
    duration_min = duration_minutes,
    distance_trip_km,
    distance_linear
  ) %>%
  distinct() %>%
  write_parquet(
    here::here('data', 'travel_times', 'dealer_times.parquet')
  )

tictoc::toc() # Stop timer

# 17427.418 sec elapsed, 4.84 hours
