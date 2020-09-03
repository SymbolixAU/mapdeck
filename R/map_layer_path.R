mapdeckPathDependency <- function() {
	list(
		createHtmlDependency(
			name = "path",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/path", package = "mapdeck"),
			script = c("path.js"),
			all_files = FALSE
		)
	)
}


#' Add Path
#'
#' The Path Layer takes in lists of coordinate points and renders them as
#' extruded lines with mitering.
#'
#' @inheritParams add_polygon
#' @param stroke_width width of the stroke in meters. Default 1.
#' @param dash_size size of each dash, relative to the width of the stroke
#' @param dash_gap size of the gap between dashes, relative to the width of the stroke
#' @param offset The offset to draw each path with, relative to the width of the path.
#' Negative offset is to the left hand side, and positive offset is to the right hand side.
#' 0 extrudes the path so that it is centered at the specified coordinates.
#' @param billboard logical indicating if the path always faces the camera (TRUE) or
#' if it always faces up (FALSE)
#' @param width_units The units of the line width, one of 'meters', 'pixels'.
#' When zooming in and out, meter sizes scale with the base map, and pixel sizes
#' remain the same on screen.
#' @param width_scale The path width multiplier that multiplied to all paths.
#' @param width_min_pixels The minimum path width in pixels.
#' This can be used to prevent the path from getting too thin when zoomed out.
#' @param width_max_pixels The maximum path width in pixels.
#' his prop can be used to prevent the path from getting too thick when zoomed in.
#'
#' @inheritSection add_polygon data
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for path
#'
#' list(
#' path = 0,
#' stroke_colour = 0,
#' stroke_width = 0
#' )
#'
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' mapdeck(
#'   style = mapdeck_style("dark")
#'   , location = c(145, -37.8)
#'   , zoom = 10) %>%
#'   add_path(
#'     data = roads
#'     , stroke_colour = "RIGHT_LOC"
#'     , layer_id = "path_layer"
#'     , tooltip = "ROAD_NAME"
#'     , auto_highlight = TRUE
#'     , legend = TRUE
#'   )
#' }
#'
#' @details
#'
#' \code{add_path} supports LINESTRING and MULTILINESTRING sf objects
#'
#' @export
add_path <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	dash_size = NULL,
	dash_gap = NULL,
	offset = NULL,
	width_units = c("meters","pixels"),
	width_min_pixels = NULL,
	width_max_pixels = NULL,
	width_scale = 1,
	tooltip = NULL,
	billboard = FALSE,
	layer_id = NULL,
	id = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	legend_format = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6,
	transitions = NULL,
	brush_radius = NULL
) {

	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["stroke_colour"]] <- force( stroke_colour)
	l[["stroke_width"]] <- force( stroke_width )
	l[["stroke_opacity"]] <- resolve_opacity( stroke_opacity )
	l[["dash_size"]] <- force(dash_size)
	l[["dash_gap"]] <- force(dash_gap)
	l[["offset"]] <- force(offset)
	l[["tooltip"]] <- force(tooltip)
	l[["id"]] <- force(id)
	l[["na_colour"]] <- force(na_colour)

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, c("LINESTRING") )

	bbox <- init_bbox()
	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	if( !is.null(l[["bbox"]] ) ) {
		bbox <- l[["bbox"]]
		l[["bbox"]] <- NULL
	}

	use_offset <- !is.null( offset )
	use_dash <- !is.null( dash_size ) | !is.null( dash_gap )

	layer_id <- layerId(layer_id, "path")
	checkHexAlpha( highlight_colour )

	map <- addDependency(map, mapdeckPathDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" ) ## This is where we woudl also specify 'origin' or 'destination'
		shape <- rcpp_path_geojson( data, l, geometry_column, digits, "path" )
		jsfunc <- "add_path_geo"
	} else if ( tp == "sfencoded" ) {
		jsfunc <- "add_path_polyline"
		geometry_column <- "polyline"
		shape <- rcpp_path_polyline( data, l, geometry_column, "path" )
	}

	js_transitions <- resolve_transitions( transitions, "path" )
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer,
		js_transitions, billboard, brush_radius, width_units, width_scale, width_min_pixels,
		width_max_pixels, use_offset, use_dash
		)
}


#' @rdname clear
#' @export
clear_path <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "path")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "path" )
}



