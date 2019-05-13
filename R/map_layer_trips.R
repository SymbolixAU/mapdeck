mapdeckTripsDependency <- function() {
	list(
		createHtmlDependency(
			name = "trips",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/trips", package = "mapdeck"),
			script = c("trips.js")
		)
	)
}


#' Add Trips
#'
#' The Trips Layer takes an sf object with an M attribute and renders
#' it as animated trips
#'
#' @inheritParams add_polygon
#' @param stroke_width
#' @param trail_length
#' @param opacity single value in [0,1]
#'
#' @inheritSection add_polygon data
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#'
#'
#' \code{add_trips} supports LINESTRING and MULTILINESTRING sf objects
#'
#' @export
add_trips <- function(
	map,
	data = get_map_data(map),
	stroke_colour = NULL,
	stroke_width = NULL,
	opacity = 0.3,
	palette = "viridis",
	trail_length = 180,
	start_time = get_m_range_start( data ),
	end_time = get_m_range_end( data ),
	animation_speed = 30,
	layer_id = NULL,
	legend = FALSE,
	legend_options = NULL,
	legend_format = NULL,
	update_view = FALSE,
	focus_layer = FALSE
) {

	experimental_layer("trips")

	l <- list()
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_width"]] <- force( stroke_width )

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, c("LINESTRING","MULTILINESTRING") )

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

	layer_id <- layerId(layer_id, "trips")
	# checkHexAlpha( highlight_colour )

	map <- addDependency(map, mapdeckTripsDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" ) ## This is where we woudl also specify 'origin' or 'destination'
		shape <- rcpp_trips_geojson( data, l, geometry_column )
		jsfunc <- "add_trips_geo"
	} else {
		stop("currently only sf objects are supported for the trips layer")
	}

	# js_transitions <- resolve_transitions( transitions, "path" )
	shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], opacity, layer_id, trail_length,
		start_time, end_time, animation_speed, shape[["legend"]], focus_layer, bbox, update_view
	)
}


#' @rdname clear
#' @export
clear_path <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "trips")
	invoke_method(map, "md_layer_clear", layer_id, "trips" )
}


get_m_range_start <- function(x) unname( get_m_range(x)[1] )

get_m_range_end <- function(x) unname( get_m_range(x)[2] )

get_m_range <- function( x ) UseMethod("get_m_range")

## TODO error handle if doesn't exist
## TODO get the geometry column from the sf attributes

#' @export
get_m_range.sf <- function( x ) attr(x$geometry, "m_range")

#' @export
get_m_range.default <- function( x ) stop("only sf objects with ZM attributes are supported for the trips layer")


