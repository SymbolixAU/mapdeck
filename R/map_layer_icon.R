mapdeckIconDependency <- function() {
	list(
		createHtmlDependency(
			name = "icon",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/icon", package = "mapdeck"),
			script = c("icon.js"),
			all_files = FALSE
		)
	)
}

#' Add icons
#'
#' The Icon Layer takes in coordinate points and renders them as icons
#' with a certain size.
#'
#' @inheritParams add_scatterplot
#' @inheritParams add_polygon
#' @param size in pixels. Default 1
#' @param size_min_pixels the minimum size in pixels.
#' small for the given zoom level
#' @param size_max_pixels the maximum size in pixels.
#' @param icon The URL/path of the icon(s).
#' @param icon_width The width of the icon in pixels.
#' @param icon_height The height of the icon in pixels.
#' @param colour column containing numeric values to colour by.
#' @param colour column containing numeric values to colour by.
#'
#' @inheritSection add_polygon data
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
#' Available transitions for icons
#'
#' list(
#' position = 0,
#' colour = 0,
#' size = 0,
#' angle = 0
#' )
#'
#' @examples
#'
#' \donttest{
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
#'   add_icon(
#'     data.frame(
#'       lon = 174.768, lat = -36.852,
#'       icon = "https://www.r-project.org/logo/Rlogo.png",
#'       width = 724, height = 561
#'     ),
#'     lat = "lat",
#'     lon = "lon",
#'     icon = "icon",
#'     icon_width = "width",
#'     icon_height = "height",
#'     size = 100
#'   )
#'
#'
#' }
#'
#' @details
#'
#' \code{add_icon} supports POINT and MULTIPOINT sf objects
#'
#' @export
add_icon <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	icon = NULL,
	icon_width = NULL,
	icon_height = NULL,
	icon_anchorX = NULL,
	icon_anchorY = NULL,
	size = NULL,
	size_min_pixels = 1,
	size_max_pixels = NULL,
	colour = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	legend_format = NULL,
	digits = 6,
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL,
	brush_radius = NULL
) {

	l <- list()
	l[["lon"]] <- force(lon)
	l[["lat"]] <- force(lat)
	l[["icon"]] <- force(icon)
	l[["icon_width"]] <- force(icon_width)
	l[["icon_height"]] <- force(icon_height)
	l[["icon_anchorX"]] <- force(icon_anchorX)
	l[["icon_anchorY"]] <- force(icon_anchorY)
	l[["size"]] <- force(size)
	l[["colour"]] <- force(colour)
	l[["tooltip"]] <- force(tooltip)
	l[["id"]] <- force(id)
	l[["na_colour"]] <- force(na_colour)

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, c( "POINT", "MULTIPOINT") )

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

	layer_id <- layerId(layer_id, "icon")
	checkHexAlpha(highlight_colour)

	map <- addDependency(map, mapdeckIconDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_icon_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_point_geojson( data, l, geometry_column, digits, "scatterplot" )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_point_geojson_df( data, l, geometry_column, digits, "scatterplot" )
	}

	js_transitions <- resolve_transitions( transitions, "icon" )
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, auto_highlight, highlight_colour,
		shape[["legend"]], bbox, update_view, focus_layer, js_transitions,
		size_min_pixels, size_max_pixels, brush_radius
	)
}

#' @rdname clear
#' @export
clear_icon <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "icon")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "icon" )
}
