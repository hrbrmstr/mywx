#' Retrieve forecast data for a location
#'
#' This is a WIP. The data returned is in a sub-optimal format that requires conversion of
#' some data frame column values to numeric to use.
#'
#' You need a valid token either passed in to `mywx_api_token` or stored in the `MYWX_TOKEN`,
#' preferably in `~/.Renviron`.
#'
#' @md
#' @param location_id valid location id retrieved from one of the location helpers
#' @param start_date,end_date either character vectors in ISO 8601 format or `Date`-like
#'        objects. They both default to "today" if not specified
#' @param dataset_id the current only valid default, `FORECAST`, is pre-populated
#' @param data_category_id the current only valid default, `GENERAL` is pre-populated
#' @param mywx_api_token MET API token
#' @export
#' @examples \dontrun{
#' mywx_forecast("LOCATION:237", "2017-08-13", "2017-08-13")
#' mywx_forecast("LOCATION:237", "2017-08-01", "2017-08-13")
#' }
mywx_forecast <- function(location_id, start_date = Sys.Date(), end_date = Sys.Date(),
                          dataset_id = "FORECAST", data_category_id = "GENERAL",
                          mywx_api_token = Sys.getenv("MYWX_TOKEN")) {

  dataset_id <- match.arg(toupper(dataset_id), c("FORECAST"))
  data_category_id <- match.arg(toupper(data_category_id), c("GENERAL"))

  start_date <- as.character(as.Date(start_date))
  end_date <- as.character(as.Date(end_date))

  httr::GET(
    url = met_api_base_url,
    path="v2/data",
    query = list(
      datasetid = dataset_id,
      datacategoryid = data_category_id,
      locationid = location_id,
      start_date = start_date,
      end_date = end_date
    ),
    httr::add_headers(
      Authorization = sprintf("METToken %s", mywx_api_token)
    )
  ) -> res

  httr::stop_for_status(res)

  res <- httr::content(res, as="text", encoding="UTF-8")
  res <- jsonlite::fromJSON(res, flatten=TRUE)
  res <- res$results
  res <- tibble::as_tibble(res)
  res <- readr::type_convert(res, col_types = .met_api_forecast_cols)

  res

}
