mapdeckH3Dependency <- function() {
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
			name = "h3",
			version = "3.6.2",
			src = system.file("htmlwidgets/lib", package = "mapdeck"),
			script = c("h3-js.umd.js"),
			all_files = FALSE
		)
	)
}

#' Add h3
#'
#' The h3 layer renders hexagons from the H3 geospatial indexing system. To use
#' this layer you must specify \code{libraries = "h3"} within the \code{mapdeck()} call. See examples.
#'
#' @inheritParams add_polygon
#' @param hexagon column of \code{data} containing the hexagon indexes
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for h3
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
#'  , location = c(0, 51.3)
#'  , zoom = 10
#'  , pitch = 60
#'  , libraries = "h3"
#'  ) %>%
#'  add_h3(
#'    data = road_safety
#'    , hexagon = "hex"
#'    , fill_colour = "count"
#'    , auto_highlight = TRUE
#'    , legend = TRUE
#'    , elevation = "count"
#'    , elevation_scale = 20
#'    , palette = colourvalues::get_palette("inferno")
#'    )
#'
#' }
#'
#' @details
#'
#' \code{add_h3} supports a data.frame with a column of h3 indexes
#'
#'
#' @export
add_h3 <- function(
	map,
	data = get_map_data(map),
	hexagon = NULL,
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
	layer_id <- layerId(layer_id, "h3")

	map <- addDependency(map, mapdeckH3Dependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_h3_hexagon_geo"

	geometry_column <- "hexagon"

	## use 'polyline' method because we have strings (cells), not lat/lon coordinates
	shape <- rcpp_point_polyline( data, l, geometry_column, "h3_hexagon")

	# return(shape)

	jsfunc <- "add_h3_hexagon"

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
clear_h3_hexagon <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "h3")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "h3_hexagon" )
}
