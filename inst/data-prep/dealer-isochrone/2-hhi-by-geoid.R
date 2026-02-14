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

# Create output directories if they don't exist
counts_root <- 'data-local'
iso <- isochrone_min # Global var in 0setup.R
output_dir_pt <- file.path(counts_root, paste0("hhi_pt_", iso))
output_dir_vt <- file.path(counts_root, paste0("hhi_vt_", iso))
output_dir_pb <- file.path(counts_root, paste0("hhi_pb_", iso))
make_dir(output_dir_pt)
make_dir(output_dir_vt)
make_dir(output_dir_pb)

# Compute HHI for a given grouping variable and diversity variable
get_hhi <- function(dt, group, var) {
  counts <- dt[, .(n = sum(n)), by = c(group, "listing_year", var)]
  counts[, total := sum(n), by = c(group, "listing_year")]
  counts[, .(hhi = sum((n / total)^2)), by = c(group, "listing_year")]
}

# Compute HHI by a grouping variable (diversity of the other variables)
# group: one of "powertrain", "vehicle_type", "price_bin"
# Returns HHI for each of the other variables, merged into one data.table
all_vars <- c("make", "powertrain", "vehicle_type", "price_bin")
compute_hhi <- function(dt, group, geoid) {
  vars <- setdiff(all_vars, group)
  join_on <- c(group, "listing_year")
  hhi <- get_hhi(dt, group, vars[1])
  setnames(hhi, "hhi", paste0("hhi_", vars[1]))
  for (v in vars[-1]) {
    hhi_v <- get_hhi(dt, group, v)
    setnames(hhi_v, "hhi", paste0("hhi_", v))
    hhi <- hhi[hhi_v, on = join_on]
  }
  hhi[, GEOID := geoid]
  return(hhi)
}

# Load dealer dataset for selected isochrone
dealers_ds <- open_dataset(here::here(
  'data-local',
  paste0('dealers_in_', iso, '_min.parquet')
))

# Get all unique GEOIDs from the tracts dataset
coords_tract <- get_coords_tract()
geoids <- coords_tract$GEOID

# Check for already processed GEOIDs
# Set force_reprocess = TRUE to reprocess all GEOIDs (overwrite existing)
# Set force_reprocess = FALSE to only process remaining GEOIDs (resume mode)
force_reprocess <- FALSE

# Get list of already processed GEOIDs
if (!force_reprocess && dir.exists(output_dir_pt)) {
  existing_partitions <- list.files(
    output_dir_pt,
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
  dealer_ids <- dealers_ds %>%
    filter(GEOID == geoid) %>%
    pull(dealer_id, as_vector = TRUE)

  temp <- dealer_counts[dealer_id %in% dealer_ids, ]
  write_parquet(
    compute_hhi(temp, "powertrain", geoid),
    file.path(output_dir_pt, paste0(geoid, '.parquet'))
  )
  write_parquet(
    compute_hhi(temp, "vehicle_type", geoid),
    file.path(output_dir_vt, paste0(geoid, '.parquet'))
  )
  write_parquet(
    compute_hhi(temp, "price_bin", geoid),
    file.path(output_dir_pb, paste0(geoid, '.parquet'))
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

open_dataset(output_dir_pt) %>%
  write_parquet(file.path(counts_root, paste0("hhi_pt_", iso, ".parquet")))

open_dataset(output_dir_vt) %>%
  write_parquet(file.path(counts_root, paste0("hhi_vt_", iso, ".parquet")))

open_dataset(output_dir_pb) %>%
  write_parquet(file.path(counts_root, paste0("hhi_pb_", iso, ".parquet")))
