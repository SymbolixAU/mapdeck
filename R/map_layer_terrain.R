mapdeckTerrainDependency <- function() {
	list(
		createHtmlDependency(
			name = "terrain",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/terrain", package = "mapdeck"),
			script = c("terrain.js"),
			all_files = FALSE
		)
	)
}


#' Add terrain
#'
#' Adds mesh surfaces from height map images
#'
#' @inheritParams add_arc
#' @param elevation_data Image URL that encodes height data.
#' @param texture Image URL to use as the texture
#' @param elevation_decoder Numeric vector giving parameters to use to convert a
#' pixel to elevation in metres.
#' @param bounds
#' @examples
#' \donttest{
#'
#' set_token( "MAPBOX_TOKEN" )
#' ## Digital elevation model from https://www.usgs.gov/
#' elevation <- 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/terrain.png'
#' texture <- 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/terrain-mask.png'
#' bounds <- c(-122.5233, 37.6493, -122.3566, 37.8159)
#'
#' mapdeck( location = bounds[1:2], zoom = 10) %>%
#'   add_terrain(
#'     elevation_data = elevation,
#'     texture = texture,
#'     bounds = bounds
#'   )
#'
#' }
#'
#' @export
add_terrain <- function(
	map,
	layer_id = NULL,
	elevation_data,
	texture = NULL,
	bounds
	) {

	map <- addDependency( map, mapdeckTerrainDependency() )
	layer_id <- layerId( layer_id, "terrain" )

	invoke_method(
		map, "add_terrain", layer_id, elevation_data, texture, bounds
	)
}


#' @rdname clear
#' @export
clear_terrain <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "terrain")
	invoke_method(map, "md_layer_clear", layer_id )
}


