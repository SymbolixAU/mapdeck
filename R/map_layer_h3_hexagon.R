mapdeckH3HexagonDependency <- function() {
	list(
		createHtmlDependency(
			name = "h3-hexagon",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/h3", package = "mapdeck"),
			script = c("h3.js"),
			all_files = FALSE
		)
	)
}

mapdeckH3JSDependency <- function() {
	list(
		createHtmlDependency(
			name = "h3-js",
			version = "3.6.2",
			src = system.file("htmlwidgets/lib", package = "mapdeck"),
			script = c("h3-js.umd.js"),
			all_files = FALSE
		)
	)
}

#' Add hexagon
#'
#' The Hexagon Layer renders a hexagon heatmap based on an array of points.
#' It takes the radius of hexagon bin, projects points into hexagon bins.
#' The color and height of the hexagon is scaled by number of points it contains.
#'
#' @inheritParams add_arc
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param polyline column of \code{data} containing the polylines
#' @param radius in metres. Default 1000
#' @param elevation_scale value to sacle the elevations of the hexagons. Default 1
#' @param colour_range vector of 6 hex colours
#' @param elevation column containing the elevation of the value.
#' @param elevation_function one of 'min', 'mean', 'max', 'sum'.
#' IF supplied it specifies how the elevation values are calcualted. Defaults to sum.
#' @param colour column containing numeric values to colour by.
#' @param colour_function one of 'min', 'mean', 'max', 'sum'.
#' If supplied it specifies how the colour values are calculated. Defaults to sum.
#' @param legend logical indicating if a legend should be displayed
#'
#' @inheritSection add_polygon data
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for hexagon
#'
#' list(
#' elevation = 0
#' colour = 0
#' )
#'
#' @examples
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' }
#'
#' @details
#'
#' \code{add_hexagon} supports POINT and MULTIPOINT sf objects
#'
#'
#' @export
add_h3_hexagon <- function(
	map,
	data = get_map_data(map),
	# polyline = NULL,
	hexagon = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	elevation = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	light_settings = list(),
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	legend_format = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6,
	transitions = NULL
) {

	l <- list()
	l[["hexagon"]] <- force( hexagon )
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_width"]] <- force( stroke_width )
	l[["stroke_opacity"]] <- resolve_opacity( stroke_opacity )
	l[["fill_colour"]] <- force( fill_colour )
	l[["fill_opacity"]] <- resolve_opacity( fill_opacity )
	l[["elevation"]] <- force( elevation )
	l[["tooltip"]] <- force( tooltip )
	l[["id"]] <- force( id )
	l[["na_colour"]] <- force( na_colour )

	legend <- force( legend )
	legend <- aggregation_legend( legend, legend_options )

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )

	# l <- resolve_data( data, l, c("POINT","MULTIPOINT") )
	l[["data_type"]] <- "df"
	l[["data"]] <- data

	bbox <- init_bbox()
	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	is_extruded <- TRUE
	if( !is.null( l[["stroke_width"]] ) | !is.null( l[["stroke_colour"]] ) ) {
		is_extruded <- FALSE
		if( !is.null( elevation ) ) {
			message("stroke provided, ignoring elevation")
		}
		if( is.null( l[["stroke_width"]] ) ) {
			l[["stroke_width"]] <- 1L
		}
	}

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	# if( !is.null(l[["bbox"]] ) ) {
	# 	bbox <- l[["bbox"]]
	# 	l[["bbox"]] <- NULL
	# }

	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "h3_hexagon")

	# map <- addDependency(map, mapdeckH3JSDependency(), priority = TRUE)
	map <- addDependency(map, mapdeckH3HexagonDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_h3_hexagon_geo"

	geometry_column <- "hexagon"
	shape <- rcpp_point_polyline( data, l, geometry_column, "scatterplot")
	jsfunc <- "add_h3_hexagon"

	light_settings <- jsonify::to_json(light_settings, unbox = T)
	js_transitions <- resolve_transitions( transitions, "polygon" )

	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, light_settings,
		auto_highlight, highlight_colour, shape[["legend"]], js_transitions,
		is_extruded
	)
}


#' @rdname clear
#' @export
clear_h3_hexagon <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "h3_hexagon")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "h3_hexagon" )
}
