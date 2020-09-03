mapdeckAnimatedLineDependency <- function() {
	list(
		createHtmlDependency(
			name = "line",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/line", package = "mapdeck"),
			script = c("line_animated.js"),
			all_files = FALSE
		)
	)
}



#' Add Animated line
#'
#' The Line Layer renders raised lines joining pairs of source and target coordinates
#'
#' @inheritParams add_line
#' @inheritParams add_animated_arc
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
#'
#' mapdeck(style = mapdeck_style("dark"), pitch = 45 ) %>%
#'   add_animated_line(
#'     data = flights
#'     , layer_id = "line_layer"
#'     , origin = c("start_lon", "start_lat")
#'     , destination = c("end_lon", "end_lat")
#'     , stroke_colour = "airport1"
#'     , stroke_width = "stroke"
#'     , auto_highlight = TRUE
#'     , trail_length = 1
#'     , animation_speed = 1
#'  )
#'
#' ## Using a 2-sfc-column sf object
#' library(sfheaders)
#'
#' sf_flights <- sfheaders::sf_point( flights, x = "start_lon", y = "start_lat", keep = TRUE )
#' destination <- sfheaders::sfc_point( flights, x = "end_lon", y = "end_lat" )
#'
#' sf_flights$destination <- destination
#'
#' mapdeck() %>%
#'  add_animated_line(
#'    data = sf_flights
#'    , origin = 'geometry'
#'    , destination = 'destination'
#'    , layer_id = 'arcs'
#'    , stroke_colour = "airport1"
#'    , trail_length = 1
#'    , animation_speed = 2
#' )
#' }
#'
#' @details
#'
#' \code{add_line} supports POINT sf objects
#'
#'
#' MULTIPOINT objects will be treated as single points. That is, if an sf object
#' has one row with a MULTIPOINT object consisting of two points, this will
#' be expanded to two rows of single POINTs.
#' Therefore, if the origin is a MULTIPOINT of two points, and the destination is
#' a single POINT, the code will error as there will be an uneven number of rows
#'
#' @export
add_animated_line <- function(
	map,
	data = get_map_data(map),
	layer_id = NULL,
	origin,
	destination,
	id = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	frequency = 1,
	animation_speed = 3,
	trail_length = 5,
	tooltip = NULL,
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

	experimental_layer("animated_line")

	l <- list()
	l[["origin"]] <- force( origin )
	l[["destination"]] <- force( destination)
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_width"]] <- force( stroke_width )
	l[["stroke_opacity"]] <- resolve_opacity( stroke_opacity )
	l[["frequency"]] <- force(frequency)
	l[["tooltip"]] <- force( tooltip )
	l[["id"]] <- force( id )
	l[["na_colour"]] <- force(na_colour)

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_od_data( data, l, origin, destination )

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

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	layer_id <- layerId(layer_id, "animated_line")
	checkHexAlpha(highlight_colour)

	map <- addDependency(map, mapdeckAnimatedLineDependency())

	if ( tp == "sf" ) {
		geometry_column <- c( "origin", "destination" )
		shape <- rcpp_od_geojson( data, l, geometry_column, digits, "line" )
	} else if ( tp == "df" ) {
		geometry_column <- list( origin = c("start_lon", "start_lat","start_elev"), destination = c("end_lon", "end_lat","end_elev") )
		shape <- rcpp_od_geojson_df( data, l, geometry_column, digits, "line" )
	}
	# } else if ( tp == "sfencoded" ) {
	# 	geometry_column <- "geometry"
	# 	shape <- rcpp_od_polyline( data, l, geometry_column )
	# }

	js_transitions <- resolve_transitions( transitions, "line" )
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, "add_line_animated_geo", map_type( map ), shape[["data"]], layer_id, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer,
		js_transitions, brush_radius, animation_speed, trail_length
	)
}



#' @rdname clear
#' @export
clear_line <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "animated_line")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "animated_line" )
}

