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
#' @param elevation_data Image URL that encodes height data. When \code{elevation_data}
#' is a URL template, i.e. a string containing '{x}' and '{y}', it loads terrain tiles on demand
#' and renders a mesh for each tile. If \code{elevation_data} is an absolute URL, as ingle mesh is used,
#' and the \code{bounds} argument is required to position it into the world space.
#' @param texture Image URL to use as the texture
#' @param elevation_decoder Four value used to convert a pixel to elevation in metres. The
#' values correspond to rScale, gScale, bScale, offset. See details
#' @param bounds Four values (\code{ c(left, bottom, right, top) }. bounds of the
#' image to fit in x,y coordinates into. \code{left} and \code{right} referes to the world
#' longitude/x at the corresponding side of the image. \code{top} and \code{bottom} refers to
#' the world latitude/y at the corresponding side of the image. Must be supplied when using
#' non-tiled \code{elevation_data}
#' @param max_error Martini error tolerance in metres, smaller number results in more detailed mesh.
#'
#' @details
#'
#' The \code{elevation_decoder} contains four values representing
#' \itemize{
#'   \item{rScale - Multiplier of the red channel}
#'   \item{gScale - Multiplier of the green channel}
#'   \item{bScale - Multiplier of the blue channel}
#'   \item{offset - translation of the sum}
#' }
#'
#' Each colour channel is a number between [0, 255].
#'
#'
#' @examples
#' \donttest{
#'
#' set_token( "MAPBOX_TOKEN" )
#' ## Digital elevation model from https://www.usgs.gov/
#' elevation <- 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/terrain.png'
#' texture <- 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/terrain-mask.png'
#' bounds <- c(-122.5233, 37.6493, -122.3566, 37.8159)
#'
#' mapdeck() %>%
#'   add_terrain(
#'     , elevation_data = elevation
#'     , elevation_decoder = c(1,0,0,0)
#'     , texture = texture
#'     , bounds = bounds
#'     , max_error = 1
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
	elevation_decoder = c(1,0,0,0),
	bounds = NULL,
	max_error = 4,
	update_view = TRUE,
	focus_layer = FALSE
	) {

	experimental_layer("terrain")

	bbox <- init_bbox()
	if( !is.null( bounds ) ) {
		bbox[[1]] <- bounds[1:2]
		bbox[[2]] <- bounds[3:4]
	}

	map <- addDependency( map, mapdeckTerrainDependency() )
	layer_id <- layerId( layer_id, "terrain" )

	invoke_method(
		map, "add_terrain", map_type( map ), layer_id, elevation_data, texture, elevation_decoder,
		max_error, update_view, bounds, bbox, focus_layer
	)
}


#' @rdname clear
#' @export
clear_terrain <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "terrain")
	invoke_method(map, "md_layer_clear", layer_id )
}


