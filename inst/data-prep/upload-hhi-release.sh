#!/bin/bash
# Upload raw HHI parquet files to a GitHub release.
# These files are in data-local/ (gitignored) and are uploaded as release assets.
# Run from the package root directory.
#
# To update an existing release, first delete it:
#   gh release delete data-v1 --yes
# Then re-run this script.

gh release create data-v1 \
  data-local/hhi_pt_60.parquet \
  data-local/hhi_vt_60.parquet \
  data-local/hhi_pb_60.parquet \
  --title "HHI data by census tract" \
  --notes "Raw HHI parquet files computed per census tract using a 60-minute drive time isochrone. The names are by the grouping variable: pt = powertrain, vt = vehicle_type (body style), pb = price_bin

Download URLs:
- https://github.com/vehicletrends/vehicletrends/releases/download/data-v1/hhi_pt_60.parquet
- https://github.com/vehicletrends/vehicletrends/releases/download/data-v1/hhi_vt_60.parquet
- https://github.com/vehicletrends/vehicletrends/releases/download/data-v1/hhi_pb_60.parquet"
