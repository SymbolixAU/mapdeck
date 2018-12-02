mapdeckScatterplotDependency <- function() {
	list(
		htmltools::htmlDependency(
			"scatterplot",
			"1.0.0",
			system.file("htmlwidgets/lib/scatterplot", package = "mapdeck"),
			script = c("scatterplot.js")
		)
	)
}


#' Add Scatterplot
#'
#' The Scatterplot Layer takes in coordinate points and renders them as circles
#' with a certain radius.
#'
#' @inheritParams add_polygon
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param radius in metres
#' @param palette string or matrix. String is either one of "viridis","inferno",
#' "magma","plasma" or "cividis". A matrix is a 3 or 4 column numeric matrix of values
#' between [0, 255], where the 4th column represents the alpha.
#'
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny).
#' The time is in milliseconds
#'
#' Available transitions for scatterplot
#'
#' list(
#' position = 0,
#' fill_colour = 0,
#' radius = 0
#' )
#'
#' @examples
#'
#' \donttest{
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45 ) %>%
#' add_scatterplot(
#'   data = capitals
#'   , lat = "lat"
#'   , lon = "lon"
#'   , radius = 100000
#'   , fill_colour = "country"
#'   , layer_id = "scatter_layer"
#'   , tooltip = "capital"
#' )
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
#' 'examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df <- df[ !is.na(df$lng), ]
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45 ) %>%
#' add_scatterplot(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "scatter_layer"
#' )
#'
#' ## as an sf object
#' library(sf)
#' sf <- sf::st_as_sf( capitals, coords = c("lon", "lat") )
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45 ) %>%
#' add_scatterplot(
#'   data = sf
#'   , radius = 100000
#'   , fill_colour = "country"
#'   , layer_id = "scatter_layer"
#'   , tooltip = "capital"
#' )
#'
#' }
#'
#' @details
#'
#' \code{add_scatterplot} supports POINT and MULTIPOINT sf objects
#'
#' @export
add_scatterplot <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	radius = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL
) {

	l <- list()
	l[["lon"]] <- force(lon)
	l[["lat"]] <- force(lat)
	l[["polyline"]] <- force(polyline)
	l[["radius"]] <- force(radius)
	l[["fill_colour"]] <- force(fill_colour)
	l[["fill_opacity"]] <- force(fill_opacity)
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

	layer_id <- layerId(layer_id, "scatterplot")
	checkHexAlpha(highlight_colour)

	map <- addDependency(map, mapdeckScatterplotDependency())
	data_types <- data_types( data )


	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_scatterplot_geo"
	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_scatterplot_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_scatterplot_geojson_df( data, data_types, l, geometry_column )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- c( "polyline" )
		shape <- rcpp_scatterplot_polyline( data, data_types, l, geometry_column )
		jsfunc <- "add_scatterplot_polyline"
	}

	js_transitions <- resolve_transitions( transitions, "scatterplot" )

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, auto_highlight, highlight_colour,
		shape[["legend"]], bbox, update_view, focus_layer, js_transitions
		)
}

resolve_args <- function( l, layer_args ) {

	## This implementation will allow variables passed in as column names
	## but NOT un-quoted column variables
	x <- vapply(names(l), function(x) { x %in% layer_args }, T)
	x <- x[x]    ## x is the set of arguments we need to evaluate
	l <- l[names(x)]
	lapply( l, eval )
}


## args used which can be columns of 'data'
scatterplot_data_args <- function() {
	return(
		c("lon", "lat", "polyline", "radius", "fill_colour", "fill_opacity", "tooltip")
	)
}


#' @rdname clear
#' @export
clear_scatterplot <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "scatterplot")
	invoke_method(map, "md_layer_clear", layer_id, "scatterplot" )
}
