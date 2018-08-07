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
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param weight the weight of each value
#' @param opacity opacity of cells. Value between 0 and 1
#' @param cell_size size of grid squares in pixels
#'
#' @examples
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#' 'examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df$weight <- sample(1:10, size = nrow(df), replace = T)
#'
#' mapdeck( token = key, style = mapdeck_style('dark'), pitch = 45 ) %>%
#' add_screengrid(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , weight = "weight",
#'   , layer_id = "screengrid_layer"
#'   , cell_size = 10
#'   , opacity = 0.3
#' )
#' }
#'
#' @export
add_screengrid <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	weight = NULL,
	opacity = 0.8,
	cell_size = 50,
	layer_id,
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


	## end parameter checks

	allCols <- screengridColumns()
	requiredCols <- requiredScreengridColumns()

	# colourColumns <- shapeAttributes(
	# 	fill_colour = NULL
	# 	, stroke_colour = NULL
	# 	, stroke_from = NULL
	# 	, stroke_to = NULL
	# )

	shape <- createMapObject(data, allCols, objArgs)

	# pal <- createPalettes(shape, colourColumns)
	#
	# colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
	# colours <- createColours(shape, colour_palettes)
#
# 	if(length(colours) > 0){
# 		shape <- replaceVariableColours(shape, colours)
# 	}

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "screengrid")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckScreengridDependency())
	invoke_method(map, "add_screengrid", shape, layer_id, opacity, cell_size )
}




requiredScreengridColumns <- function() {
	c('weight')
}


screengridColumns <- function() {
	c('polyline', 'weight')
}

screengridDefaults <- function(n) {
	data.frame(
		weight = rep(1, n),
		stringsAsFactors = F
	)
}
