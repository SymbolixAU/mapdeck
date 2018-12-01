mapdeckArcDependency <- function() {
	list(
		htmltools::htmlDependency(
			"arc",
			"1.0.0",
			system.file("htmlwidgets/lib/arc", package = "mapdeck"),
			script = c("arc.js")
		)
	)
}


#' Add arc
#'
#' The Arc Layer renders raised arcs joining pairs of source and target coordinates
#'
#' @param map a mapdeck map object
#' @param data data to be used in the layer
#' @param layer_id single value specifying an id for the layer. Use this value to
#' distinguish between shape layers of the same type. Layers with the same id are likely
#' to conflict and not plot correctly
#' @param origin vector of longitude and latitude columns, or an \code{sfc} column.
#' transition enabled
#' @param destination vector of longitude and latitude columns, or an \code{sfc} column.
#' transition enabled
#' @param id an id value in \code{data} to identify layers when interacting in Shiny apps.
#' @param stroke_from variable or hex colour to use as the staring stroke colour.
#' transition enabled
#' @param stroke_from_opacity Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_to variable or hex colour to use as the ending stroke colour.
#' transition enabled
#' @param stroke_to_opacity Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_width width of the stroke. transition enabled
#' @param tooltip variable of \code{data} containing text or HTML to render as a tooltip
#' @param auto_highlight logical indicating if the shape under the mouse should auto-highlight
#' @param highlight_colour hex string colour to use for highlighting. Must contain the alpha component.
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#' @param palette string or matrix. String is either one of "viridis","inferno",
#' "magma","plasma" or "cividis". A matrix is a 3 or 4 column numeric matrix of values
#' between [0, 255], where the 4th column represents the alpha.
#' @param legend either a logical indiciating if the legend(s) should be displayed, or
#' a named list indicating which colour attributes should be included in the legend.
#' @param legend_options A list of options for controlling the legend.
#' @param update_view logical indicating if the map should update the bounds to include this layer
#' @param focus_layer logical indicating if the map should update the bounds to only include this layer
#' @param transitions
#'
#' @section id:
#'
#' The \code{id} is returned to your R session from an interactive shiny environment
#' by observing layer clicks. This is useful for returning the data.frame row relating to the
#' cliked shape.
#'
#' From within a shiny server you would typically use \code{ observeEvent({input$map_arc_click})},
#' where 'map' is the map_id supplied to \code{mapdeckOutput()}, and 'arc' is the layer
#' you are clicking on
#'
#' @section legend:
#'
#' The \code{legend_options} can be used to control the appearance of the legend.
#' This should be a named list, where the names are one of
#' \itemize{
#'   \item{css - a string of valid \code{css} for controlling the appearance of the legend}
#'   \item{title - a string to use for the title of the legend}
#' }
#'
#' If the layer allows different fill and stroke colours, you can use different options for each. See examples in \link{add_arc}.
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
#' flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45 ) %>%
#'   add_arc(
#'   data = flights
#'   , layer_id = "arc_layer"
#'   , origin = c("start_lon", "start_lat")
#'   , destination = c("end_lon", "end_lat")
#'   , stroke_from = "airport1"
#'   , stroke_to = "airport2"
#'   , stroke_width = "stroke"
#'   , tooltip = "info"
#'   , auto_highlight = TRUE
#'   , legend = T
#'   , legend_options = list(
#'     stroke_from = list( title = "Origin airport" ),
#'     css = "max-height: 100px;")
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
#'  add_arc(
#'    data = sf_flights
#'    , origin = 'geometry'
#'    , destination = 'geometry.1'
#'    , layer_id = 'arcs'
#'    , stroke_from = "airport1"
#'    , stroke_to = "airport2"
#' )
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
add_arc <- function(
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
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	legend = F,
	legend_options = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL
) {

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

	layer_id <- layerId(layer_id, "arc")
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
	jsfunc <- "add_arc_geo"

	map <- addDependency(map, mapdeckArcDependency())
	data_types <- data_types( data )

  if ( tp == "sf" ) {
		geometry_column <- c( "origin", "destination" )
		shape <- rcpp_arc_geojson( data, data_types, l, geometry_column )
  } else if ( tp == "df" ) {
  	geometry_column <- list( origin = c("start_lon", "start_lat"), destination = c("end_lon", "end_lat") )
  	shape <- rcpp_arc_geojson_df( data, data_types, l, geometry_column )
  } else if ( tp == "sfencoded" ) {
  	geometry_column <- c("origin", "destination")
  	shape <- rcpp_arc_polyline( data, data_types, l, geometry_column )
  	jsfunc <- "add_arc_polyline"
  }

	js_transition <- resolve_transitions( transitions, "arc" )

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer, js_transition
		)
}



#' Clear Arc
#'
#' Clears elements from a map
#' @rdname clear
#' @param map a mapdeck map object
#' @param layer_id the layer_id of the layer you want to clear
#' @export
clear_arc <- function( map, layer_id = NULL ) {
	layer_id <- layerId(layer_id, "arc")
	invoke_method(map, "layer_clear", layer_id, "arc" )
}
