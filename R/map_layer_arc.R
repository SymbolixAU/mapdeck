mapdeckArcDependency <- function() {
	list(
		htmltools::htmlDependency(
			"arc",
			"1.0.0",
			system.file("htmlwidgets/lib/arc", package = "mapdeck"),
			script = c("arc.js")
		)
	)
}


#' Add arc
#'
#'
#' @param map a mapdeck map object
#' @param data data to be used in the layer
#' @param layer_id single value specifying an id for the layer. Use this value to
#' distinguish between shape layers of the same type
#' @param origin vector of longitude and latitude columns
#' @param destination vector of longitude and latitude columns
#' @param id an id value in \code{data} to identify layers when interacting in Shiny apps
#' @param stroke_from variable or hex colour to use as the staring stroke colour
#' @param stroke_to variable or hex colour to use as the ending stroke colour
#' @param stroke_width width of the stroke
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#' @param palette a function, or list of functions which generates hex colours
#'
#' @examples
#' \dontrun{
#'
#' key <- "pk.eyJ1Ijoic3ltYm9saXgiLCJhIjoiY2pqbm45Zmo1MGl1aTNxbmxwamFqb3Z6MSJ9.yIkj0tGNNh4u61DliOXV6g"
#'
#' url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
#' flights <- read.csv(url)
#' flights$id <- seq_len(nrow(flights))
#' flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' 	add_arc(
#' 		data = flights
#' 		, layer_id = "arc_layer"
#' 		, origin = c("start_lon", "start_lat")
#' 		, destination = c("end_lon", "end_lat")
#' 		, stroke_from = "airport1"
#' 		, stroke_to = "airport2"
#' 		, stroke_width = "stroke"
#' 	)
#' }
#'
#' @export
add_arc <- function(
	map,
	data = get_map_data(map),
	layer_id,
	origin,
	destination,
	id = NULL,
	stroke_from = NULL,
	stroke_to = NULL,
	stroke_width = NULL,
	digits = 6,
	palette = viridisLite::viridis
) {

	objArgs <- match.call(expand.dots = F)

	## parameter checks


	## end parameter checks

	lon_from <- origin[1]
	lat_from <- origin[2]
	lon_to <- destination[1]
	lat_to <- destination[2]
	objArgs[['lat_from']] <- lat_from
	objArgs[['lat_to']] <- lat_to
	objArgs[['lon_from']] <- lon_from
	objArgs[['lon_to']] <- lon_to


	allCols <- arcColumns()
	requiredCols <- requiredArcColumns()

	colourColumns <- shapeAttributes(
		fill_colour = NULL
		, stroke_colour = NULL
		, stroke_from = stroke_from
		, stroke_to = stroke_to
		)

	shape <- createMapObject(data, allCols, objArgs)

	# print(head(shape))
	pal <- createPalettes(shape, colourColumns)

	colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
	colours <- createColours(shape, colour_palettes)

	if(length(colours) > 0) {
		shape <- replaceVariableColours(shape, colours)
	}

	# print(head(shape))
	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "arc")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckArcDependency())
	invoke_method(map, "add_arc", shape, layer_id)
}

#' Update Arc
#'
#'
#' @param layer_id the layer_id of the layer to update.
#'
#' @export
update_arc <- function(
	map,
	data = get_map_data(map),
	layer_id,
	lat_from,
	lon_from,
	lat_to,
	lon_to,
	id = NULL,
	stroke_from = NULL,
	stroke_to = NULL,
	stroke_width = NULL,
	digits = 6,
	palette = viridisLite::viridis
) {

	stop(" function not implemented ")

	objArgs <- match.call(expand.dots = F)

	## parameter checks
	layer_id <- layerId(layer_id)

	## end parameter checks

	allCols <- arcColumns()
	requiredCols <- requiredArcColumns()

	colourColumns <- shapeAttributes(
		fill_colour = NULL
		, stroke_colour = NULL
		, stroke_from = stroke_from
		, stroke_to = stroke_to
	)

	shape <- createMapObject(data, allCols, objArgs)

	# print(head(shape))
	pal <- createPalettes(shape, colourColumns)

	colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
	colours <- createColours(shape, colour_palettes)

	if(length(colours) > 0) {
		shape <- replaceVariableColours(shape, colours)
	}

	# print(head(shape))
	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "arc")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	invoke_method(map, "update_arc", shape, layer_id)
}



requiredArcColumns <- function() {
	c("stroke_width", "stroke_from", "stroke_to")
}

arcColumns <- function() {
	c('lat_from', 'lon_from', "lat_to", "lon_to",
		"stroke_width", "stroke_from", "stroke_to")
}

arcDefaults <- function(n) {
	data.frame(
		"stroke_from" = rep("#440154", n),
		"stroke_to" = rep("#FDE725", n),
		"stroke_width" = rep(1, n),
		stringsAsFactors = F
	)
}
