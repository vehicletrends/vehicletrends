#' Vehicle production statistics by country and type
#'
#' This data frame contains annual data on vehicle production statistics by
#' country and type between the years 2006 and 2021 (inclusive) from the OICA.
#' Standard country / area codes come from the United Nations Statistics
#' Division. The table below shows a detailed description of each variable.
#'
#' @format
#' Variable | Description
#' -------- | ---------------------------------------------
#' `year`                     | Year (2006 - 2021)
#' `country`                  | Country name
#' `type`      | Vehicle type: pv = passenger vehicle, cv = commercial vehicle
#' `n`                        | Number of vehicles produced
#' `region`                   | Country region (continent)
#' `subregion`                | Country subregion
#' `intermediate_region`      | Country intermediate region
#' `least_developed`          | Dummy variable; is country least developed?
#' `land_locked_developing`   | Dummy variable; is country land-locked developing?
#' `small_island_developing`  | Dummy variable; is country small island developing?
#' `code_region`              | Country region code
#' `code_subregion`           | Country subregion code
#' `code_intermediate_region` | Country intermediate region code
#' `code_m49`                 | Country M49 code
#' `code_iso_alpha2`          | Country ISO alpha 2 code
#' `code_iso_alpha3`          | Country ISO alpha 3 code
#'
#' @docType data
#'
#' @usage data(production)
#'
#' @keywords datasets
#'
#' @source Raw data downloaded from the
#' \href{https://www.oica.net/}{Organisation Internationale des Constructeurs d'Automobiles (OICA)}
#' and the
#' \href{https://unstats.un.org/unsd/methodology/m49/overview/}{United Nations Statistics Division}
#'
#' @examples
#' data(production)
#'
#' head(production)
"production"
