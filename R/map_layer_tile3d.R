mapdeckLoader3dTilesDependency <- function() {
	list(
		## https://unpkg.com/@loaders.gl/3d-tiles@2.2.3/dist/dist.min.js
		createHtmlDependency(
			name = "loader_3dtiles",
			version = "2.2.3",
			src = system.file("htmlwidgets/lib/", package = "mapdeck"),
			script = c("loader_3dtiles.min.js"),
			all_files =  FALSE
		)
	)
}

mapdeckLoaderIS3Dependency <- function() {
	list(
		## https://unpkg.com/@loaders.gl/i3s@2.2.3/dist/dist.min.js
		createHtmlDependency(
			name = "loader_i3s",
			version = "2.2.3",
			src = system.file("htmlwidgets/lib/", package = "mapdeck"),
			script = c("loader_i3s.min.js"),
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


#' Add Cesium
#'
#' Renders 3D tiles data from Cesium ION assets. To use this layer you need a
#' Cesium ION account \url{https://cesium.com/docs/tutorials/getting-started/#your-first-app}.
#' This layer is experimental
#'
#' @inheritParams add_pointcloud
#' @param ion_token ion asset token
#' @param point_size size of point in pixels
#'
#' @examples
#' \donttest{
#'
#' ## Melbourne point cloud
#' ion_asset <- 43978
#' ion_token <- "ION_TOKEN"
#' tile_data <- paste0("https://assets.cesium.com/",ion_asset,"/tileset.json")
#'
#' mapdeck(
#'   location = c(144.95, -37.82)
#'   , zoom = 14
#'   , pitch = 60
#' ) %>%
#'  add_cesium(
#'    data = tile_data
#'    , ion_token = ion_token
#'  )
#'
#' }
#'
#' @export
add_cesium <- function(
	map,
	data,
	point_size = 2,
	layer_id = NULL,
	ion_token = NULL
) {

	experimental_layer("cesium")

	layer_id <- layerId(layer_id, layer = "cesium" )

	map <- addDependency(map, mapdeckTile3DDependency() )
	map <- addDependency(map, mapdeckLoader3dTilesDependency() )

	jsfunc <- "add_cesium"

	invoke_method(
		map, jsfunc, map_type( map ), data, point_size, layer_id, ion_token
	)
}



#' Add I3S
#'
#' Adds OGC Indexed 3D Scene (I3S) tiles to the map. This layer is experimental.
#'
#' @inheritParams add_pointcloud
#'
#' @examples
#' \donttest{
#'
#' ## San Francisco buildings
#' i3s <- paste0(
#'   'https://tiles.arcgis.com/tiles/z2tnIkrLQ2BRzr6P/arcgis/rest/services/'
#'   , 'SanFrancisco_Bldgs/SceneServer/layers/0'
#'   )
#'
#' mapdeck(
#'   location = c(-122.41, 37.77)
#'   , zoom = 16
#'   , pitch = 60
#' ) %>%
#'   add_i3s(
#'     data = i3s
#'   )
#' }
#'
#' @export
add_i3s <- function(
	map,
	data,
	layer_id = NULL
) {

	experimental_layer("i3s")

	layer_id <- layerId(layer_id, layer = "i3s" )

	map <- addDependency(map, mapdeckTile3DDependency() )
	map <- addDependency(map, mapdeckLoaderIS3Dependency() )

	jsfunc <- "add_i3s"

	invoke_method(
		map, jsfunc, map_type( map ), data, layer_id
	)
}
