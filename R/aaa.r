met_api_base_url <- "https://api.met.gov.my"

readr::cols(
  locationid = readr::col_character(),
  locationname = readr::col_character(),
  locationrootid = readr::col_character(),
  locationrootname = readr::col_character(),
  date = readr::col_datetime(format = ""),
  datatype = readr::col_character(),
  value = readr::col_character(),
  attributes.unit = readr::col_character(),
  attributes.code = readr::col_character(),
  attributes.when = readr::col_character()
) -> .met_api_forecast_cols