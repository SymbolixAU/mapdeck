mapdeckScreengridDependency <- function() {
	list(
		createHtmlDependency(
			"screengrid",
			"1.0.0",
			system.file("htmlwidgets/lib/screengrid", package = "mapdeck"),
			script = c("screengrid.js")
		)
	)
}


#' Add Screengrid
#'
#' The Screen Grid Layer takes in an array of latitude and longitude coordinated points,
#' aggregates them into histogram bins and renders as a grid
#'
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param weight the weight of each value
#' @param colour_range vector of 6 hex colours
#' @param opacity opacity of cells. Value between 0 and 1
#' @param cell_size size of grid squares in pixels
#'
#' @inheritSection add_polygon data
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#' 'examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df <- df[ !is.na(df$lng), ]
#' df$weight <- sample(1:10, size = nrow(df), replace = T)
#'
#' mapdeck( token = key, style = mapdeck_style('dark'), pitch = 45 ) %>%
#' add_screengrid(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , weight = "weight",
#'   , layer_id = "screengrid_layer"
#'   , cell_size = 10
#'   , opacity = 0.3
#' )
#'
#' ## as an sf object
#' library(sf)
#' sf <- sf::st_as_sf( df, coords = c("lng", "lat"))
#' mapdeck( token = key, style = mapdeck_style('dark'), pitch = 45 ) %>%
#' add_screengrid(
#'   data = sf
#'   , weight = "weight",
#'   , layer_id = "screengrid_layer"
#'   , cell_size = 10
#'   , opacity = 0.3
#' )
#'
#' }
#'
#' @details
#'
#' \code{add_screengrid} supports POINT and MULTIPOINT sf objects
#'
#' @export
add_screengrid <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	weight = NULL,
	colour_range = NULL,
	opacity = 0.8,
	cell_size = 50,
	layer_id = NULL,
	update_view = TRUE,
	focus_layer = FALSE
) {
	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["weight"]] <- force( weight )
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )

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

	## parmater checks
	#usePolyline <- isUsingPolyline(polyline)
	checkNumeric(opacity)
	checkNumeric(cell_size)
	layer_id <- layerId(layer_id, "screengrid")

	if( is.null( colour_range ) ) {
		colour_range <- colourvalues::colour_values(1:6, palette = "viridis")
	}

	if(length(colour_range) != 6)
		stop("colour_range must have 6 hex colours")
	## end parameter checks

	checkHex(colour_range)

	map <- addDependency(map, mapdeckScreengridDependency())
	data_types <- data_types( data )

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_screengrid_geo"
	if( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_screengrid_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_screengrid_geojson_df( data, data_types, l, geometry_column )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_screengrid_polyline( data, data_types, l, geometry_column )
		jsfunc <- "add_screengrid_polyline"
	}

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, opacity, cell_size, colour_range,
		bbox, update_view, focus_layer
		)
}


#' @rdname clear
#' @export
clear_screengrid <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "screengrid")
	invoke_method(map, "md_layer_clear", layer_id, "screengrid" )
}

