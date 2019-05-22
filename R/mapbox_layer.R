#' Add mapbox source
#'
#' @details
#'
#' Mapbox sources supply data to be shown on the map. The type of source is specified
#' by the "type" property, adn must be one of
#' \itemize{
#'   \item{vector}
#'   \item{raster}
#'   \item{raster-dem}
#'   \item{geojson}
#'   \item{image}
#'   \item{video}
#' }
#'
#' See the Mapbox Sources definition at \url{https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources}
#'
#' @export
add_mapbox_source <- function(map, id, js) {

	if( !inherits(map, "mapbox") ) {
		stop("expecting a mapbox map, perhaps you meant to use `mapbox()`?")
	}

	invoke_mapbox_method(
		map, "add_mapbox_source", id, js
	)
}

#' Add mapbox layer
#'
#' @export
add_mapbox_layer <- function(map, js) {

	if( !inherits(map, "mapbox") ) {
		stop("expecting a mapbox map, perhaps you meant to use `mapbox()`?")
	}

	invoke_mapbox_method(
		map, "add_mapbox_layer", js
	)
}


#' @export
clear_mapbox_layer <- function(map, layer ) {
	invoke_mapbox_method(
		map, "clear_mabpox_layer", layer
	)
}
