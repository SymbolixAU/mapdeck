mapdeckTile3DDependency <- function() {
	list(
		createHtmlDependency(
			name = "tile3d",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/tile3d", package = "mapdeck"),
			script = c("tile3d.js"),
			all_files = FALSE
		)
	)
}


#' Add Tile3D
#'
#' @examples
#' \donttest{
#'
#' canary_warf <- 'https://raw.githubusercontent.com/AnalyticalGraphicsInc/3d-tiles/master/examples/tileset.json'
#' mapdeck(
#'   style = mapdeck_style("dark")
#'   ) %>%
#'   add_tile3d(
#'     data = canary_warf
#'   )
#'
#'
#' }
#'
#' @export
add_tile3d <- function(
	map,
	data = get_map_data(map),
	layer_id = NULL,
	ion_token = NULL
) {

	layer_id <- layerId(map, layer_id, layer = "tile3d" )

	map <- addDependency(map, mapdeckTile3DDependency())

	jsfunc <- "add_tile3d"

	invoke_method(
		map, jsfunc, map_type( map ), data, layer_id, ion_token
	)
}
