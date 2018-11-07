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
#' @param palette string or matrix. String is either one of "viridis","inferno",
#' "magma","plasma" or "cividis". A matrix is a 3 or 4 column numeric matrix of values
#' between [0, 255], where the 4th column represents the alpha.
#' @param na_colour hex string colour to use for NA values
#'
#' @inheritSection add_arc legend
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
#'   , tooltip = "capital"
#' )
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#' 'examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df <- df[ !is.na(df$lng), ]
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
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL
) {

	message("Using development version. Please check plots carefully")

	l <- as.list( match.call() )
	l[[1]] <- NULL    ## function call
	l[["map"]] <- NULL
	l[["data"]] <- NULL
	l[["auto_highlight"]] <- NULL
	l[["layer_id"]] <- NULL
	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, "POINT" )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	layer_id <- layerId(layer_id, "scatterplot")
	checkHexAlpha(highlight_colour)

	map <- addDependency(map, mapdeckScatterplotDependency())
	data_types <- vapply(data, function(x) class(x)[[1]], "")


	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_scatterplot_geo"
	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_scatterplot_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_scatterplot_geojson_df( data, data_types, l, geometry_column )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- c( "polyline" )
		shape <- rcpp_scatterplot_polyline( data, data_types, l, geometry_column )
		jsfunc <- "add_scatterplot_polyline"
	}

	invoke_method(map, jsfunc, shape[["data"]], layer_id, auto_highlight, highlight_colour, shape[["legend"]] )
}



#' @inheritParams add_scatterplot
#' @export
add_scatterplot_old <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	radius = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
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
	checkNumeric(digits)
	checkPalette(palette)
	layer_id <- layerId(layer_id, "scatterplot")
	## TODO(logical check auto_highlight)

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

	## LEGEND
	legend <- resolveLegend(legend, legend_options, colour_palettes)

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "scatterplot")
	}
	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckScatterplotDependency())
	invoke_method(map, "add_scatterplot", shape, layer_id, auto_highlight, legend )
}


#' @rdname clear
#' @export
clear_scatterplot <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "scatterplot")
	invoke_method(map, "clear_scatterplot", layer_id )
}

requiredScatterplotColumns <- function() {
	c("radius",	"fill_colour", "fill_opacity")
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
