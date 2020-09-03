
mapdeckGeojsonDependency <- function() {
	list(
		createHtmlDependency(
			name = "geojson",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/geojson", package = "mapdeck"),
			script = c("geojson.js"),
			all_files = FALSE
		)
	)
}


#' Add Geojson
#'
#' The GeoJson Layer takes in GeoJson formatted data and renders it as interactive polygons,
#' lines and points
#'
#' @inheritParams add_polygon
#' @param data data to be used in the layer. Can be a url to GeoJSON
#' @param stroke_colour column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for colour
#' @param stroke_opacity column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for opacity
#' @param stroke_width column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for width (in meters)
#' @param dash_size size of each dash, relative to the width of the stroke
#' @param dash_gap size of the gap between dashes, relative to the width of the stroke
#' @param fill_colour column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for colour
#' @param fill_opacity column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for opacity
#' @param radius radius of points in meters. Default 1. See details
#' @param elevation elevation of polygons. Default 0. See details
#' @param extruded logical indicating if polygons should extrude from the map.
#' If \code{TRUE}, \code{stroke_colour} for polygons is ignored
#' @param light_settings list of light setting parameters. See \link{light_settings}
#' @param line_width_units The units of the line width, one of 'meters', 'pixels'.
#' When zooming in and out, meter sizes scale with the base map, and pixel sizes remain the same on screen.
#' @param line_width_scale The line width multiplier that multiplied to all lines,
#' including the LineString and MultiLineString features and also the outline for
#' Polygon and MultiPolygon features if the stroked attribute is true
#' @param line_width_min_pixels The minimum line width in pixels.
#' @param elevation_scale Elevation multiplier. The final elevation is calculated by
#' elevationScale * getElevation(d). elevationScale is a handy property to scale
#' all polygon elevation without updating the data
#' @param point_radius_scale A global radius multiplier for all points.
#' @param point_radius_min_pixels The minimum radius in pixels.
#' @param tooltip variable of \code{data} containing text or HTML to render as a tooltip.
#' Only works on \code{sf} objects.
#' @param legend either a logical indiciating if the legend(s) should be displayed, or
#' a named list indicating which colour attributes should be included in the legend.
#' A legend is only shown if you supply one of the colour arguments (fill or stroke)
#'
#' @inheritSection add_polygon data
#' @inheritSection add_arc legend
#'
#' @section transitions:
#'
#' The transitions argument lets you specify the time it will take for the shapes to transition
#' from one state to the next. Only works in an interactive environment (Shiny)
#' and on WebGL-2 supported browsers and hardware.
#'
#' The time is in milliseconds
#'
#' Available transitions for geojson
#'
#' list(
#' fill_colour = 0,
#' stroke_colour = 0,
#' stroke_width = 0,
#' elevation = 0,
#' radius = 0
#' )
#'
#' @section Raw Geojson:
#'
#' If using a GeoJSON string, and you \strong{do not} suppply one of the colouring arguments, the
#' function will look for these fields inside the \code{properties} field of the Geojson
#'
#' \strong{fill_colour}
#' \itemize{
#'   \item{fill_colour}
#'   \item{fillColour}
#'   \item{fill_color}
#'   \item{fillColor}
#'   \item{fill}
#' }
#'
#' \strong{stroke_colour}
#' \itemize{
#'   \item{stroke_colour}
#'   \item{strokeColour}
#'   \item{stroke_color}
#'   \item{strokeColor}
#'   \item{stroke}
#'   \item{line_colour}
#'   \item{lineColour}
#'   \item{line_color}
#'   \item{lineColor}
#'   \item{line}
#' }
#'
#' \strong{stroke_width}
#' \itemize{
#'   \item{stroke_width}
#'   \item{strokeWdith}
#'   \item{line_width}
#'   \item{lineWidth}
#'   \item{width}
#' }
#'
#' \itemize{
#'   \item{elevation}
#'   \item{radius}
#' }
#'
#' These colour values should be valid hex-colour strings.
#'
#' If you \strong{do} provide values for the colouring arguments, the function will assume
#' you want to use specific fields in the geojson for colouring. However, if you only supply a
#' \code{fill_colour} value, the function will not automatically detect the \code{stroke_colour}
#' (and vice versa)
#'
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' ## Not supplying colouring arguments, the function will try and find them in the GeoJSON
#' mapdeck(
#'  , location = c(145, -37.9)
#'  , zoom = 8
#'  , style = mapdeck_style("dark")
#'  , pitch = 35
#' ) %>%
#'  add_geojson(
#'    data = geojson
#'    , auto_highlight = TRUE
#'  )
#'
#' ## only supplying values to use for fill, the stroke will be default
#' mapdeck(
#'  , location = c(145, -37.9)
#'  , zoom = 8
#'  , style = mapdeck_style("dark")
#'  , pitch = 35
#' ) %>%
#'  add_geojson(
#'    data = geojson
#'    , fill_colour = "random"
#'  )
#'
#' mapdeck(
#'  , location = c(145, -37.9)
#'  , zoom = 8
#'  , style = mapdeck_style("dark")
#'  , pitch = 35
#' ) %>%
#'  add_geojson(
#'    data = geojson
#'    , fill_colour = "random"
#'    , stroke_colour = "random"
#'  )
#'
#' mapdeck(
#'  , location = c(145, -37.9)
#'  , zoom = 8
#'  , style = mapdeck_style("dark")
#'  , pitch = 35
#' ) %>%
#'  add_geojson(
#'    data = geojson
#'    , fill_colour = "random"
#'    , stroke_colour = "random"
#'    , elevation = 300
#'  )
#'
#' ## putting elevation and width values onto raw GeoJSON
#' library(geojsonsf)
#' sf <- geojsonsf::geojson_sf( geojson )
#' sf$width <- sample(1:100, size = nrow(sf), replace = TRUE)
#' sf$elevation <- sample(100:1000, size = nrow(sf), replace = TRUE)
#' geo <- geojsonsf::sf_geojson( sf )
#'
#' mapdeck(
#'  , location = c(145, -37.9)
#'  , zoom = 8
#'  , style = mapdeck_style("dark")
#'  , pitch = 35
#' ) %>%
#'  add_geojson(
#'    data = geo
#'  )
#'
#' }
#'
#'
#' @export
add_geojson <- function(
	map,
	data = get_map_data(map),
	layer_id = NULL,
	stroke_colour = NULL,
	stroke_opacity = NULL,
	stroke_width = NULL,
	dash_size = NULL,
	dash_gap = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	radius = NULL,
	elevation = NULL,
	extruded = FALSE,
	light_settings = list(),
	legend = F,
	legend_options = NULL,
	legend_format = NULL,
	auto_highlight = FALSE,
	tooltip = NULL,
	highlight_colour = "#AAFFFFFF",
	palette = "viridis",
	na_colour = "#808080FF",
	line_width_units = c("metres", "pixels"),
	line_width_scale = 1,
	line_width_min_pixels = 0,
	elevation_scale = 1,
	point_radius_scale = 1,
	point_radius_min_pixels = 1,
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6,
	transitions = NULL
	) {

	l <- list()
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_opacity"]] <- force( stroke_opacity )
	l[["stroke_width"]] <- force( stroke_width )
	l[["dash_size"]] <- force(dash_size)
	l[["dash_gap"]] <- force(dash_gap)
	l[["fill_colour"]] <- force( fill_colour )
	l[["fill_opacity"]] <- force( fill_opacity )
	l[["elevation"]] <- force( elevation )
	l[["radius"]] <- force( radius )
	l[["tooltip"]] <- force( tooltip )
	l[["na_colour"]] <- force(na_colour)


	bbox <- init_bbox()
	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	if ( any (
		!is.null( l[["stroke_colour"]] ) |
		!is.null( l[["stroke_opacity"]] ) |
		!is.null( l[["stroke_width"]] ) |
		!is.null( l[["dash_size"]] ) |
		!is.null( l[["dash_gap"]] ) |
		!is.null( l[["fill_colour"]] ) |
		!is.null( l[["fill_opacity"]] ) |
		!is.null( l[["elevation"]] ) |
		!is.null( l[["radius"]] )
	) ) {
		if( inherits( data, "geojson" ) | inherits( data, "json" ) | inherits( data, "character" ) ) {
			#message("converting geojson to sf")
			data <- geojsonsf::geojson_sf( data )
		}
	}

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_geojson_data( data, l )

	line_width_units <- match.arg(line_width_units)

	if( !is.null(l[["data"]] ) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	if( !is.null( l[["bbox"]] ) ) {
		bbox <- l[["bbox"]]
		l[["bbox"]] <- NULL
	}

	layer_id <- layerId( layer_id, "geojson" )
	### end parameter checks

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	if( tp == "sf" ) {
	  shape <- rcpp_geojson_geojson( data, l, "geometry", digits)
	  jsfunc <- "add_geojson_sf"
	} else if ( tp == "geojson" ) {
		## leave as is?
		jsfunc <- "add_geojson"
		shape <- list()
		shape[["data"]] <- data
	}

	light_settings <- jsonify::to_json(light_settings, unbox = T)
	js_transitions <- resolve_transitions( transitions, "geojson" )

	map <- addDependency(map, mapdeckGeojsonDependency())
	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, light_settings, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer,
		js_transitions, line_width_units, line_width_scale, line_width_min_pixels,
		elevation_scale, point_radius_scale, point_radius_min_pixels, extruded
		)
}


#' @rdname clear
#' @export
clear_geojson <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "geojson")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "geojson" )
}
