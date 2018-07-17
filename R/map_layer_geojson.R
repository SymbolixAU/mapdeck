
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
#' @export
add_geojson <- function(map, data = get_map_data(map)) {
	map <- addDependency(map, mapdeckGeojsonDependency())
	invoke_method(map, "add_geojson", data)
}
