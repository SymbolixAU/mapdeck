mapdeckGridDependency <- function() {
	list(
		htmltools::htmlDependency(
			"grid",
			"1.0.0",
			system.file("htmlwidgets/lib/grid", package = "mapdeck"),
			script = c("grid.js")
		)
	)
}


#' Add Grid
#'
#' The Grid Layer renders a grid heatmap based on an array of points.
#' It takes the constant size all each cell, projects points into cells.
#' The color and height of the cell is scaled by number of points it contains.
#'
#' @inheritParams add_arc
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param cell_size size of each cell in meters
#' @param extruded logical indicating if cells are elevated or not
#' @param elevation_scale cell elevation multiplier
#'
#' @examples
#' \dontrun{
#' df <- read.csv('https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/3d-heatmap/heatmap-data.csv')
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_grid(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , cell_size = 5000
#'   , elevation_scale = 50
#'   , layer_id = "grid_layer"
#' )
#' }
#'
#' @export
add_grid <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	cell_size = 1000,
	extruded = TRUE,
	elevation_scale = 1,
	layer_id,
	digits = 6,
	palette = viridisLite::viridis
) {

	objArgs <- match.call(expand.dots = F)

	data <- normaliseSfData(data, "POINT")
	polyline <- findEncodedColumn(data, polyline)

	if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
		objArgs[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}

	## parmater checks
	usePolyline <- isUsingPolyline(polyline)

	## end parameter checks
	if ( !usePolyline ) {
		## TODO(check only a data.frame)
		data[['polyline']] <- googlePolylines::encode(data, lon = lon, lat = lat, byrow = TRUE)
		polyline <- 'polyline'
		## TODO(check lon & lat exist / passed in as arguments )
		objArgs[['lon']] <- NULL
		objArgs[['lat']] <- NULL
		objArgs[['polyline']] <- polyline
	}

	allCols <- gridColumns()
	requiredCols <- requiredGridColumns()

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
		shape <- addDefaults(shape, requiredDefaults, "grid")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckGridDependency())
	invoke_method(map, "add_grid", shape, layer_id, cell_size, jsonlite::toJSON(extruded, auto_unbox = T), elevation_scale)
}


requiredGridColumns <- function() {
	c()
}


gridColumns <- function() {
	c("polyline")
}

gridDefaults <- function(n) {
	data.frame(
		stringsAsFactors = F
	)
}
