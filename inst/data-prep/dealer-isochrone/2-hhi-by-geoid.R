source(here::here("inst", "data-prep", "0setup.R"))

listings_ds <- load_ds_prices()

# # Make initial count of all vehicles by dealer_id
# # Do this only once then comment it out
# listings_ds %>%
#   count(dealer_id, listing_year, price_bin, powertrain, vehicle_type, make) %>%
#   write_parquet(here::here("data-local", "dealer_counts.parquet"))

# Make initial count of all vehicles by dealer_id
dealer_counts <- read_parquet(here::here(
  "data-local",
  "dealer_counts.parquet"
))
setDT(dealer_counts, key = 'dealer_id')

# Keep only the first and last years for size
# dealer_counts <- dealer_counts[listing_year %in% c(2018, 2025), ]

# Create output directory if it doesn't exist
counts_root <- 'data-local'
output_dir_30 <- file.path(counts_root, "hhi_30")
output_dir_60 <- file.path(counts_root, "hhi_60")
output_dir_90 <- file.path(counts_root, "hhi_90")
make_dir(output_dir_30)
make_dir(output_dir_60)
make_dir(output_dir_90)

# Compute HHI for a given variable from a data.table of counts
# dt must have columns: powertrain, listing_year, n, and the column named by `var`
get_hhi <- function(dt, var) {
  counts <- dt[, .(n = sum(n)), by = c("powertrain", "listing_year", var)]
  counts[, total := sum(n), by = .(powertrain, listing_year)]
  counts[, .(hhi = sum((n / total)^2)), by = .(powertrain, listing_year)]
}

# Compute all three HHI types and merge into a single data.table
compute_hhi <- function(dt, geoid) {
  hhi_make <- get_hhi(dt, "make")
  setnames(hhi_make, "hhi", "hhi_make")
  hhi_type <- get_hhi(dt, "vehicle_type")
  setnames(hhi_type, "hhi", "hhi_type")
  hhi_price <- get_hhi(dt, "price_bin")
  setnames(hhi_price, "hhi", "hhi_price")
  hhi <- hhi_make[hhi_type, on = .(powertrain, listing_year)]
  hhi <- hhi[hhi_price, on = .(powertrain, listing_year)]
  hhi[, GEOID := geoid]
  return(hhi)
}

# Load in datasets (keep these as datasets, don't collect)
dealers_ds_30 <- open_dataset(here::here(
  'data-local',
  'dealers_in_30_min.parquet'
))
dealers_ds_60 <- open_dataset(here::here(
  'data-local',
  'dealers_in_60_min.parquet'
))
dealers_ds_90 <- open_dataset(here::here(
  'data-local',
  'dealers_in_90_min.parquet'
))

# Get all unique GEOIDs from the tracts dataset
coords_tract <- get_coords_tract()
geoids <- coords_tract$GEOID

# Check for already processed GEOIDs
# Set force_reprocess = TRUE to reprocess all GEOIDs (overwrite existing)
# Set force_reprocess = FALSE to only process remaining GEOIDs (resume mode)
force_reprocess <- FALSE

# Get list of already processed GEOIDs
if (!force_reprocess && dir.exists(output_dir_90)) {
  existing_partitions <- list.files(
    output_dir_90,
    full.names = FALSE
  )
  existing_geoids <- gsub(".parquet", "", existing_partitions)

  print(paste("Found", length(existing_geoids), "already processed GEOIDs"))

  # Filter out already processed GEOIDs
  remaining_geoids <- setdiff(geoids, existing_geoids)
  print(paste("Remaining GEOIDs to process:", length(remaining_geoids)))
} else {
  remaining_geoids <- geoids
  existing_geoids <- character(0)
  print(
    "Starting fresh - no existing partitions found or force_reprocess = TRUE"
  )
}

# Process each remaining GEOID one at a time
total_geoids <- length(geoids)
cat('N geoids left:', length(remaining_geoids))

# remaining_geoids <- sample(remaining_geoids, 100)

start <- Sys.time()
for (i in seq_along(remaining_geoids)) {
  geoid <- remaining_geoids[i]

  # Get dealers for this GEOID
  dealer_ids_30 <- dealers_ds_30 %>%
    filter(GEOID == geoid) %>%
    pull(dealer_id, as_vector = TRUE)
  dealer_ids_60 <- dealers_ds_60 %>%
    filter(GEOID == geoid) %>%
    pull(dealer_id, as_vector = TRUE)
  dealer_ids_90 <- dealers_ds_90 %>%
    filter(GEOID == geoid) %>%
    pull(dealer_id, as_vector = TRUE)

  temp_30 <- dealer_counts[dealer_id %in% dealer_ids_30, ]
  write_parquet(
    compute_hhi(temp_30, geoid),
    file.path(output_dir_30, paste0(geoid, '.parquet'))
  )

  temp_60 <- dealer_counts[dealer_id %in% dealer_ids_60, ]
  write_parquet(
    compute_hhi(temp_60, geoid),
    file.path(output_dir_60, paste0(geoid, '.parquet'))
  )

  temp_90 <- dealer_counts[dealer_id %in% dealer_ids_90, ]
  write_parquet(
    compute_hhi(temp_90, geoid),
    file.path(output_dir_90, paste0(geoid, '.parquet'))
  )
}
stop <- Sys.time()

# 29567.49 seconds
# ~8-10 hours

# Print elapsed time
elapsed_time <- as.numeric(stop - start, units = "secs")
cat("Total time:", elapsed_time, "seconds\n")

# Estimated total time:
(length(geoids) / length(remaining_geoids)) * elapsed_time / 3600

# Merge into single parquet files

open_dataset(output_dir_30) %>%
  write_parquet(file.path(counts_root, "hhi_30.parquet"))
open_dataset(output_dir_60) %>%
  write_parquet(file.path(counts_root, "hhi_60.parquet"))
open_dataset(output_dir_90) %>%
  write_parquet(file.path(counts_root, "hhi_90.parquet"))
