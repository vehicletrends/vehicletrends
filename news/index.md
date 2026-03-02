# Changelog

## vehicletrends 0.0.5

- Renamed `hhi_local` to `hhi_local_summary` and `p_local` to
  `p_local_summary` to better reflect that these datasets contain
  summary statistics (mean, median, IQR, etc.) computed across census
  tracts, not the tract-level values themselves.
- Updated `@source` links in documentation to point to
  census-tract-level parquet files hosted on Cloudflare R2.

## vehicletrends 0.0.4

- Updated HHI data fixing error in 2025 year, and changed the name to
  `hhi_local`.
- Added percentage of listings data at the census tract level and
  exported it as `p_local`.

## vehicletrends 0.0.3

- Added HHI data.

## vehicletrends 0.0.2

- All package data frames updated to include 2018-2025 data.

## vehicletrends 0.0.1

- Added a `NEWS.md` file to track changes to the package.
- Initial version of the package.
