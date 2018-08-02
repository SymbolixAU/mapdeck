mapdeckScreengridDependency <- function() {
	list(
		htmltools::htmlDependency(
			"screengrid",
			"1.0.0",
			system.file("htmlwidgets/lib/screengrid", package = "mapdeck"),
			script = c("screengrid.js")
		)
	)
}


#' Add Screengrid
#'
#' The Screen Grid Layer takes in an array of latitude and longitude coordinated points,
#' aggregates them into histogram bins and renders as a grid
#'
#' @inheritParams add_arc
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param weight the weight of each value
#'
#' @examples
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- read.csv('https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/3d-heatmap/heatmap-data.csv')
#' df$weight <- sample(1:10, size = nrow(df), replace = T)
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_screengrid(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , weight = "weight",
#'   , layer_id = "screengrid_layer"
#' )
#' }
#'
#' @export
add_screengrid <- function(
	map,
	data = get_map_data(map),
	lon,
	lat,
	weight = NULL,
	layer_id,
	digits = 6
) {

	objArgs <- match.call(expand.dots = F)

	## parmater checks


	## end parameter checks

	allCols <- screengridColumns()
	requiredCols <- requiredScreengridColumns()

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
		shape <- addDefaults(shape, requiredDefaults, "screengrid")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckScreengridDependency())
	invoke_method(map, "add_screengrid", shape, layer_id )
}




requiredScreengridColumns <- function() {
	c('weight')
}


screengridColumns <- function() {
	c('lat', 'lon', 'weight')
}

screengridDefaults <- function(n) {
	data.frame(
		weight = rep(1, n),
		stringsAsFactors = F
	)
}
