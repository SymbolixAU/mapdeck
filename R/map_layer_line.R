mapdeckLineDependency <- function() {
	list(
		htmltools::htmlDependency(
			"line",
			"1.0.0",
			system.file("htmlwidgets/lib/line", package = "mapdeck"),
			script = c("line.js")
		)
	)
}


#' Add line
#'
#' The Line Layer renders raised lines joining pairs of source and target coordinates
#'
#' @inheritParams add_arc
#' @param stroke_opacity value between 1 and 255. Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_colour variable or hex colour to use as the ending stroke colour.
#' transition enabled
#'
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
#' flights <- read.csv(url)
#' flights$id <- seq_len(nrow(flights))
#' flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45 ) %>%
#'   add_line(
#'     data = flights
#'     , layer_id = "line_layer"
#'     , origin = c("start_lon", "start_lat")
#'     , destination = c("end_lon", "end_lat")
#'     , stroke_colour = "airport1"
#'     , stroke_width = "stroke"
#'     , auto_highlight = TRUE
#'  )
#'
#' ## Using a 2-sfc-column sf object
#' library(sf)
#'
#' sf_flights <- cbind(
#'   sf::st_as_sf(flights, coords = c("start_lon", "start_lat"))
#'   , sf::st_as_sf(flights[, c("end_lon","end_lat")], coords = c("end_lon", "end_lat"))
#' )
#'
#' mapdeck(
#'   token = key
#' ) %>%
#'  add_line(
#'    data = sf_flights
#'    , origin = 'geometry'
#'    , destination = 'geometry.1'
#'    , layer_id = 'arcs'
#'    , stroke_colour = "airport1"
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
add_line <- function(
	map,
	data = get_map_data(map),
	layer_id = NULL,
	origin,
	destination,
	id = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL
) {

	l <- list()
	l[["origin"]] <- force( origin )
	l[["destination"]] <- force( destination)
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_width"]] <- force( stroke_width )
	l[["stroke_opacity"]] <- force( stroke_opacity )
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

	layer_id <- layerId(layer_id, "line")
	checkHexAlpha(highlight_colour)

	map <- addDependency(map, mapdeckLineDependency())
	data_types <- data_types( data )

	if ( tp == "sf" ) {
		geometry_column <- c( "origin", "destination" )
		shape <- rcpp_line_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "df" ) {
		geometry_column <- list( origin = c("start_lon", "start_lat"), destination = c("end_lon", "end_lat") )
		shape <- rcpp_line_geojson_df( data, data_types, l, geometry_column )
	}
	# } else if ( tp == "sfencoded" ) {
	# 	geometry_column <- "geometry"
	# 	shape <- rcpp_line_polyline( data, data_types, l, geometry_column )
	# }

	js_transitions <- resolve_transitions( transitions, "line" )

	invoke_method(
		map, "add_line_geo", shape[["data"]], layer_id, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer,
		js_transitions
		)
}



#' @rdname clear
#' @export
clear_line <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "line")
	invoke_method(map, "layer_clear", layer_id, "line" )
}

