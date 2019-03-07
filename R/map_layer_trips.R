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
#' The Trips Layer takes in lists of coordinate points and renders them as
#' extruded lines with mitering.
#'
#' @inheritParams add_polygon
#' @param stroke_width
#' @param trail_length
#'
#' @inheritSection add_polygon data
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#'
#' \code{add_trips} supports LINESTRING and MULTILINESTRING sf objects
#'
#' @export
add_trips <- function(
	map,
	data = get_map_data(map),
	stroke_colour = NULL,
	palette = "viridis",
	trail_length = 180,
	loop_length = 1000,
	animation_speed = 30,
	layer_id = NULL,
	legend = FALSE,
	legend_options = NULL,
	legend_format = NULL,
	update_view = TRUE
) {

	experimental_layer("trips")

	l <- list()
	l[["stroke_colour"]] <- force( stroke_colour)

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, c("LINESTRING","MULTILINESTRING") )

	bbox <- init_bbox()
	update_view <- force( update_view )
	# focus_layer <- force( focus_layer )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	if( !is.null(l[["bbox"]] ) ) {
		bbox <- l[["bbox"]]
		l[["bbox"]] <- NULL
	}

	layer_id <- layerId(layer_id, "path")
	# checkHexAlpha( highlight_colour )

	map <- addDependency(map, mapdeckTripsDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	# if ( tp == "sf" ) {
		geometry_column <- c( "geometry" ) ## This is where we woudl also specify 'origin' or 'destination'
		shape <- rcpp_trips_geojson( data, l, geometry_column )
		jsfunc <- "add_trips_geo"
	# } else if ( tp == "sfencoded" ) {
	# 	jsfunc <- "add_path_polyline"
	# 	geometry_column <- "polyline"
	# 	shape <- rcpp_path_polyline( data, l, geometry_column )
	# }

	# js_transitions <- resolve_transitions( transitions, "path" )
	shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, trail_length, loop_length, animation_speed,
		shape[["legend"]]
	)
}


#' @rdname clear
#' @export
clear_path <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "path")
	invoke_method(map, "md_layer_clear", layer_id, "path" )
}



