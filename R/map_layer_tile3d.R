mapdeckLoadersDependency <- function() {
	list(
		## https://unpkg.com/@loaders.gl/3d-tiles@2.2.3/dist/dist.min.js
		createHtmlDependency(
			name = "3d-tiles",
			version = "2.2.3",
			src = system.file("htmlwidgets/lib/", package = "mapdeck"),
			script = c("3d-tiles.min.js"),
			all_files =  FALSE
		)
	)
}

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
#' tl <- "https://raw.githubusercontent.com/AnalyticalGraphicsInc/3d-tiles-samples/master/tilesets/TilesetWithDiscreteLOD/tileset.json"
#' mapdeck(
#'   location = c(0, 0)
#'   , zoom = 6
#'   ) %>%
#'   add_tile3d(
#'     data = tl
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

	experimental_layer("tile3d")

	layer_id <- layerId(map, layer_id, layer = "tile3d" )

	map <- addDependency(map, mapdeckTile3DDependency() )
	map <- addDependency(map, mapdeckLoadersDependency() )

	jsfunc <- "add_tile3d"

	invoke_method(
		map, jsfunc, map_type( map ), data, layer_id, ion_token
	)
}
