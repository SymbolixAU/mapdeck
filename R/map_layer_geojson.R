
mapdeckGeojsonDependency <- function() {
	list(
		htmltools::htmlDependency(
			"geojson",
			"1.0.0",
			system.file("htmlwidgets/lib/geojson", package = "mapdeck"),
			script = c("geojson.js")
		)
	)
}


#' Add Geojson
#'
#' The GeoJson Layer takes in GeoJson formatted data and renders it as interactive polygons,
#' lines and points
#'
#' @details the GeoJSON string needs to have a \code{class} attribute of 'json'
#'
#' @inheritParams add_arc
#' @examples
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#'
#'
#' }
#'
#'
#' @export
add_geojson <- function(
	map,
	data = get_map_data(map),
	layer_id
	) {


	map <- addDependency(map, mapdeckGeojsonDependency())
	invoke_method(map, "add_geojson", data, layer_id)
}
