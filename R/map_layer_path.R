mapdeckPathDependency <- function() {
	list(
		htmltools::htmlDependency(
			"path",
			"1.0.0",
			system.file("htmlwidgets/lib/path", package = "mapdeck"),
			script = c("path.js")
		)
	)
}


#' Add Path
#'
#' The Path Layer takes in lists of coordinate points and renders them as
#' extruded lines with mitering.
#'
#' @inheritParams add_polygon
#'
#' @param stroke_opacity value between 1 and 255. Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#'
#' @inheritSection add_arc legend
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck(
#'   token = key
#'   , style = 'mapbox://styles/mapbox/dark-v9'
#'   , location = c(145, -37.8)
#'   , zoom = 10) %>%
#'   add_path(
#'     data = roads
#'     , stroke_colour = "RIGHT_LOC"
#'     , layer_id = "path_layer"
#'     , tooltip = "ROAD_NAME"
#'     , auto_highlight = TRUE
#'   )
#'
#' }
#'
#' @export
add_path <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	geometry = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	tooltip = NULL,
	layer_id = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL
) {

	## TODO(sf and lon/lat coordinates)
	#message("Using development version. Please check plots carefully")

	l <- as.list( match.call() )
	l[[1]] <- NULL
	l[["data"]] <- NULL
	l[["map"]] <- NULL
	l[["layer_id"]] <- NULL
	l[["auto_highlight"]] <- NULL
	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )

	data <- normaliseSfData(data, "LINESTRING")
	polyline <- findEncodedColumn(data, polyline)

	## - if sf object, and geometry column has not been supplied, it needs to be
	## added to objArgs after the match.call() function
	if( !is.null(polyline) && !polyline %in% names(l) ) {
		l[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}

	layer_id <- layerId(layer_id, "path")
	checkHexAlpha(highlight_colour)
	shape <- rcpp_path( data, l );

	map <- addDependency(map, mapdeckPathDependency())
	invoke_method(map, "add_path", shape[["data"]], layer_id, auto_highlight, highlight_colour, shape[["legend"]] )
}

#' @export
add_path_geo <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	tooltip = NULL,
	layer_id = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	force = FALSE
) {

	## TODO(sf and lon/lat coordinates)
	#message("Using development version. Please check plots carefully")

	l <- as.list( match.call() )
	l[[1]] <- NULL
	l[["data"]] <- NULL
	l[["map"]] <- NULL
	l[["layer_id"]] <- NULL
	l[["auto_highlight"]] <- NULL
	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, force )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	layer_id <- layerId(layer_id, "path")
	checkHexAlpha(highlight_colour)

	map <- addDependency(map, mapdeckPathDependency())
	shape <- rcpp_path_geo( data, l);

	if ( l[["jsfunction"]] == "geojson" ) {

	  invoke_method(map, "add_path_geo", shape[["data"]], layer_id, auto_highlight, highlight_colour, shape[["legend"]] )
	} else if ( l[["jsfunction"]] == "decode") {

		invoke_method(map, "add_path2", shape[["data"]], layer_id, auto_highlight, highlight_colour, shape[["legend"]] )
	}
}


#' @inheritParams add_path
#' @export
add_path_old <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	tooltip = NULL,
	layer_id = NULL,
	digits = 6,
	auto_highlight = FALSE,
	legend = FALSE,
	legend_options = NULL,
	palette = viridisLite::viridis
) {

	## TODO(sf and lon/lat coordinates)

	objArgs <- match.call(expand.dots = F)

	data <- normaliseSfData(data, "LINESTRING")
	polyline <- findEncodedColumn(data, polyline)

	## - if sf object, and geometry column has not been supplied, it needs to be
	## added to objArgs after the match.call() function
	if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
		objArgs[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}

	## parameter checks
	checkNumeric(digits)
	checkPalette(palette)
	layer_id <- layerId(layer_id, "path")

	## end parameter checks

	allCols <- pathColumns()
	requiredCols <- requiredPathColumns()

	colourColumns <- shapeAttributes(
		fill_colour = NULL
		, stroke_colour = stroke_colour
		, stroke_from = NULL
		, stroke_to = NULL
	)

	shape <- createMapObject(data, allCols, objArgs)

	pal <- createPalettes(shape, colourColumns)

	colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
	colours <- createColours(shape, colour_palettes)

	if(length(colours) > 0) {
		shape <- replaceVariableColours(shape, colours)
	}

	## LEGEND
	legend <- resolveLegend(legend, legend_options, colour_palettes)

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "path")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckPathDependency())
	invoke_method(map, "add_path", shape, layer_id, auto_highlight, legend )
}

#' @rdname clear
#' @export
clear_path <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "path")
	invoke_method(map, "clear_path", layer_id )
}

requiredPathColumns <- function() {
	c("stroke_width", "stroke_colour","stroke_opacity")
}

pathColumns <- function() {
	c("polyline", "stroke_width", "stroke_colour", "stroke_opacity")
}

pathDefaults <- function(n) {
	data.frame(
		"stroke_colour" = rep("#440154", n),
		"stroke_width" = rep(1, n),
		"stroke_opacity" = rep(255, n),
		stringsAsFactors = F
	)
}



