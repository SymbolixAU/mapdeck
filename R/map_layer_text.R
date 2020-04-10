mapdeckTextDependency <- function() {
	list(
		createHtmlDependency(
			name = "text",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/text", package = "mapdeck"),
			script = c("text.js"),
			all_files = FALSE
		)
	)
}


#' Add Text
#'
#' The Text Layer renders text labels on the map
#'
#' @inheritParams add_scatterplot
#' @param text column of \code{data} containing the text. The data must be a character.
#' @param size column of \code{data} containing the size of the text. Default 32
#' @param angle column of \code{data} containging the angle of the text. Default 0
#' @param anchor column of \code{data} containing the anchor of the text. One of
#' 'start', 'middle' or 'end'
#' @param alignment_baseline column of \code{data} containing the alignment. One of
#' 'top', 'center' or 'bottom'
#' @param billboard logical indicating if the text always faces the camera (TRUE) or
#' if it always faces up (FALSE)
#' @param font_family specifies a prioritised list of one or more font family names and/or
#' generic family names. Follow the specifics for CSS font-family
#' \url{https://developer.mozilla.org/en-US/docs/Web/CSS/font-family}
#' @param font_weight specifies the font weight. Follow the specifics for CSS font-weight
#' \url{https://htmldog.com/references/css/properties/font-weight/}
#' @param tooltip variable of \code{data} containing text or HTML to render as a tooltip
#'
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for text
#'
#' list(
#' position = 0,
#' fill_colour = 0,
#' angle = 0,
#' size = 0
#' )
#'
#' @examples
#'
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' mapdeck(
#'   style = mapdeck_style('dark')
#' ) %>%
#'   add_text(
#'     data = capitals
#'     , lon = 'lon'
#'     , lat = 'lat'
#'     , fill_colour = 'country'
#'     , text = 'capital'
#'     , layer_id = 'text'
#'   )
#' }
#'
#' @details
#'
#' \code{add_text} supports POINT and MULTIPOINT sf objects
#'
#' @export
add_text <- function(
	map,
	data = get_map_data(map),
	text,
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	size = NULL,
	angle = NULL,
	anchor = NULL,
	alignment_baseline = NULL,
	billboard = TRUE,
	font_family = 'Monaco, monospace',
	font_weight = "normal",
	tooltip = NULL,
	layer_id = NULL,
	id = NULL,
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

	l <- list()
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )
	l[["fill_colour"]] <- force( fill_colour )
	l[["fill_opacity"]] <- resolve_opacity( fill_opacity )
	l[["size"]] <- force( size )
	l[["text"]] <- force( text )
	l[["polyline"]] <- force( polyline )
	l[["angle"]] <- force( angle )
	l[["anchor"]] <- force( anchor )
	l[["alignment_baseline"]] <- force( alignment_baseline )
	l[["tooltip"]] <- force(tooltip)
	l[["id"]] <- force(id)
	l[["na_colour"]] <- force(na_colour)

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, c("POINT"))

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

	## parmater checks
	#usePolyline <- isUsingPolyline(polyline)
	# checkNumeric(size)
	# checkNumeric(angle)
	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "text")

	map <- addDependency(map, mapdeckTextDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_text_geo"

	if( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_text_geojson( data, l, geometry_column, digits )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_text_geojson_df( data, l, geometry_column, digits )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_text_polyline( data, l, geometry_column )
		jsfunc <- "add_text_polyline"
	}

	js_transitions <- resolve_transitions( transitions, "text" )
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, auto_highlight, highlight_colour,
		shape[["legend"]], bbox, update_view, focus_layer, js_transitions, billboard,
		font_family, font_weight, brush_radius
		)
}

#' @rdname clear
#' @export
clear_text <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "text")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "text" )
}

