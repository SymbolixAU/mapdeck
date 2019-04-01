mapdeckBitmapDependency <- function() {
	list(
		createHtmlDependency(
			name = "bitmap",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/bitmap", package = "mapdeck"),
			script = c("bitmap.js")
		)
	)
}


#' Add bitmap
#'
#' @param url
#' @param bounds coordinates of the bounding box of the bitmap [left, bottom, right, top]
#' @param desaturate the desatruation of the bitmap, in range [0,1], 0 being the original colour
#' and 1 being greyscale
#' @param transparent_colour the colour to use for transparent pixels
#' @param tint_colour
#'
#' @examples
#' \donttest{
#'
#' mapdeck(
#'   location = c(-71.516, 37.936), zoom = 12
#' ) %>%
#'  add_bitmap(
#'    url = "https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif"
#'    , bounds = list(c(-71.516, 37.936), c(-80.425, 37.936), c(-80.425, 46.437), c(-71.516, 46.437))
#'  )
#'
#' }
#'
#' @export
add_bitmap <- function(
	map,
	url,
	bounds,
	desaturate = 0,
	transparent_colour = c(0,0,0,0),
	tint_colour = c(255, 255, 255),
	layer_id = NULL
) {

	map <- addDependency( map, mapdeckBitmapDependency() )
	layer_id <- layerId( layer_id, "bitmap" )

	invoke_method(
		map, "add_bitmap", url, layer_id, bounds, desaturate, transparent_colour, tint_colour
	)
}
