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
#' @inheritSection add_arc legend
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
#'
#' ## as an sf object wtih a Z attribute
#' library(sf)
#' sf <- sf::st_as_sf( df , coords = c("lon","lat","z"))
#'
#' mapdeck(token = key, style = 'mapbox://styles/mapbox/dark-v9') %>%
#' add_pointcloud(
#'   data = sf
#'   , layer_id = 'point'
#'   , fill_colour = "country"
#'   , tooltip = "country"
#' )
#'
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
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	light_settings = list(),
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL
) {

	# message("Using development version. Please check plots carefully")

	# l <- as.list( match.call( expand.dots = F) )
	# l[[1]] <- NULL    ## function call
	# l[["map"]] <- NULL
	# l[["data"]] <- NULL
	# l[["auto_highlight"]] <- NULL
	# l[["light_settings"]] <- NULL
	# l[["layer_id"]] <- NULL

	l <- list()
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )
	l[["polyline"]] <- force( polyline )
	l[["elevation"]] <- force( elevation )
	l[["fill_colour"]] <- force( fill_colour)
	l[["fill_opacity"]] <- force( fill_opacity )
	l[["tooltip"]] <- force(tooltip)
	l[["id"]] <- force(id)

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_elevation_data( data, l, elevation, c("POINT","MULTIPOINT") )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "pointcloud")

	map <- addDependency(map, mapdeckPointcloudDependency())
	data_types <- vapply(data, function(x) class(x)[[1]], "")

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_pointcloud_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )

		# print(data)
		# print( data_types )
		# print( l )
		# print( geometry_column )

		shape <- rcpp_pointcloud_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "df" ) {

		## TODO( here or in rcpp? )
		if( is.null(elevation) ){
			l[["elevation"]] <- 0
		}

		geometry_column <- list( geometry = c("lon","lat","elevation") )
	  shape <- rcpp_pointcloud_geojson_df( data, data_types, l, geometry_column )

	} else if ( tp == "sfencoded" ) {

		geometry_column <- "polyline"
		shape <- rcpp_pointcloud_polyline( data, data_types, l, geometry_column )
		jsfunc <- "add_pointcloud_polyline"
	}

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, light_settings,
		auto_highlight, highlight_colour, shape[["legend"]]
		)
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
	legend = FALSE,
	legend_options = NULL,
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

	## LEGEND
	legend <- resolveLegend(legend, legend_options, colour_palettes)

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "pointcloud")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)
	# print(shape)

	light_settings <- jsonlite::toJSON(light_settings, auto_unbox = T)

	map <- addDependency(map, mapdeckPointcloudDependency())
	invoke_method(map, "add_pointcloud", shape, layer_id, light_settings, legend )
}


#' @rdname clear
#' @export
clear_pointcloud <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "pointcloud")
	invoke_method(map, "clear_pointcloud", layer_id )
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
