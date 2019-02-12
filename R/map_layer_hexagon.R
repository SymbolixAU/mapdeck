mapdeckHexagonDependency <- function() {
	list(
		createHtmlDependency(
			name = "hexagon",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/hexagon", package = "mapdeck"),
			script = c("hexagon.js")
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
#' @param radius in metres
#' @param elevation_scale value to sacle the elevations of the hexagons
#' @param colour_range vector of 6 hex colours
#' @param elevation column containing the elevation of the value. This is used to calculate the
#' height of the hexagons. The height is calculated by the sum of elevations of all the coordinates
#' within the \code{radius}. If NULL, the number of coordinates is used.
#' @param colour column containing numeric values to colour by.
#' The colour is calculated by the sum of values within the \code{radius}.
#' If NULL, the number of coordinates is used.
#'
#' @inheritSection add_polygon data
#'
#' @examples
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/'
#' , '3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df <- df[!is.na(df$lng), ]
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45) %>%
#' add_hexagon(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "hex_layer"
#'   , elevation_scale = 100
#' )
#'
#' library( sf )
#' sf <- sf::st_as_sf( df, coords = c("lng", "lat"))
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45 ) %>%
#' add_hexagon(
#'   data = sf
#'   , layer_id = "hex_layer"
#'   , elevation_scale = 100
#' )
#'
#' ## Using elevation and colour
#' df$weight <- 1
#' df$colour <- 1
#' df[10, ]$weight <- 100000
#' df[1000, ]$colour <- 100000
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45) %>%
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
	colour = NULL,
	elevation_scale = 1,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	colour_range = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL
) {

	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )
	l[["elevation"]] <- force( elevation )
	l[["colour"]] <- force( colour )

	use_weight <- FALSE
	if(!is.null(elevation)) use_weight <- TRUE

	use_colour <- FALSE
	if(!is.null(colour)) use_colour <- TRUE

	l <- resolve_data( data, l, c("POINT","MULTIPOINT") )

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
		stop("colour_range must have 6 hex colours")

	checkHex(colour_range)
	checkHexAlpha(highlight_colour)

	layer_id <- layerId(layer_id, "hexagon")
	map <- addDependency(map, mapdeckHexagonDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_hexagon_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_hexagon_geojson( data, l, geometry_column )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_hexagon_geojson_df( data, l, geometry_column )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_hexagon_polyline( data, l, geometry_column )
		jsfunc <- "add_hexagon_polyline"
	}

	js_transitions <- resolve_transitions( transitions, "hexagon" )

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, radius, elevation_scale,
		auto_highlight, highlight_colour, colour_range, bbox, update_view, focus_layer,
		js_transitions, use_weight, use_colour
		)
}


#' @rdname clear
#' @export
clear_hexagon <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "hexagon")
	invoke_method(map, "md_layer_clear", layer_id, "hexagon" )
}
