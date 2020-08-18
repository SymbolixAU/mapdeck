mapdeckScreengridDependency <- function() {
	list(
		createHtmlDependency(
			name = "screengrid",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/screengrid", package = "mapdeck"),
			script = c("screengrid.js"),
			all_files = FALSE
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
#' @param weight the weight of each value. Default 1
#' @param aggregation one of 'min', 'mean', 'max', 'sum'.
#' If supplied it specifies how the weights used.
#' @param colour_range vector of 6 hex colours
#' @param opacity opacity of cells. Value between 0 and 1. Default 0.8
#' @param cell_size size of grid squares in pixels. Default 50
#'
#' @inheritSection add_polygon data
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#' 'examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df <- df[ !is.na(df$lng), ]
#' df$weight <- sample(1:10, size = nrow(df), replace = TRUE)
#'
#' mapdeck( style = mapdeck_style('dark'), pitch = 45 ) %>%
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
#' library(sfheaders)
#' sf <- sfheaders::sf_point( df, x = "lng", y = "lat")
#'
#' mapdeck( style = mapdeck_style('dark'), pitch = 45 ) %>%
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
	aggregation = c("sum","mean","min","max"),
	colour_range = NULL,
	opacity = 0.8,
	cell_size = 50,
	layer_id = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6
) {
	brush_radius = NULL
	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["weight"]] <- force( weight )
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )

	l <- resolve_data( data, l, c("POINT") )

	aggregation <- match.arg( aggregation )
	aggregation <- toupper( aggregation )

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
		stop("mapdeck - colour_range must have 6 hex colours")
	## end parameter checks

	checkHex(colour_range)

	map <- addDependency(map, mapdeckScreengridDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_screengrid_geo"
	if( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_aggregate_geojson( data, l, geometry_column, digits, "screengrid" )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_aggregate_geojson_df( data, l, geometry_column, digits, "screengrid" )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_aggregate_polyline( data, l, geometry_column, "screengrid" )
		jsfunc <- "add_screengrid_polyline"
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, opacity, cell_size, colour_range,
		bbox, update_view, focus_layer, aggregation, brush_radius
		)
}


#' @rdname clear
#' @export
clear_screengrid <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "screengrid")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "screengrid" )
}

