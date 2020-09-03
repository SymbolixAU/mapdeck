mapdeckHexagonDependency <- function() {
	list(
		createHtmlDependency(
			name = "hexagon",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/hexagon", package = "mapdeck"),
			script = c("hexagon.js"),
			all_files = FALSE
		)
	)
}


#' Add hexagon
#'
#' The Hexagon Layer renders a hexagon heatmap based on an array of points.
#' It takes the radius of hexagon bin, projects points into hexagon bins.
#' The color and height of the hexagon is scaled by number of points it contains.
#'
#' @inheritParams add_arc
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param polyline column of \code{data} containing the polylines
#' @param radius in metres. Default 1000
#' @param elevation_scale value to sacle the elevations of the hexagons. Default 1
#' @param colour_range vector of 6 hex colours
#' @param elevation column containing the elevation of the value.
#' @param elevation_function one of 'min', 'mean', 'max', 'sum'.
#' IF supplied it specifies how the elevation values are calcualted. Defaults to sum.
#' @param colour column containing numeric values to colour by.
#' @param colour_function one of 'min', 'mean', 'max', 'sum'.
#' If supplied it specifies how the colour values are calculated. Defaults to sum.
#' @param legend logical indicating if a legend should be displayed
#'
#' @inheritSection add_polygon data
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for hexagon
#'
#' list(
#' elevation = 0
#' colour = 0
#' )
#'
#' @examples
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/'
#' , '3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df <- df[!is.na(df$lng), ]
#'
#' mapdeck( style = mapdeck_style("dark"), pitch = 45) %>%
#' add_hexagon(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "hex_layer"
#'   , elevation_scale = 100
#' )
#'
#' library(sfheaders)
#' sf <- sfheaders::sf_point( df, x = "lng", y = "lat" )
#'
#' mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
#' add_hexagon(
#'   data = sf
#'   , layer_id = "hex_layer"
#'   , elevation_scale = 100
#' )
#'
#' ## Using elevation and colour
#' df$colour <- rnorm(nrow(df))
#' df$elevation <- rnorm(nrow(df))
#'
#' mapdeck( style = mapdeck_style("dark"), pitch = 45) %>%
#' add_hexagon(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "hex_layer"
#'   , elevation_scale = 100
#'   , elevation = "weight"
#'   , colour = "colour"
#' )
#'
#' mapdeck( style = mapdeck_style("dark"), pitch = 45) %>%
#' add_hexagon(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "hex_layer"
#'   , elevation_scale = 100
#'   , elevation = "weight"
#'   , elevation_function = "mean"
#'   , colour = "colour"
#'   , colour_function = "mean"
#' )
#'
#' ## with a legend
#' df$val <- sample(1:10, size = nrow(df), replace = TRUE)
#'
#' mapdeck( style = mapdeck_style("dark"), pitch = 45) %>%
#' add_hexagon(
#' 	data = df
#' 	, lat = "lat"
#' 	, lon = "lng"
#' 	, layer_id = "hex_layer"
#' 	, elevation_scale = 100
#' 	, legend = TRUE
#' 	, legend_options = list( digits = 0 )
#' 	, colour_function = "mean"
#' 	, colour = "val"
#' )
#'
#' }
#'
#' @details
#'
#' \code{add_hexagon} supports POINT and MULTIPOINT sf objects
#'
#'
#' @export
add_hexagon <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	lon = NULL,
	lat = NULL,
	layer_id = NULL,
	radius = 1000,
	elevation = NULL,
	elevation_function = c("sum","mean","min","max"),
	colour = NULL,
	colour_function = c("sum","mean","min","max"),
	legend = FALSE,
	legend_options = NULL,
	elevation_scale = 1,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	colour_range = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6,
	transitions = NULL,
	brush_radius = NULL
) {

	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )
	l[["elevation"]] <- force( elevation )
	l[["colour"]] <- force( colour )

	colour_function <- match.arg( colour_function )
	colour_function <- toupper( colour_function )

	elevation_function <- match.arg( elevation_function )
	elevation_function <- toupper( elevation_function )

	legend <- force( legend )
	legend <- aggregation_legend( legend, legend_options )

	use_weight <- FALSE
	if(!is.null(elevation)) use_weight <- TRUE

	use_colour <- FALSE
	if(!is.null(colour)) use_colour <- TRUE

	l <- resolve_data( data, l, c("POINT") )

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

	if( is.null( colour_range ) ) {
		colour_range <- colourvalues::colour_values(1:6, palette = "viridis")
	}

	if(length(colour_range) != 6)
		stop("mapdeck - colour_range must have 6 hex colours")

	checkHex(colour_range)
	checkHexAlpha(highlight_colour)

	layer_id <- layerId(layer_id, "hexagon")
	map <- addDependency(map, mapdeckHexagonDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_hexagon_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_aggregate_geojson( data, l, geometry_column, digits, "hexagon" )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_aggregate_geojson_df( data, l, geometry_column, digits, "hexagon" )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_aggregate_polyline( data, l, geometry_column, "hexagon" )
		jsfunc <- "add_hexagon_polyline"
	}

	js_transitions <- resolve_transitions( transitions, "hexagon" )

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, radius, elevation_scale,
		auto_highlight, highlight_colour, colour_range, bbox, update_view, focus_layer,
		js_transitions, use_weight, use_colour, elevation_function, colour_function, legend,
		brush_radius
		)
}


#' @rdname clear
#' @export
clear_hexagon <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "hexagon")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "hexagon" )
}
