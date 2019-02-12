mapdeckContourDependency <- function() {
	list(
		htmltools::htmlDependency(
			"contour",
			"1.0.0",
			system.file("htmlwidgets/lib/contour", package = "mapdeck"),
			script = c("contour.js")
		)
	)
}


#' Add Contour
#'
#'
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param cell_size size of each cell in meters
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
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45 ) %>%
#' add_contour(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , cell_size = 5000
#' )
#'
#' ## using sf object
#' library(sf)
#' sf <- sf::st_as_sf( df, coords = c("lng", "lat"))
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45 ) %>%
#' add_contour(
#'   data = sf
#'   , cell_size = 5000
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
add_contour <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	cell_size = 1000,
	layer_id = NULL,
	digits = 6
) {

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
	checkNumeric(cell_size)
	layer_id <- layerId(layer_id, "contour")

	map <- addDependency(map, mapdeckContourDependency())
	data_types <- data_types( data )

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_contour_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_contour_geojson( data, l, geometry_column, digits )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_contour_geojson_df( data, l, geometry_column, digits )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_contour_polyline( data, l, geometry_column )
		jsfunc <- "add_contour_polyline"
	}

	invoke_method(map, jsfunc, shape[["data"]], layer_id, cell_size)
}


#' @rdname clear
#' @export
clear_contour <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "contour")
	invoke_method(map, "clear_contour", layer_id )
}
