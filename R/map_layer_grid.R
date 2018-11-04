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
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param colour_range vector of 6 hex colours
#' @param cell_size size of each cell in meters
#' @param extruded logical indicating if cells are elevated or not
#' @param elevation_scale cell elevation multiplier
#'
#' @examples
#' \donttest{
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#' 'examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_grid(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , cell_size = 5000
#'   , elevation_scale = 50
#'   , layer_id = "grid_layer"
#'   , auto_highlight = TRUE
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
	colour_range = colourvalues::colour_values(1:6, palette = "viridis"),
	cell_size = 1000,
	extruded = TRUE,
	elevation_scale = 1,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	layer_id = NULL,
	force = FALSE
) {

	l <- as.list( match.call( expand.dots = F) )
	l[[1]] <- NULL
	l[["data"]] <- NULL
	l[["map"]] <- NULL
	l[["elevation_scale"]] <- NULL
	l[["cell_size"]] <- NULL
	l[["colour_range"]] <- NULL
	l[["auto_highlight"]] <- NULL
	l[["layer_id"]] <- NULL
	l <- resolve_data( data, l, force, "POINT" )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	## parmater checks
	usePolyline <- isUsingPolyline(polyline)
	checkNumeric(elevation_scale)
	checkNumeric(cell_size)
	checkHex(colour_range)
	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "grid")

	map <- addDependency(map, mapdeckGridDependency())
	data_types <- vapply(data, function(x) class(x)[[1]], "")
	geometry_column <- c( "geometry" )

	shape <- rcpp_grid_geojson( data, data_types, l, geometry_column )
	# print(shape)


	invoke_method(
		map, "add_grid_geo", shape[["data"]], layer_id, cell_size,
		jsonlite::toJSON(extruded, auto_unbox = T), elevation_scale,
		colour_range, auto_highlight, highlight_colour
		)
}


#' @export
add_grid_old <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	colour_range = colourvalues::colour_values(1:6, palette = "viridis"),
	cell_size = 1000,
	extruded = TRUE,
	elevation_scale = 1,
	auto_highlight = FALSE,
	layer_id = NULL,
	digits = 6
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
	checkNumeric(digits)
	checkNumeric(elevation_scale)
	checkNumeric(cell_size)
	checkHex(colour_range)
	layer_id <- layerId(layer_id, "grid")

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

	shape <- createMapObject(data, allCols, objArgs)

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "grid")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)
	# print(shape)

	map <- addDependency(map, mapdeckGridDependency())

	invoke_method(
		map, "add_grid", shape, layer_id, cell_size,
		jsonlite::toJSON(extruded, auto_unbox = T), elevation_scale,
		colour_range, auto_highlight
	)
}


#' @rdname clear
#' @export
clear_grid <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "grid")
	invoke_method(map, "clear_grid", layer_id )
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
