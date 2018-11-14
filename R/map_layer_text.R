mapdeckTextDependency <- function() {
	list(
		htmltools::htmlDependency(
			"text",
			"1.0.0",
			system.file("htmlwidgets/lib/text", package = "mapdeck"),
			script = c("text.js")
		)
	)
}


#' Add Text
#'
#' The Text Layer takes in coordinate points and renders them as circles
#' with a certain radius.
#'
#' @inheritParams add_scatterplot
#' @param text column of \code{data} containing the text
#' @param size column of \code{data} containing the size of the text
#' @param angle column of \code{data} containging the angle of the text
#' @param anchor column of \code{data} containing the anchor of the text. One of
#' 'start', 'middle' or 'end'
#' @param alignment_baseline column of \code{data} containing the alignment. One of
#' 'top', 'center' or 'bottom'
#' @param tooltip variable of \code{data} containing text or HTML to render as a tooltip
#'
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @examples
#'
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck(
#'   token = key,
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
	tooltip = NULL,
	layer_id = NULL,
	id = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL
) {

	# l <- as.list( match.call( expand.dots = F) )
	# l[[1]] <- NULL
	# l[["data"]] <- NULL
	# l[["map"]] <- NULL
	# l[["layer_id"]] <- NULL

	l <- list()
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )
	l[["fill_colour"]] <- force( fill_colour )
	l[["fill_opacity"]] <- force( fill_opacity )
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
	l <- resolve_data( data, l, c("POINT","MULTIPOINT"))

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	## parmater checks
	#usePolyline <- isUsingPolyline(polyline)
	checkNumeric(size)
	checkNumeric(angle)
	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "text")

	map <- addDependency(map, mapdeckTextDependency())
	data_types <- vapply(data, function(x) class(x)[[1]], "")

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_text_geo"

	if( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_text_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_text_geojson_df( data, data_types, l, geometry_column )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_text_polyline( data, data_types, l, geometry_column )
		jsfunc <- "add_text_polyline"
	}

	invoke_method(map, jsfunc, shape[["data"]], layer_id, auto_highlight, highlight_colour, shape[["legend"]])
}

#' @rdname clear
#' @export
clear_text <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "text")
	invoke_method(map, "clear_text", layer_id )
}

