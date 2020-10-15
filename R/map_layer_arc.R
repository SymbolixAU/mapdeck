mapdeckArcDependency <- function() {
	list(
		createHtmlDependency(
			name = "arc",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/arc", package = "mapdeck"),
			script = c("arc.js"),
			all_files = FALSE
		)
	)
}


#' Add arc
#'
#' The Arc Layer renders raised arcs joining pairs of source and target coordinates
#'
#' @param map a mapdeck map object
#' @param data data to be used in the layer. All coordinates are expected to be
#' EPSG:4326 (WGS 84) coordinate system
#' @param layer_id single value specifying an id for the layer. Use this value to
#' distinguish between shape layers of the same type. Layers with the same id are likely
#' to conflict and not plot correctly
#' @param origin vector of longitude and latitude columns, and optionally an elevation column,
#' or an \code{sfc} column
#' @param destination vector of longitude and latitude columns, and optionally an elevatino column,
#' or an \code{sfc} column
#' @param id an id value in \code{data} to identify layers when interacting in Shiny apps.
#' @param stroke_from column of \code{data} or hex colour to use as the staring stroke colour.
#' IIf using a hex colour, use either a single value, or a column of hex colours  on \code{data}
#' @param stroke_from_opacity Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes. If a hex-string is used as the
#' colour, this argument is ignored and you should include the alpha on the hex string
#' @param stroke_to column of \code{data} or hex colour to use as the ending stroke colour.
#' If using a hex colour, use either a single value, or a column of hex colours  on \code{data}
#' @param stroke_to_opacity Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes. If a hex-string is used as the
#' colour, this argument is ignored and you should include the alpha on the hex string
#' @param stroke_width width of the stroke in pixels
#' @param height value to multiply the height.
#' @param tilt value to tilt the arcs to the side, in degrees [-90, 90]
#' @param tooltip variable of \code{data} containing text or HTML to render as a tooltip
#' @param auto_highlight logical indicating if the shape under the mouse should auto-highlight
#' @param highlight_colour hex string colour to use for highlighting. Must contain the alpha component.
#' @param palette string or matrix. String will be one of \code{colourvalues::colour_palettes()}.
#' A matrix must have at least 5 rows, and 3 or 4 columns of values between [0, 255],
#' where the 4th column represents the alpha. You can use a named list to specify a different
#' palette for different colour options (where available),
#'  e.g. list(fill_colour = "viridis", stroke_colour = "inferno")
#' @param na_colour hex string colour to use for NA values
#' @param legend either a logical indiciating if the legend(s) should be displayed, or
#' a named list indicating which colour attributes should be included in the legend.
#' @param legend_options A list of options for controlling the legend.
#' @param legend_format A list containing functions to apply to legend values. See section legend
#' @param update_view logical indicating if the map should update the bounds to include this layer
#' @param focus_layer logical indicating if the map should update the bounds to only include this layer
#' @param transitions list specifying the duration of transitions.
#' @param brush_radius radius of the brush in metres. Default NULL. If supplied,
#' the arcs will only show if the origin or destination are within the radius of the mouse.
#' If NULL, all arcs are displayed
#' @param digits number of digits for rounding coordinates
#'
#' @section data:
#'
#' If \code{data} is a simple feature object, you need to supply the origin and destination
#' columns, they aren't automatically detected.
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
#'   \item{digits - number to round the legend values to}
#' }
#'
#' If the layer allows different fill and stroke colours, you can use different options for each. See examples in \link{add_arc}.
#'
#' The \code{legend_format} can be used to control the format of the values in the legend.
#' This should be a named list, where the names are one of
#' \itemize{
#'   \item{fill_colour}
#'   \item{stroke_colour}
#' }
#'
#' depending on which type of colouring the layer supports.
#'
#' The list elements must be functions to apply to the values in the legend.
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for arc
#'
#' list(
#' origin = 0,
#' destination = 0,
#' stroke_from = 0,
#' stroke_to = 0,
#' stroke_width = 0
#' )
#'
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
#'   , legend = TRUE
#'   , legend_options = list(
#'     stroke_from = list( title = "Origin airport" ),
#'     css = "max-height: 100px;")
#'  )
#'
#' mapdeck( style = mapdeck_style("dark")) %>%
#'   add_arc(
#'   data = flights
#'   , layer_id = "arc_layer"
#'   , origin = c("start_lon", "start_lat")
#'   , destination = c("end_lon", "end_lat")
#'   , stroke_from = "airport1"
#'   , stroke_to = "airport2"
#'   , stroke_width = "stroke"
#'   )
#'
#' ## Arcs can have an elevated start & destination
#' flights$start_elev <- sample(100000:1000000, size = nrow(flights), replace = TRUE )
#'
#' mapdeck( style = mapdeck_style("dark")) %>%
#'   add_arc(
#'   data = flights
#'   , layer_id = "arc_layer"
#'   , origin = c("start_lon", "start_lat", "start_elev")
#'   , destination = c("end_lon", "end_lat", "start_elev")
#'   , stroke_from = "airport1"
#'   , stroke_to = "airport2"
#'   , stroke_width = "stroke"
#'   )
#'
#' ## Using a 2-sfc-column sf object
#' library(sfheaders)
#'
#' sf_flights <- sfheaders::sf_point(
#'   flights
#'   , x = "start_lon"
#'   , y = "start_lat"
#'   , z = "start_elev"
#'   , keep = TRUE
#'   )
#' destination <- sfheaders::sfc_point(
#'   flights
#'   , x = "end_lon"
#'   , y = "end_lat"
#'   , z = "start_elev"
#'   )
#'
#' sf_flights$destination <- destination
#'
#' mapdeck(
#' ) %>%
#'  add_arc(
#'    data = sf_flights
#'    , origin = 'geometry'
#'    , destination = 'destination'
#'    , layer_id = 'arcs'
#'    , stroke_from = "airport1"
#'    , stroke_to = "airport2"
#' )
#'
#' ## using a brush
#'
#' mapdeck(
#'   , style = mapdeck_style("light")
#' ) %>%
#'  add_arc(
#'    data = sf_flights
#'    , origin = 'geometry'
#'    , destination = 'destination'
#'    , layer_id = 'arcs'
#'    , stroke_from = "airport1"
#'    , stroke_to = "airport2"
#'    , stroke_width = 4
#'    , brush_radius = 500000
#' )
#'
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

	l <- list()
	l[["origin"]] <- force(origin)
	l[["destination"]] <- force(destination)
	l[["stroke_from"]] <- force(stroke_from)
	l[["stroke_to"]] <- force(stroke_to)
	l[["stroke_from_opacity"]] <- force(stroke_from_opacity)
	l[["stroke_to_opacity"]] <- force(stroke_to_opacity)
	l[["stroke_width"]] <- force(stroke_width)
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

	# if(!is.null(brush_radius)) {
	# 	jsfunc <- "add_arc_brush_geo"
	# 	map <- addDependency(map, mapdeckArcBrushDependency())
	# } else {
		jsfunc <- "add_arc_geo"
		map <- addDependency(map, mapdeckArcDependency())
	# }

  if ( tp == "sf" ) {
		geometry_column <- c( "origin", "destination" )
		shape <- rcpp_od_geojson( data, l, geometry_column, digits, "arc" )
  } else if ( tp == "df" ) {
  	geometry_column <- list( origin = c("start_lon", "start_lat", "start_elev"), destination = c("end_lon", "end_lat", "end_elev") )
  	shape <- rcpp_od_geojson_df( data, l, geometry_column, digits, "arc" )
  } else if ( tp == "sfencoded" ) {
  	geometry_column <- c("origin", "destination")
  	shape <- rcpp_od_polyline( data, l, geometry_column, "arc" )
  	# if(!is.null(brush_radius)) {
  	# 	jsfunc <- "add_arc_brush_polyline"
  	# } else {
  	#   jsfunc <- "add_arc_polyline"
  	# }
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
		brush_radius
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
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "arc" )
}
