
mapdeckMVTDependency <- function() {
	list(
		createHtmlDependency(
			name = "mvt",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/mvt", package = "mapdeck"),
			script = c("mvt.js"),
			all_files = FALSE
		)
	)
}

#' Add MVT
#'
#' Loads Mapbox Vector Tiles to the map
#'
#' @param url location of the vector tiles
#'
#' @export
add_mvt <- function(map, url, layer_id = NULL) {

	experimental_layer("mvt")

	map <- addDependency( map, mapdeckMVTDependency() )
	layer_id <- layerId(layer_id, layer = "mvt" )

	invoke_method(map, "add_mvt", map_type( map ), url, layer_id)

}
