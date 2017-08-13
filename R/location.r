.loc_helper <- function(tok, id) {

  httr::GET(
    url = met_api_base_url,
    path="v2/locations",
    query = list(locationcategoryid = id),
    httr::add_headers(
      Authorization = sprintf("METToken %s", tok)
    )
  ) -> res

  httr::stop_for_status(res)

  res <- httr::content(res, as="text", encoding="UTF-8")
  res <- jsonlite::fromJSON(res)

  tibble::as_tibble(res$results)

}

#' Retrieve valid geopolitical entities (location)
#'
#' Endpoint data relies on passing a `locationid`. These functions can be uses to obtain
#' a lookup table of valid loations and ids.
#'
#' You need a valid token either passed in to `mywx_api_token` or stored in the `MYWX_TOKEN`
#' environment variable, preferably in `~/.Renviron`.
#'
#' @md
#' @param mywx_api_token MET API token
#' @note Maximum burst requests is 10 per minute and maximum sustained requests is 1,000 per day.
#' @export
#' @examples \dontrun{
#' mywx_states()
#' mywx_districts()
#' mywx_towns()
#' mywx_touristdests()
#' }
mywx_states <- function(mywx_api_token = Sys.getenv("MYWX_TOKEN")) {
  .loc_helper(mywx_api_token, "STATE")
}

#' @rdname mywx_states
#' @export
mywx_districts <- function(mywx_api_token = Sys.getenv("MYWX_TOKEN")) {
  .loc_helper(mywx_api_token, "DISTRICT")
}

#' @rdname mywx_states
#' @export
mywx_towns <- function(mywx_api_token = Sys.getenv("MYWX_TOKEN")) {
  .loc_helper(mywx_api_token, "TOWN")
}

#' @rdname mywx_states
#' @export
mywx_touristdests <- function(mywx_api_token = Sys.getenv("MYWX_TOKEN")) {
  .loc_helper(mywx_api_token, "TOURISTDEST")
}
