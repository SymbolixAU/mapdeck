#' Mapdeck Style
#'
#' Various styles available to all Mapbox accounts using a valid access token
#'
#' @param style one of streets, outdoors, light, dark, satellite, satellite-streets
#'
#' @examples
#' \dontrun{
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
	style = c("streets","outdoors","light","dark","satellite",
						"satellite-streets")
) {
	return(
		switch(
			style
			, "streets" = "mapbox://styles/mapbox/streets-v10"
			, "outdoors" = "mapbox://styles/mapbox/outdoors-v10"
			, "light" = "mapbox://styles/mapbox/light-v9"
			, "dark" = "mapbox://styles/mapbox/dark-v9"
			, "satellite" = "mapbox://styles/mapbox/satellite-v9"
			, "satellite-streets" = "mapbox://styles/mapbox/satellite-streets-v10"
		)
	)
}
