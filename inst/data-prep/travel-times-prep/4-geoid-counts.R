# Load functions, libraries, and other settings
source(here::here("code", "0-setup.R"))

listings_ds <- open_dataset(here::here('data', 'listings_2018_new.parquet'))

# Create output directory if it doesn't exist
output_dir_30 <- here::here("data", "counts_30")
output_dir_60 <- here::here("data", "counts_60")
output_dir_90 <- here::here("data", "counts_90")
make_dir(output_dir_30)
make_dir(output_dir_60)
make_dir(output_dir_90)

# Load in datasets (keep these as datasets, don't collect)
dealers_ds_30 <- open_dataset(here::here('data', 'dealers_in_30_min.parquet'))
dealers_ds_60 <- open_dataset(here::here('data', 'dealers_in_60_min.parquet'))
dealers_ds_90 <- open_dataset(here::here('data', 'dealers_in_90_min.parquet'))
nrel_dt <- open_dataset(here::here("data", "nrel_data_budget.parquet")) %>%
  filter(!is.na(budget), !is.na(pop_over_25), !is.na(income)) %>%
  collect()
setkey(nrel_dt, GEOID) # For faster lookup

# Get all unique GEOIDs from the tracts dataset
geoids <- unique(nrel_dt$GEOID)

# Check for already processed GEOIDs
# Set force_reprocess = TRUE to reprocess all GEOIDs (overwrite existing)
# Set force_reprocess = FALSE to only process remaining GEOIDs (resume mode)
force_reprocess <- FALSE

# Get list of already processed GEOIDs
if (!force_reprocess && dir.exists(output_dir_90)) {
  existing_partitions <- list.dirs(
    output_dir_90,
    full.names = FALSE,
    recursive = FALSE
  )
  existing_geoids <- gsub("GEOID=", "", existing_partitions)
  existing_geoids <- existing_geoids[existing_geoids != ""]

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
remaining_count <- length(remaining_geoids)

# remaining_geoids <- sample(remaining_geoids, 2000)

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

  # Write total counts for GEOID
  listings_ds %>%
    filter(dealer_id %in% dealer_ids_30) %>%
    count(price_bin, powertrain, vehicle_type, make) %>%
    mutate(GEOID = geoid) %>%
    write_dataset(
      path = output_dir_30,
      partitioning = 'GEOID'
    )
  listings_ds %>%
    filter(dealer_id %in% dealer_ids_60) %>%
    count(price_bin, powertrain, vehicle_type, make) %>%
    mutate(GEOID = geoid) %>%
    write_dataset(
      path = output_dir_60,
      partitioning = 'GEOID'
    )
  listings_ds %>%
    filter(dealer_id %in% dealer_ids_90) %>%
    count(price_bin, powertrain, vehicle_type, make) %>%
    mutate(GEOID = geoid) %>%
    write_dataset(
      path = output_dir_90,
      partitioning = 'GEOID'
    )
}
stop <- Sys.time()

# Print elapsed time
elapsed_time <- as.numeric(stop - start, units = "secs")
cat("Total time:", elapsed_time, "seconds\n")

# Estimated total time:
(length(geoids) / length(remaining_geoids)) * elapsed_time / 3600

# Merge into single parquet files

open_dataset(output_dir_30) %>%
  write_parquet(here::here("data", "counts-2018", "counts_30.parquet"))
open_dataset(output_dir_60) %>%
  write_parquet(here::here("data", "counts-2018", "counts_60.parquet"))
open_dataset(output_dir_90) %>%
  write_parquet(here::here("data", "counts-2018", "counts_90.parquet"))
