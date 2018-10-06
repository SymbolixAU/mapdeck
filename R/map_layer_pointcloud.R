mapdeckPointcloudDependency <- function() {
	list(
		htmltools::htmlDependency(
			"pointcloud",
			"1.0.0",
			system.file("htmlwidgets/lib/pointcloud", package = "mapdeck"),
			script = c("pointcloud.js")
		)
	)
}


#' Add Pointcloud
#'
#' The Pointcloud Layer takes in coordinate points and renders them as circles
#' with a certain radius.
#'
#' @inheritParams add_scatterplot
#' @param elevation column containing the elevation values
#' @param light_settings list of light setting parameters. See \link{light_settings}
#'
#' @examples
#' \donttest{
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- capitals
#' df$z <- sample(10000:10000000, size = nrow(df))
#'
#' mapdeck(token = key, style = 'mapbox://styles/mapbox/dark-v9') %>%
#' add_pointcloud(
#'   data = df
#'   , lon = 'lon'
#'   , lat = 'lat'
#'   , elevation = 'z'
#'   , layer_id = 'point'
#'   , fill_colour = "country"
#'   , tooltip = "country"
#' )
#' }
#'
#' @export
add_pointcloud <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	elevation = NULL,
	polyline = NULL,
	radius = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	tooltip = NULL,
	light_settings = list(),
	layer_id = NULL,
	digits = 6,
	palette = "viridis",
	na_colour = "#808080FF"
) {

	message("Using development version. Please check plots carefully")

	l <- as.list( match.call() )
	l <- resolve_palette( l, palette )

	data <- normaliseSfData(data, "POINT")
	polyline <- findEncodedColumn(data, polyline)

	if( !is.null(polyline) && !polyline %in% names(l) ) {
		l[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}
	usePolyline <- isUsingPolyline(polyline)
	if ( !usePolyline ) {
		## TODO(check only a data.frame)
		data[['polyline']] <- googlePolylines::encode(data, lon = lon, lat = lat, byrow = TRUE)
		polyline <- 'polyline'
		## TODO(check lon & lat exist / passed in as arguments )
		l[['lon']] <- NULL
		l[['lat']] <- NULL
		l[['polyline']] <- polyline
	}

	shape <- rcpp_pointcloud( data, l )

	light_settings <- jsonlite::toJSON(light_settings, auto_unbox = T)

	map <- addDependency(map, mapdeckPointcloudDependency())
	invoke_method(map, "add_pointcloud2", shape, layer_id, light_settings)
}


#' @export
#' @inheritParams add_pointcloud
add_pointcloud_old <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	elevation,
	polyline = NULL,
	radius = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	stroke_width = NULL,
	tooltip = NULL,
	light_settings = list(),
	layer_id = NULL,
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

	checkNumeric(digits)
	checkPalette(palette)
	layer_id <- layerId(layer_id, "pointcloud")
	## TODO(light_settings)

	## end parameter checks

	allCols <- pointcloudColumns()
	requiredCols <- requiredPointcloudColumns()

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
		shape <- addDefaults(shape, requiredDefaults, "pointcloud")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	light_settings <- jsonlite::toJSON(light_settings, auto_unbox = T)

	map <- addDependency(map, mapdeckPointcloudDependency())
	invoke_method(map, "add_pointcloud", shape, layer_id, light_settings)
}



requiredPointcloudColumns <- function() {
	c("stroke_width", "radius",
		"fill_colour", "fill_opacity")
}


pointcloudColumns <- function() {
	c('polyline', "elevation", "radius",
		'fill_colour', 'fill_opacity',
		'stroke_width')
}

pointcloudDefaults <- function(n) {
	data.frame(
		"elevation" = rep(0, n),
		"radius" = rep(1, n),
		"fill_colour" = rep("#0000FF", n),
		"fill_opacity" = rep(255, n),
		"stroke_width" = rep(1, n),
		stringsAsFactors = F
	)
}
