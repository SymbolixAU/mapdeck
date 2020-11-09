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
#' @section gradient fill:
#'
#' If a colour is supplied for each coordinate (see examples), the colour along each segment
#' of the line is gradient-filled. However, if either \code{dash_gap}, \code{dash_size} or
#' \code{offset} are supplied the the segment is filled with a solid colour, accoding to the
#' first point on the segment.
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
#'   ) %>%
#'   add_path(
#'     data = roads
#'     , stroke_colour = "RIGHT_LOC"
#'     , layer_id = "path_layer"
#'     , tooltip = "ROAD_NAME"
#'     , auto_highlight = TRUE
#'     , legend = TRUE
#'   )
#'
#' ## Dashed lines
#' mapdeck(
#'   style = mapdeck_style("dark")
#'   ) %>%
#'   add_path(
#'     data = roads
#'     , stroke_colour = "RIGHT_LOC"
#'     , layer_id = "path_layer"
#'     , tooltip = "ROAD_NAME"
#'     , dash_size = 3
#'     , dash_gap = 1
#'   )
#'
#' ## Different dashes per path
#'
#' sf <- mapdeck::roads
#' sf$dash_size <- sample(1:5, size = nrow( sf ), replace = TRUE )
#' sf$dash_gap <- sample(1:5, size = nrow( sf ), replace = TRUE )
#'
#' mapdeck(
#'   style = mapdeck_style("dark")
#'   ) %>%
#'   add_path(
#'     data = sf
#'     , stroke_colour = "RIGHT_LOC"
#'     , layer_id = "path_layer"
#'     , tooltip = "ROAD_NAME"
#'     , dash_size = "dash_size"
#'     , dash_gap = "dash_gap"
#'   )
#'
#' ## Offset lines
#' sf <- mapdeck::roads
#' sf$offset <- sample(-10:10, size = nrow( sf ), replace = TRUE )
#'
#' mapdeck(
#'   style = mapdeck_style("light")
#' ) %>%
#' 	add_path(
#'    data = sf
#'    , stroke_colour = "ROAD_NAME"
#'    , offset = "offset"
#'  )
#'
#' ## Multi Coloured line
#' ## You need to supply one colour per coordinate in the sf object
#' sf_line <- sfheaders::sf_linestring(
#'   obj = data.frame(
#'   id = c(1,1,1,1,1,2,2,2,2,2)
#'   , x = c(0,0,1,1,2,-1,-1,0,0,1)
#'   , y = c(0,1,1,2,2,0,1,1,2,2)
#'   , col = c(1,2,3,4,5,5,4,3,2,1)
#'  )
#'  , x = "x"
#'  , y = "y"
#'  , linestring_id = "id"
#'  , list_columns = "col"
#'  , keep = T
#' )
#'
#' mapdeck(
#'  style = mapdeck_style("light")
#' ) %>%
#'  add_path(
#'    data = sf_line
#'    , stroke_colour = "col"
#'    , stroke_width = 50000
#' )
#'
#' ## If using dashed lines, colours won't be gradient-filled
#' mapdeck(
#'  style = mapdeck_style("light")
#' ) %>%
#'  add_path(
#'    data = sf_line
#'    , stroke_colour = "col"
#'    , stroke_width = 50000
#'    , dash_size = 1
#'    , dash_gap = 1
#'  )
#'
#'
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

	use_dashes <- !is.null( dash_size ) | !is.null( dash_gap )

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

	bbox <- init_bbox()
	layer_id <- layerId(layer_id, "path")
	checkHexAlpha( highlight_colour )

	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	use_offset <- !is.null( offset )
	use_dash <- !is.null( dash_size ) && !is.null( dash_gap )

	map <- addDependency(map, mapdeckPathDependency())

	l <- resolve_binary_data( data, l )

	if( !is.null(l[["bbox"]] ) ) {
		bbox <- l[["bbox"]]
		l[["bbox"]] <- NULL
	}

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_path_geo"
	if ( tp == "sf" ) {

		geometry_column <- c( "geometry" ) ## This is where we would also specify 'origin' or 'destination'
		list_cols <- list_columns( data, geometry_column )

		shape <- rcpp_path_interleaved( data, l, list_cols, digits, "path" )

	} else if ( tp == "sfencoded" ) {
		jsfunc <- "add_path_polyline"
		geometry_column <- "polyline"
		shape <- rcpp_path_polyline( data, l, geometry_column, "path" )
	} else if ( tp == "interleaved" ) {

		shape <- list(
			data = jsonify::to_json(
				data
				, unbox = FALSE
				, digits = digits
				, factors_as_string = TRUE
				, numeric_dates = FALSE
				, by = "column"
			)
		)
	}


	js_transitions <- resolve_transitions( transitions, "path" )
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape, layer_id, auto_highlight,
		highlight_colour, bbox, update_view, focus_layer,
		js_transitions, billboard, brush_radius, width_units, width_scale, width_min_pixels,
		width_max_pixels, use_offset, use_dash
		)
}


resolve_binary_data <- function( data, l ) UseMethod("resolve_binary_data")

resolve_binary_data.interleaved <- function( data, l ) {

	l[["bbox"]] <- get_box( data, l )
	l[["data_type"]] <- "interleaved"

	return( l )
}

#' @export
resolve_binary_data.sf <- function( data, l ) {
	sfc_col <- attr( data, "sf_column" )
	l[["geometry"]] <- sfc_col

	cls <- attr( data[[ sfc_col ]], "class" )

	if( is.null( cls ) ) {
		stop("mapdeck - invalid sf object; have you loaded library(sf)?")
	}

	l[["bbox"]] <- get_box( data, l )
	l[["data_type"]] <- "sf"
	return(l)
}

resolve_binary_data.default <- function( data, l ) {
	return( resolve_data( data, l, "LINESTRING" ) )
}


#' @rdname clear
#' @export
clear_path <- function( map, layer_id = NULL, update_view = TRUE ) {
	layer_id <- layerId(layer_id, "path")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "path", update_view )
}



