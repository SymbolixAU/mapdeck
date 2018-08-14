mapdeckScatterplotDependency <- function() {
	list(
		htmltools::htmlDependency(
			"scatterplot",
			"1.0.0",
			system.file("htmlwidgets/lib/scatterplot", package = "mapdeck"),
			script = c("scatterplot.js")
		)
	)
}


#' Add Scatterplot
#'
#' The Scatterplot Layer takes in coordinate points and renders them as circles
#' with a certain radius.
#'
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param radius in metres
#'
#' @examples
#'
#' \donttest{
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_scatterplot(
#'   data = capitals
#'   , lat = "lat"
#'   , lon = "lon"
#'   , radius = 100000
#'   , fill_colour = "country"
#'   , layer_id = "scatter_layer"
#' )
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#' 'examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_scatterplot(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "scatter_layer"
#' )
#' }
#'
#' @export
add_scatterplot <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	radius = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
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
	checkNumeric(digits)
	checkPalette(palette)

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

	allCols <- scatterplotColumns()
	requiredCols <- requiredScatterplotColumns()

	colourColumns <- shapeAttributes(
		fill_colour = fill_colour
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
		shape <- addDefaults(shape, requiredDefaults, "scatterplot")
	}
	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckScatterplotDependency())
	invoke_method(map, "add_scatterplot", shape, layer_id)
}




requiredScatterplotColumns <- function() {
	c("radius",
		"fill_colour", "fill_opacity")
}


scatterplotColumns <- function() {
	c('polyline', "elevation", "radius",
		'fill_colour', 'fill_opacity')
}

scatterplotDefaults <- function(n) {
	data.frame(
		"elevation" = rep(0, n),
		"radius" = rep(1, n),
		"fill_colour" = rep("#440154", n),
		"fill_opacity" = rep(255, n),
		stringsAsFactors = F
	)
}
