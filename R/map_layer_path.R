mapdeckPathDependency <- function() {
	list(
		htmltools::htmlDependency(
			"path",
			"1.0.0",
			system.file("htmlwidgets/lib/path", package = "mapdeck"),
			script = c("path.js")
		)
	)
}


#' Add Path
#'
#' The Path Layer takes in lists of coordinate points and renders them as
#' extruded lines with mitering.
#'
#' @inheritParams add_polygon
#'
#' @param stroke_opacity value between 1 and 255. Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
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
#' mapdeck(
#'   token = key
#'   , style = 'mapbox://styles/mapbox/dark-v9'
#'   , location = c(145, -37.8)
#'   , zoom = 10) %>%
#'   add_path(
#'     data = roads
#'     , stroke_colour = "RIGHT_LOC"
#'     , layer_id = "path_layer"
#'     , tooltip = "ROAD_NAME"
#'     , auto_highlight = TRUE
#'     , legend = T
#'   )
#' }
#'
#' @details
#'
#' \code{add_path} supports LINESTRING and MULTILINESTRING sf objects
#'
#' @export
add_path <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	#geometry = NULL,            ## TODO( geometry - user can specify if there are more than one )
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	tooltip = NULL,
	layer_id = NULL,
	id = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	update_view = TRUE,
	focus_layer = FALSE
) {

	## TODO(sf and lon/lat coordinates)
	#message("Using development version. Please check plots carefully")
#
# 	l <- as.list( match.call() )
# 	l[[1]] <- NULL
# 	l[["data"]] <- NULL
# 	l[["map"]] <- NULL
# 	l[["layer_id"]] <- NULL
# 	l[["auto_highlight"]] <- NULL

	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["stroke_colour"]] <- force( stroke_colour)
	l[["stroke_width"]] <- force( stroke_width )
	l[["stroke_opacity"]] <- force( stroke_opacity )
	l[["tooltip"]] <- force(tooltip)
	l[["id"]] <- force(id)
	l[["na_colour"]] <- force(na_colour)

	# l[["legend"]] <- force( legend )
	# l[["legend_options"]] <- force( legend_options )
	# l[["palette"]] <- force( palette )

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, c("LINESTRING","MULTILINESTRING") )

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

	layer_id <- layerId(layer_id, "path")
	checkHexAlpha( highlight_colour )

	map <- addDependency(map, mapdeckPathDependency())
	data_types <- data_types( data )

	#print( l )
	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" ) ## This is where we woudl also specify 'origin' or 'destination'
		shape <- rcpp_path_geojson( data, data_types, l, geometry_column )
		jsfunc <- "add_path_geo"
	} else if ( tp == "sfencoded" ) {
		jsfunc <- "add_path_polyline"
		geometry_column <- "polyline"
		shape <- rcpp_path_polyline( data, data_types, l, geometry_column )
	}

	# print(shape[["legend"]])
	# print( shape )

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer
		)
}


#' @rdname clear
#' @export
clear_path <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "path")
	invoke_method(map, "layer_clear", layer_id, "path" )
}



