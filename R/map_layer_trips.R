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
#' The Trips Layer takes an sf object with Z (elevation) and M (time) attributes and renders
#' it as animated trips
#'
#' @inheritParams add_path
#' @param data sf object with XYZM dimensions.
#' @param stroke_colour variable of data or hex colour for the stroke.
#' @param trail_length how long it takes for the trail to completely fade out
#' (in same units as timestamps )
#' @param opacity single value in [0,1]
#' @param start_time the minimum timestamp
#' @param end_time the maximum timestamp
#' @param animation_speed speed of animation
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#'
#' @examples
#' \donttest{
#'
#' set_token( "MAPBOX_TOKEN")
#' sf <- city_trail
#'
#' mapdeck(
#'   style = mapdeck_style("dark")
#' ) %>%
#'  add_trips(
#'    data = sf
#'    , animation_speed = 500
#'    , trail_length = 500
#'    , stroke_colour = "#FFFFFF"
#'    , stroke_width = 25
#' )
#'
#' ## Multi-coloured trips
#' ## requires a colour for each coordiante
#' ## In this example I'm assining the elevation (z) value
#' ## to a new column
#' df <- sfheaders::sf_to_df( city_trail )
#' df$colour <- df$z
#' sf <- sfheaders::sf_linestring(
#'   obj = df
#'   , x = "x"
#'   , y = "y"
#'   , z = "z"
#'   , m = "m"
#'   , keep = TRUE
#'   , list_column = "colour"
#' )
#'
#' mapdeck(
#'   style = mapdeck_style("light")
#' ) %>%
#'  add_trips(
#'    data = sf
#'    , animation_speed = 1000
#'    , trail_length = 1000
#'    , stroke_colour = "colour"
#'    , stroke_width = 50
#'    , legend = TRUE
#' )
#'
#' ## New York Taxi Trips
#' json <- jsonify::from_json(
#'   "https://raw.githubusercontent.com/visgl/deck.gl-data/master/examples/trips/trips.json"
#' )
#'
#' lens <- vapply( json$segments, nrow, 1L )
#' mat <- do.call( rbind, json$segments )
#' df <- setNames( as.data.frame( mat ), c("x","y","m") )
#' idx <- rep( seq_along( lens ), times = lens )
#' df$vendor <- rep( json$vendor, times = lens )
#'
#' df$z <- 0 ## z column is required in SF object
#' df$idx <- idx
#'
#' ## Using the timestamp as a colour
#' df$timestamp <- df$m
#'
#' sf_line <- sfheaders::sf_linestring(
#'   obj = df
#'   , x = "x"
#'   , y = "y"
#'   , z = "z"
#'   , m = "m"
#'   , linestring_id = "idx"
#'   , keep = TRUE
#'   , list_column = "timestamp"
#' )
#'
#' mapdeck(
#'   style = mapdeck_style("dark")
#' ) %>%
#'   add_trips(
#'     data = sf_line
#'     , stroke_colour = "timestamp"
#'     , animation_speed = 1000
#'     , trail_length = 1000
#'     , palette = colourvalues::get_palette("viridis")[100:256, ]
#'   )
#'
#'
#' }
#'
#' @details
#'
#' \code{add_trips} supports LINESTRING and MULTILINESTRING sf objects
#'
#' @export
add_trips <- function(
	map,
	data = get_map_data(map),
	stroke_colour = NULL,
	stroke_width = NULL,
	width_units = c("meters","pixels"),
	width_min_pixels = NULL,
	width_max_pixels = NULL,
	width_scale = 1,
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
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6
) {

	experimental_layer("trips")

	l <- list()
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_width"]] <- force( stroke_width )

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )


	# l <- resolve_data( data, l, c("LINESTRING") )

	bbox <- init_bbox()
	layer_id <- layerId(layer_id, "trips")
	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	l <- resolve_binary_data( data, l )

	map <- addDependency(map, mapdeckTripsDependency())

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


	jsfunc <- "add_trips_geo"
	if ( tp == "sf" ) {

		# geometry_column <- c( "geometry" ) ## This is where we woudl also specify 'origin' or 'destination'
		# shape <- rcpp_path_geojson( data, l, geometry_column, digits, "trips" )

		geometry_column <- c( "geometry" ) ## This is where we would also specify 'origin' or 'destination'
		list_cols <- list_columns( data, geometry_column )

		shape <- rcpp_trips_interleaved( data, l, list_cols, digits, "trips", start_time )

	} else {
		stop("mapdeck - currently only sf objects are supported for the trips layer")
	}

	# js_transitions <- resolve_transitions( transitions, "path" )
	legend_type <- "rgb"
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
		legend_type <- "hex"
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape, opacity, layer_id, trail_length,
		start_time, end_time, animation_speed, bbox, update_view, focus_layer,
		width_units, width_scale, width_min_pixels, width_max_pixels, legend_type
	)
}


#' @rdname clear
#' @export
clear_trips <- function( map, layer_id = NULL, update_view = TRUE ) {
	layer_id <- layerId(layer_id, "trips")
	## TRIPS needs to be stopped first
	invoke_method(map, "md_stop_trips", map_type( map ), layer_id, "trips", update_view )
}


get_m_range_start <- function(x) unname( get_m_range(x)[1] )

get_m_range_end <- function(x) unname( get_m_range(x)[2] )

get_m_range <- function( x ) UseMethod("get_m_range")

## TODO error handle if doesn't exist
## TODO get the geometry column from the sf attributes

#' @export
get_m_range.sf <- function( x ) {

	geometry <- attr( x, "sf_column" )
	if( is.null( attr( x[[geometry]], "m_range" ) ) ) {
		stop("mapdeck - m_range attribute not set; please define the start_time and end_time")
	}

	attr( x[[geometry]], "m_range")
}
#' @export
get_m_range.default <- function( x ) stop("mapdeck - only sf objects with ZM attributes are supported for the trips layer")


