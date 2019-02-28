
# js <- '{"id": "terrain-data",
# 	"type": "line",
# 	"source": {
# 		"type": "vector",
# 		"url": "mapbox://mapbox.mapbox-terrain-v2"
# 	},
# 	"source-layer": "contour",
# 	"layout": {
# 		"line-join": "round",
# 		"line-cap": "round"
# 	},
# 	"paint": {
# 		"line-color": "#000000",
# 		"line-width": 1
# 	}}'
#
# mapbox(
# 	style = mapdeck_style("light")
# 	, location = c(-122.44, 37.753)
# 	, zoom = 10
# 	) %>%
# 	add_vector_source( js )



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
