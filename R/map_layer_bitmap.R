mapdeckBitmapDependency <- function() {
	list(
		createHtmlDependency(
			name = "bitmap",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/bitmap", package = "mapdeck"),
			script = c("bitmap.js"),
			all_files = FALSE
		)
	)
}


#' Add bitmap
#'
#' Adds an image to a map
#'
#' @inheritParams add_arc
#' @param image url to an image to use on the map
#' @param bounds coordinates of the bounding box of the image [left, bottom, right, top]
#' @param desaturate the desatruation of the bitmap, in range [0,1], 0 being the original colour
#' and 1 being greyscale
#' @param transparent_colour the colour to use for transparent pixels as a hex string
#' @param tint_colour the colour to tint the bipmap by, as a hex string
#'
#' @examples
#' \donttest{
#'
#' set_token( "MAPBOX_TOKEN" )
#'
#' mapdeck(location = c(-122.3, 37.8), zoom = 10) %>%
#'  add_bitmap(
#'    image = paste0(
#'    'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#'    'website/sf-districts.png')
#'    , bounds = c(-122.519, 37.7045, -122.355, 37.829)
#'  )
#'
#' mapdeck(location = c(-75.9, 40.9), zoom = 4) %>%
#'   add_bitmap(
#'     image = 'https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif'
#'     , bounds = c(-80.425, 37.936, -71.516, 46.437)
#'   )
#'
#' mapdeck(location = c(-75.9, 40.9), zoom = 4) %>%
#'   add_bitmap(
#'     image = 'https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif'
#'     , bounds = c(-80.425, 37.936, -71.516, 46.437)
#'     , tint_colour = "#FF0000"
#'   )
#'
#' mapdeck(location = c(-75.9, 40.9), zoom = 4) %>%
#'   add_bitmap(
#'     image = 'https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif'
#'     , bounds = c(-80.425, 37.936, -71.516, 46.437)
#'     , desaturate = 1
#'   )
#'
#' }
#'
#' @export
add_bitmap <- function(
	map,
	image,
	bounds,
	desaturate = 0,
	transparent_colour = "#000000",
	tint_colour = "#FFFFFF",
	layer_id = NULL,
	update_view = TRUE,
	focus_layer = FALSE
) {

	bbox <- init_bbox()
	bbox[[1]] <- bounds[1:2]
	bbox[[2]] <- bounds[3:4]

	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	transparent_colour <- force( transparent_colour )
	tint_colour <- force( tint_colour )

	transparent_colour <- colourvalues::convert_colour( transparent_colour )
	tint_colour <- colourvalues::convert_colour( tint_colour )

	transparent_colour <- jsonify::to_json( as.vector( transparent_colour ) )
	tint_colour <- jsonify::to_json( as.vector( tint_colour ) )

	map <- addDependency( map, mapdeckBitmapDependency() )
	layer_id <- layerId( layer_id, "bitmap" )

	invoke_method(
		map, "add_bitmap", layer_id, image, bounds, desaturate, transparent_colour,
		tint_colour, bbox, focus_layer, update_view
	)
}


#' @rdname clear
#' @export
clear_bitmap <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "bitmap")
	invoke_method(map, "md_layer_clear", layer_id, "bitmap" )
}


