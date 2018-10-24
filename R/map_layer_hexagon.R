mapdeckHexagonDependency <- function() {
	list(
		htmltools::htmlDependency(
			"hexagon",
			"1.0.0",
			system.file("htmlwidgets/lib/hexagon", package = "mapdeck"),
			script = c("hexagon.js")
		)
	)
}


#' Add hexagon
#'
#' The Hexagon Layer renders a hexagon heatmap based on an array of points.
#' It takes the radius of hexagon bin, projects points into hexagon bins.
#' The color and height of the hexagon is scaled by number of points it contains.
#'
#' @inheritParams add_arc
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param radius in metres
#' @param colour_range palette of colours
#'
#' @examples
#' \dontrun{
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_hexagon(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "hex_layer"
#' )
#'
#' }
#'
#' @export
add_hexagon <- function(
	map,
	data = get_map_data(map),
	lon,
	lat,
	layer_id,
	radius = NULL,
	colourRange = viridisLite::viridis(6)
) {

	objArgs <- match.call(expand.dots = F)

	shape <- rcpp_hexagon( data, l )


	map <- addDependency(map, mapdeckHexagonDependency())
	invoke_method(map, "add_hexagon", shape, layer_id)
}


#' @export
add_hexagon_old <- function(
	map,
	data = get_map_data(map),
	lon,
	lat,
	layer_id,
	radius = NULL,
	digits = 6
	#	colourRange = viridisLite::viridis(6)
) {

	objArgs <- match.call(expand.dots = F)

	## parmater checks


	## end parameter checks

	allCols <- hexagonColumns()
	requiredCols <- requiredHexagonColumns()

	colourColumns <- shapeAttributes(
		fill_colour = NULL
		, stroke_colour = NULL
		, stroke_from = NULL
		, stroke_to = NULL
	)

	shape <- createMapObject(data, allCols, objArgs)

	pal <- createPalettes(shape, colourColumns)

	colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
	colours <- createColours(shape, colour_palettes)

	if(length(colours) > 0){
		shape <- replaceVariableColours(shape, colours)
	}

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "hexagon")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckHexagonDependency())
	invoke_method(map, "add_hexagon", shape, layer_id)
}


requiredHexagonColumns <- function() {
	c('radius')
}


hexagonColumns <- function() {
	c('lat', 'lon')
}

hexagonDefaults <- function(n) {
	data.frame(
		radius = rep(200, n),
		stringsAsFactors = F
	)
}

#' @rdname clear
#' @export
clear_hexagon <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "hexagon")
	invoke_method(map, "clear_hexagon", layer_id )
}
