mapdeckGridDependency <- function() {
	list(
		htmltools::htmlDependency(
			"grid",
			"1.0.0",
			system.file("htmlwidgets/lib/grid", package = "mapdeck"),
			script = c("grid.js")
		)
	)
}


#' Add Grid
#'
#' The Grid Layer renders a grid heatmap based on an array of points.
#' It takes the constant size all each cell, projects points into cells.
#' The color and height of the cell is scaled by number of points it contains.
#'
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param colour_range vector of 6 hex colours
#' @param cell_size size of each cell in meters
#' @param extruded logical indicating if cells are elevated or not
#' @param elevation_scale cell elevation multiplier
#'
#' @examples
#' \donttest{
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#' 'examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df <- df[ !is.na(df$lng ), ]
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_grid(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , cell_size = 5000
#'   , elevation_scale = 50
#'   , layer_id = "grid_layer"
#'   , auto_highlight = TRUE
#' )
#'
#' ## using sf object
#' library(sf)
#' sf <- sf::st_as_sf( df, coords = c("lng", "lat"))
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_grid(
#'   data = sf
#'   , cell_size = 5000
#'   , elevation_scale = 50
#'   , layer_id = "grid_layer"
#'   , auto_highlight = TRUE
#' )
#'
#'
#' }
#'
#' @details
#'
#' \code{add_grid} supports POINT and MULTIPOINT sf objects
#'
#'
#'
#' @export
add_grid <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	colour_range = colourvalues::colour_values(1:6, palette = "viridis"),
	cell_size = 1000,
	extruded = TRUE,
	elevation_scale = 1,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	layer_id = NULL,
	id = NULL
) {

	# l <- as.list( match.call( expand.dots = F) )
	# l[[1]] <- NULL
	# l[["data"]] <- NULL
	# l[["map"]] <- NULL
	# l[["elevation_scale"]] <- NULL
	# l[["cell_size"]] <- NULL
	# l[["colour_range"]] <- NULL
	# l[["auto_highlight"]] <- NULL
	# l[["layer_id"]] <- NULL
	l <- list()
	l[["lon"]] <- force(lon)
	l[["lat"]] <- force(lat)
	l[["polyline"]] <- force(polyline)

	l <- resolve_data( data, l, c("POINT","MULTIPOINT") )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	## parmater checks
	usePolyline <- isUsingPolyline(polyline)
	checkNumeric(elevation_scale)
	checkNumeric(cell_size)
	checkHex(colour_range)
	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "grid")

	map <- addDependency(map, mapdeckGridDependency())
	data_types <- data_types( data )

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_grid_geo"

	if ( tp == "sf" ) {
	  geometry_column <- c( "geometry" )
	  shape <- rcpp_grid_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_grid_geojson_df( data, data_types, l, geometry_column )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_grid_polyline( data, data_types, l, geometry_column )
		jsfunc <- "add_grid_polyline"
	}

	# print( shape )

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, cell_size,
		jsonlite::toJSON(extruded, auto_unbox = T), elevation_scale,
		colour_range, auto_highlight, highlight_colour
		)
}


#' @rdname clear
#' @export
clear_grid <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "grid")
	invoke_method(map, "clear_grid", layer_id )
}
