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
#' The Heatmap Layer can be used to visualise spatial distribution of data.
#' It implements Gaussian Kernel Density Estimation to render the heatmaps.
#'
#' @section note:
#'
#' The current version of this layer is supported only for WebGL2 enabled browswers
#' So you may find it doesn't render in the RStudio viewer.
#'
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param weight the weight of each value. Default 1
#' @param colour_range vector of 6 hex colours
#' @param radius_pixels Radius of the circle in pixels, to which the weight of an object is distributed
#' @param intensity Value that is multiplied with the total weight at a pixel to
#' obtain the final weight. A value larger than 1 biases the output color towards
#' the higher end of the spectrum, and a value less than 1 biases the output
#' color towards the lower end of the spectrum
#' @param threshold The HeatmapLayer reduces the opacity of the pixels with relatively
#' low weight to create a fading effect at the edge.
#' A larger threshold smoothens the boundaries of color blobs, while making pixels
#' with low relative weight harder to spot (due to low alpha value).
#' Threshold is defined as the ratio of the fading weight to the max weight, between 0 and 1.
#' For example, 0.1 affects all pixels with weight under 10\% of the max.
#'
#' @inheritSection add_polygon data
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for heatmap
#'
#' list(
#' intensity = 0,
#' threshold = 0,
#' radius_pixels = 0
#' )
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
#' add_heatmap(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , weight = "weight",
#'   , layer_id = "heatmap_layer"
#' )
#'
#' ## as an sf object
#' library(sfheaders)
#' sf <- sfheaders::sf_point( df, x = "lng", y = "lat")
#'
#' mapdeck( style = mapdeck_style('dark'), pitch = 45 ) %>%
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
	radius_pixels = 30,
	intensity = 1,
	threshold = 0.05,
	layer_id = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6,
	transitions = NULL
) {

	#experimental_layer("heatmap")

	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["weight"]] <- force( weight )
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )

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
		shape <- rcpp_aggregate_geojson( data, l, geometry_column, digits, "heatmap" )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_aggregate_geojson_df( data, l, geometry_column, digits, "heatmap" )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_aggregate_polyline( data, l, geometry_column, "heatmap" )
		jsfunc <- "add_heatmap_polyline"
	}

	js_transitions <- resolve_transitions( transitions, "heatmap" )

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, colour_range,
		radius_pixels, intensity, threshold, bbox, update_view, focus_layer, js_transitions
	)
}


#' @rdname clear
#' @export
clear_heatmap <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "heatmap")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "heatmap" )
}
