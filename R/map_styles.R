#' Mapdeck Style
#'
#' Various styles available to all Mapbox accounts using a valid access token.
#' Available styles are listed at
#' \url{https://docs.mapbox.com/api/maps/#styles}.
#'
#' @param style one of streets, outdoors, light, dark, satellite, satellite-streets
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' ## set a map style
#' mapdeck(token = key, style = mapdeck_style("dark"))
#'
#' }
#'
#' @export
mapdeck_style <- function(
  style = c("dark","light","outdoors","streets","satellite","satellite-streets")
) {
  style <- match.arg(style)
  return(
    switch(
      style
      , "dark" = "mapbox://styles/mapbox/dark-v9"
      , "light" = "mapbox://styles/mapbox/light-v9"
      , "outdoors" = "mapbox://styles/mapbox/outdoors-v10"
      , "streets" = "mapbox://styles/mapbox/streets-v10"
      , "satellite" = "mapbox://styles/mapbox/satellite-v9"
      , "satellite-streets" = "mapbox://styles/mapbox/satellite-streets-v10"
    )
  )
}
