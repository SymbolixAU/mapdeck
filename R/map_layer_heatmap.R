mapdeckHeatmapDependency <- function() {
	list(
		createHtmlDependency(
			name = "heatmap",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/heatmap", package = "mapdeck"),
			script = c("heatmap.js"),
			all_files = FALSE
		)
	)
}


#' Add Heatmap
#'
#' The Screen Grid Layer takes in an array of latitude and longitude coordinated points,
#' aggregates them into histogram bins and renders as a grid
#'
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param weight the weight of each value. Default 1
#' @param colour_range vector of 6 hex colours
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
#' df$weight <- sample(1:10, size = nrow(df), replace = T)
#'
#' mapdeck( style = mapdeck_style('dark'), pitch = 45 ) %>%
#' add_heatmap(
#'   data = df[1:1000, ]
#'   , lat = "lat"
#'   , lon = "lng"
#'   , weight = "weight",
#'   , layer_id = "heatmap_layer"
#' )
#'
#' ## as an sf object
#' library(sf)
#' sf <- sf::st_as_sf( df, coords = c("lng", "lat"))
#' mapdeck( token = key, style = mapdeck_style('dark'), pitch = 45 ) %>%
#' add_heatmap(
#'   data = sf
#'   , weight = "weight",
#'   , layer_id = "heatmap_layer"
#' )
#'
#' }
#'
#' @details
#'
#' \code{add_heatmap} supports POINT and MULTIPOINT sf objects
#'
#' @export
add_heatmap <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	weight = NULL,
	colour_range = NULL,
	layer_id = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6
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
	layer_id <- layerId(layer_id, "heatmap")

	if( is.null( colour_range ) ) {
		colour_range <- colourvalues::colour_values(1:6, palette = "viridis")
	}

	if(length(colour_range) != 6)
		stop("mapdeck - colour_range must have 6 hex colours")
	## end parameter checks

	checkHex(colour_range)

	map <- addDependency(map, mapdeckHeatmapDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_heatmap_geo"
	if( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_heatmap_geojson( data, l, geometry_column, digits )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_heatmap_geojson_df( data, l, geometry_column, digits )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_heatmap_polyline( data, l, geometry_column )
		jsfunc <- "add_heatmap_polyline"
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, colour_range,
		bbox, update_view, focus_layer
	)
}


#' @rdname clear
#' @export
clear_heatmap <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "heatmap")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "heatmap" )
}

