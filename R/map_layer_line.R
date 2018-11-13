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
#' @param stroke_colour variable or hex colour to use as the ending stroke colour
#'
#' @inheritSection add_arc legend
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
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
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
#' MULTIPOINT objects will be treated as single points. That is, if an sf objet
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
	legend = FALSE,
	legend_options = NULL
) {

	# l <- as.list( match.call() )
	# l[[1]] <- NULL
	# l[["data"]] <- NULL
	# l[["map"]] <- NULL
	# l[["layer_id"]] <- NULL
	# l[["auto_highlight"]] <- NULL

	l <- list()
	l[["origin"]] <- force( origin )
	l[["destination"]] <- force( destination)
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_width"]] <- force( stroke_width )
	l[["stroke_opacity"]] <- force( stroke_opacity )
	l[["tooltip"]] <- force( tooltip )
	l[["id"]] <- force( id )

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_od_data( data, l, origin, destination )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	layer_id <- layerId(layer_id, "line")
	checkHexAlpha(highlight_colour)

	map <- addDependency(map, mapdeckLineDependency())
	data_types <- vapply(data, function(x) class(x)[[1]], "")

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

	invoke_method(map, "add_line_geo", shape[["data"]], layer_id, auto_highlight, highlight_colour, shape[["legend"]] )
}



#' @rdname clear
#' @export
clear_line <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "line")
	invoke_method(map, "clear_line", layer_id )
}

