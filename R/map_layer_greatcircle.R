mapdeckGreatCircleDependency <- function() {
	list(
		createHtmlDependency(
			name = "greatcircle",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/greatcircle", package = "mapdeck"),
			script = c("greatcircle.js"),
			all_files = FALSE
		)
	)
}

#' Add greatcircle
#'
#' Renders flat arcs along the great circle joining pairs
#' of source and target points, specified as longitude/latitude coordinates.
#'
#' @inheritParams add_arc
#' @param wrap_longitude logical, whether to automatically wrap longitudes over the
#' 180th antimeridian.

#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' set_token("MAPBOX_TOKEN")
#'
#' url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
#' flights <- read.csv(url)
#' flights$id <- seq_len(nrow(flights))
#' flights$stroke <- sample(1:3, size = nrow(flights), replace = TRUE)
#' flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#'
#' mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
#'   add_greatcircle(
#'   data = flights
#'   , layer_id = "greatcircle_layer"
#'   , origin = c("start_lon", "start_lat")
#'   , destination = c("end_lon", "end_lat")
#'   , stroke_from = "airport1"
#'   , stroke_to = "airport2"
#'   , stroke_width = "stroke"
#'   , tooltip = "info"
#'   , auto_highlight = TRUE
#'   , legend = TRUE
#'   , legend_options = list(
#'     stroke_from = list( title = "Origin airport" ),
#'     css = "max-height: 100px;")
#'  )
#'
#' mapdeck( style = mapdeck_style("dark")) %>%
#'   add_greatcircle(
#'   data = flights
#'   , layer_id = "greatcircle_layer"
#'   , origin = c("start_lon", "start_lat")
#'   , destination = c("end_lon", "end_lat")
#'   , stroke_from = "airport1"
#'   , stroke_to = "airport2"
#'   , stroke_width = "stroke"
#'   )
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
#'  add_greatcircle(
#'    data = sf_flights
#'    , origin = 'geometry'
#'    , destination = 'destination'
#'    , layer_id = 'greatcircles'
#'    , stroke_from = "airport1"
#'    , stroke_to = "airport2"
#' )
#' }
#'
#' @details
#'
#' \code{add_greatcircle} supports POINT sf objects
#'
#' MULTIPOINT objects will be treated as single points. That is, if an sf objet
#' has one row with a MULTIPOINT object consisting of two points, this will
#' be expanded to two rows of single POINTs.
#' Therefore, if the origin is a MULTIPOINT of two points, and the destination is
#' a single POINT, the code will error as there will be an uneven number of rows
#'
#' @export
add_greatcircle <- function(
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
	wrap_longitude = FALSE,
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
	digits = 6
) {
	brush_radius = NULL

	l <- list()
	l[["origin"]] <- force(origin)
	l[["destination"]] <- force(destination)
	l[["stroke_from"]] <- force(stroke_from)
	l[["stroke_to"]] <- force(stroke_to)
	l[["stroke_from_opacity"]] <- force(stroke_from_opacity)
	l[["stroke_to_opacity"]] <- force(stroke_to_opacity)
	l[["stroke_width"]] <- force(stroke_width)
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
	wrap_longitude <- force( wrap_longitude )

	layer_id <- layerId(layer_id, "greatcircle")
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

	jsfunc <- "add_greatcircle_geo"
	map <- addDependency(map, mapdeckGreatCircleDependency())


	if ( tp == "sf" ) {
		geometry_column <- c( "origin", "destination" )
		shape <- rcpp_od_geojson( data, l, geometry_column, digits, "greatcircle" )
	} else if ( tp == "df" ) {
		geometry_column <- list( origin = c("start_lon", "start_lat","start_elev"), destination = c("end_lon", "end_lat","end_elev") )
		shape <- rcpp_od_geojson_df( data, l, geometry_column, digits, "greatcircle" )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- c("origin", "destination")
		shape <- rcpp_od_polyline( data, l, geometry_column, "greatcircle" )
		jsfunc <- "add_greatcircle_polyline"
	}

	js_transition <- resolve_transitions( transitions, "greatcircle" )
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer, js_transition,
		wrap_longitude, brush_radius
	)
}



#' Clear greatcircle
#'
#' @rdname clear
#' @param map a mapdeck map object
#' @param layer_id the layer_id of the layer you want to clear
#' @export
clear_greatcircle <- function( map, layer_id = NULL ) {
	layer_id <- layerId(layer_id, "greatcircle")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "greatcircle" )
}
