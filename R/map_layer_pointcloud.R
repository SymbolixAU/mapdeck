mapdeckPointcloudDependency <- function() {
	list(
		createHtmlDependency(
			name = "pointcloud",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/pointcloud", package = "mapdeck"),
			script = c("pointcloud.js")
		)
	)
}


#' Add Pointcloud
#'
#' The Pointcloud Layer takes in coordinate points and renders them as circles
#' with a certain radius.
#'
#' @inheritParams add_scatterplot
#' @param elevation column containing the elevation values
#' @param radius value in pixels of each point
#' @param light_settings list of light setting parameters. See \link{light_settings}
#'
#' @inheritSection add_polygon data
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for pointcloud
#'
#' list(
#' position = 0,
#' fill_colour = 0
#' )
#'
#' @examples
#' \donttest{
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- capitals
#' df$z <- sample(10000:10000000, size = nrow(df))
#'
#' mapdeck(token = key, style = mapdeck_style("dark")) %>%
#' add_pointcloud(
#'   data = df
#'   , lon = 'lon'
#'   , lat = 'lat'
#'   , elevation = 'z'
#'   , layer_id = 'point'
#'   , fill_colour = "country"
#'   , tooltip = "country"
#'   , update_view = FALSE
#' )
#'
#' ## as an sf object wtih a Z attribute
#' library(sf)
#' sf <- sf::st_as_sf( df , coords = c("lon","lat","z"))
#'
#' mapdeck(token = key, style = mapdeck_style("dark")) %>%
#' add_pointcloud(
#'   data = sf
#'   , layer_id = 'point'
#'   , fill_colour = "country"
#'   , tooltip = "country"
#'   , update_view = FALSE
#' )
#'
#' }
#'
#' @details
#'
#' \code{add_pointcloud} supports POINT and MULTIPOINT sf objects
#'
#' @export
add_pointcloud <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	elevation = NULL,
	polyline = NULL,
	radius = 10,
	fill_colour = NULL,
	fill_opacity = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	light_settings = list(),
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	legend_format = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL
) {

	l <- list()
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )
	l[["polyline"]] <- force( polyline )
	l[["elevation"]] <- force( elevation )
	l[["fill_colour"]] <- force( fill_colour)
	l[["fill_opacity"]] <- force( fill_opacity )
	l[["tooltip"]] <- force( tooltip )
	l[["id"]] <- force( id )
	l[["na_colour"]] <- force( na_colour )

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_elevation_data( data, l, elevation, c("POINT","MULTIPOINT") )

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

	checkHexAlpha( highlight_colour )
	layer_id <- layerId( layer_id, "pointcloud" )
	checkNumeric( radius )

	map <- addDependency( map, mapdeckPointcloudDependency() )

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_pointcloud_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_pointcloud_geojson( data, l, geometry_column )

	} else if ( tp == "df" ) {
		## TODO( here or in rcpp? )
		if( is.null(elevation) ){
			l[["elevation"]] <- 0
		}

		geometry_column <- list( geometry = c("lon","lat","elevation") )
	  shape <- rcpp_pointcloud_geojson_df( data, l, geometry_column )

	} else if ( tp == "sfencoded" ) {

		geometry_column <- "polyline"
		shape <- rcpp_pointcloud_polyline( data, l, geometry_column )
		jsfunc <- "add_pointcloud_polyline"
	}

	light_settings <- jsonify::to_json(light_settings, unbox = T)
	js_transitions <- resolve_transitions( transitions, "pointcloud" )
	shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )

	invoke_method(
		map, jsfunc, shape[["data"]], radius, layer_id, light_settings,
		auto_highlight, highlight_colour, shape[["legend"]], bbox, update_view, focus_layer,
		js_transitions
		)
}


#' @rdname clear
#' @export
clear_pointcloud <- function( map, layer_id = NULL) {
	layer_id <- layerId( layer_id, "pointcloud" )
	invoke_method(map, "md_layer_clear", layer_id, "pointcloud" )
}

