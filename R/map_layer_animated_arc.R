mapdeckAnimatedArcDependency <- function() {
	list(
		createHtmlDependency(
			name = "arc_animated",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/arc", package = "mapdeck"),
			script = c("arc_animated.js"),
			all_files = FALSE
		)
	)
}

#' Add animated arc
#'
#' The Arc Layer renders raised arcs joining pairs of source and target coordinates
#'
#' @inheritParams add_arc
#' @param frequency column of \code{data}, or a single value indicating the number of
#' arcs generated in each animation
#' @param animation_speed the speed of animation
#' @param trail_length the length of trail of each arc
#'
#' @inheritSection add_polygon data
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
#' flights <- read.csv(url)
#' flights$id <- seq_len(nrow(flights))
#' flights$stroke <- sample(1:3, size = nrow(flights), replace = TRUE)
#' flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#'
#' mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
#'   add_animated_arc(
#'   data = flights
#'   , layer_id = "arc_layer"
#'   , origin = c("start_lon", "start_lat")
#'   , destination = c("end_lon", "end_lat")
#'   , stroke_from = "airport1"
#'   , stroke_to = "airport2"
#'   , stroke_width = "stroke"
#'   , trail_length = 10
#'   , tooltip = "info"
#'   , auto_highlight = TRUE
#'   , legend = TRUE
#'   , legend_options = list(
#'     stroke_from = list( title = "Origin airport" ),
#'     css = "max-height: 100px;")
#'  )
#'
#' ## faster animation_speed
#' mapdeck( style = mapdeck_style("dark")) %>%
#'   add_animated_arc(
#'   data = flights
#'   , layer_id = "arc_layer"
#'   , origin = c("start_lon", "start_lat")
#'   , destination = c("end_lon", "end_lat")
#'   , stroke_from = "airport1"
#'   , stroke_to = "airport2"
#'   , stroke_width = "stroke"
#'   , trail_length = 10
#'   , animation_speed = 15
#'   )
#'
#'
#' }
#'
#' @details
#'
#' \code{add_arc} supports POINT sf objects
#'
#' MULTIPOINT objects will be treated as single points. That is, if an sf objet
#' has one row with a MULTIPOINT object consisting of two points, this will
#' be expanded to two rows of single POINTs.
#' Therefore, if the origin is a MULTIPOINT of two points, and the destination is
#' a single POINT, the code will error as there will be an uneven number of rows
#'
#' @export
add_animated_arc <- function(
	map,
	data = get_map_data(map),
	layer_id = NULL,
	origin,
	destination,
	id = NULL,
	stroke_from = NULL,
	stroke_from_opacity = NULL,
	stroke_to = NULL,
	stroke_to_opacity = NULL,
	stroke_width = NULL,
	frequency = 1,
	animation_speed = 3,
	trail_length = 5,
	tilt = NULL,
	height = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	legend = F,
	legend_options = NULL,
	legend_format = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL,
	digits = 6,
	brush_radius = NULL
) {

	experimental_layer("animated_arc")

	l <- list()
	l[["origin"]] <- force(origin)
	l[["destination"]] <- force(destination)
	l[["stroke_from"]] <- force(stroke_from)
	l[["stroke_to"]] <- force(stroke_to)
	l[["stroke_from_opacity"]] <- force(stroke_from_opacity)
	l[["stroke_to_opacity"]] <- force(stroke_to_opacity)
	l[["stroke_width"]] <- force(stroke_width)
	l[["frequency"]] <- force(frequency)
	l[["tilt"]] <- force(tilt)
	l[["height"]] <- force(height)
	l[["tooltip"]] <- force(tooltip)
	l[["id"]] <- force(id)
	l[["na_colour"]] <- force(na_colour)

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_od_data( data, l, origin, destination )

	bbox <- init_bbox()
	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	layer_id <- layerId(layer_id, "animated_arc")
	checkHexAlpha(highlight_colour)

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	if( !is.null(l[["bbox"]] ) ) {
		bbox <- l[["bbox"]]
		l[["bbox"]] <- NULL
	}

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	# if(!is.null(brush_radius)) {
	# 	jsfunc <- "add_arc_brush_geo"
	# 	map <- addDependency(map, mapdeckArcBrushDependency())
	# } else {
	jsfunc <- "add_arc_animated_geo"
	# map <- addDependency(map, mapdeckArcDependency())
	map <- addDependency(map, mapdeckAnimatedArcDependency())
	# }

	if ( tp == "sf" ) {
		geometry_column <- c( "origin", "destination" )
		shape <- rcpp_od_geojson( data, l, geometry_column, digits, "arc" )
	} else if ( tp == "df" ) {
		geometry_column <- list( origin = c("start_lon", "start_lat", "start_elev"), destination = c("end_lon", "end_lat", "end_elev") )
		shape <- rcpp_od_geojson_df( data, l, geometry_column, digits, "arc" )
	}

	js_transition <- resolve_transitions( transitions, "arc" )
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer, js_transition,
		brush_radius, animation_speed, trail_length
	)
}

#' Clear Animated Arc
#'
#' Clears elements from a map
#' @rdname clear
#' @param map a mapdeck map object
#' @param layer_id the layer_id of the layer you want to clear
#' @export
clear_animated_arc <- function( map, layer_id = NULL ) {
	layer_id <- layerId(layer_id, "animated_arc")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "animated_arc" )
}
