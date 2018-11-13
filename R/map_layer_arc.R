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
#' @param origin vector of longitude and latitude columns, or an \code{sfc} column
#' @param destination vector of longitude and latitude columns, or an \code{sfc} column
#' @param id an id value in \code{data} to identify layers when interacting in Shiny apps
#' @param stroke_from variable or hex colour to use as the staring stroke colour
#' @param stroke_from_opacity Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_to variable or hex colour to use as the ending stroke colour
#' @param stroke_to_opacity Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_width width of the stroke
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
#'
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
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
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
#'   , legend_options = list(stroke_from = list( title = "Origin airport" ), css = "max-height: 100px;")
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
	palette = "viridis"
) {

	# l <- as.list( match.call( expand.dots = F) )
	# l[[1]] <- NULL
	# l[["data"]] <- NULL
	# l[["map"]] <- NULL
	# l[["auto_highlight"]] <- NULL
	# l[["light_settings"]] <- NULL
	# l[["layer_id"]] <- NULL

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

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_od_data( data, l, origin, destination )

	layer_id <- layerId(layer_id, "arc")
	checkHexAlpha(highlight_colour)

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_arc_geo"


	map <- addDependency(map, mapdeckArcDependency())
	data_types <- vapply(data, function(x) class(x)[[1]], "")

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

	invoke_method(map, jsfunc, shape[["data"]], layer_id, auto_highlight, highlight_colour, shape[["legend"]] )
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
	invoke_method(map, "clear_arc", layer_id )
}
