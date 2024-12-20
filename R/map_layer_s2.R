mapdeckS2Dependency <- function() {
	list(
		createHtmlDependency(
			name = "s2",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/s2", package = "mapdeck"),
			script = c("s2.js"),
			all_files = FALSE
		)
	)
}

#' Add s2
#'
#' The S2 layer renders filled and/or stroked polygons based on the S2 
#' geospatial indexing system.
#'
#' @inheritParams add_polygon
#' @param token column of \code{data} containing the s2 tokens
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for s2
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
#' mapdeck(
#'  style = mapdeck_style("dark")
#'  , location = c(-122.4, 37.8)
#'  , zoom = 10
#'  , pitch = 60
#'  ) %>%
#'  add_s2(
#'    data = s2
#'    , token = "token"
#'    , fill_colour = "value"
#'    , auto_highlight = TRUE
#'    , legend = TRUE
#'    , elevation = "value"
#'    , elevation_scale = 1000
#'    , palette = colourvalues::get_palette("inferno")
#'    )
#'
#' }
#'
#' @details
#'
#' \code{add_s2} supports a data.frame with a column of s2 tokens
#'
#'
#' @export
add_s2 <- function(
	map,
	data = get_map_data(map),
	token = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	elevation = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	elevation_scale = 1,
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
	transitions = NULL
) {

	l <- list()
	l[["token"]] <- force( token )
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_width"]] <- force( stroke_width )
	l[["stroke_opacity"]] <- resolve_opacity( stroke_opacity )
	l[["fill_colour"]] <- force( fill_colour )
	l[["fill_opacity"]] <- resolve_opacity( fill_opacity )
	l[["elevation"]] <- force( elevation )
	l[["tooltip"]] <- force( tooltip )
	l[["id"]] <- force( id )
	l[["na_colour"]] <- force( na_colour )

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

	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "s2")

	map <- addDependency(map, mapdeckS2Dependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	geometry_column <- "token"

	## use 'polyline' method because we have strings (tokens), not lat/lon coordinates
	shape <- rcpp_point_polyline( data, l, geometry_column, "s2")

	jsfunc <- "add_s2"

	light_settings <- jsonify::to_json(light_settings, unbox = T)
	js_transitions <- resolve_transitions(transitions, "polygon")

	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
		legend_format <- "hex"
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
		legend_format <- "rgb"
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, light_settings,
		elevation_scale, auto_highlight, highlight_colour, shape[["legend"]], legend_format,
		js_transitions, is_extruded
	)
}

#' @rdname clear
#' @export
clear_s2 <- function(map, layer_id = NULL, update_view = TRUE, clear_legend = TRUE) {
	layer_id <- layerId(layer_id, "s2")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "s2", update_view, clear_legend )
}