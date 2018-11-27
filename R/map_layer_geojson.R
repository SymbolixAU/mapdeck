
mapdeckGeojsonDependency <- function() {
	list(
		htmltools::htmlDependency(
			"geojson",
			"1.0.0",
			system.file("htmlwidgets/lib/geojson", package = "mapdeck"),
			script = c("geojson.js")
		)
	)
}


#' Add Geojson
#'
#' The GeoJson Layer takes in GeoJson formatted data and renders it as interactive polygons,
#' lines and points
#'
#' @inheritParams add_arc
#' @param line_colour hex value for all line colours. See details
#' @param fill_colour hex value for all fill colours. See details
#' @param radius radius of points in meters. See details
#' @param lineWidth width of lines in meters. See details
#' @param elevation elevation of polygons. See details
#' @param light_settings list of light setting parameters. See \link{light_settings}
#'
#' @details
#'
#' The GeoJSON string needs to have a \code{class} attribute of 'json'
#'
#' If the GeoJSON contains the following fields in the \code{properties} object,
#' they will be used as the attribute properties for each feature.
#' Otherwise the values supplied to the arguments will be applied to all the features.
#'
#' \itemize{
#'   \item{fillColor - fill colour of polygons and points}
#'   \item{lineColor - line colour of lines}
#'   \item{lineWidth - line width of lines}
#'   \item{elevation - elevation of polygons}
#'   \item{radius - radius of points}
#' }
#'
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck(
#'  token = key
#'  , location = c(145, -37.9)
#'  , zoom = 8
#'  , style = "mapbox://styles/mapbox/dark-v9"
#'  , pitch = 35
#' ) %>%
#'  add_geojson(
#'    data = geojson
#'    , layer_id = "geojson"
#'    , auto_highlight = TRUE
#'  )
#'
#' ## add colours, elevation and opacities
#' sf <- geojsonsf::geojson_sf(geojson)
#' sf$elevation <- sample(100:1000, size = nrow(sf), replace = T)
#' sf$fillOpacity <- sample(200:255, size = nrow(sf), replace = T)
#' sf$radius <- sample(1:100, size = nrow(sf), replace = T)
#'
#' mapdeck(
#'   token = key
#'   , location = c(145, -37.9)
#'   , zoom = 8
#'   , style = "mapbox://styles/mapbox/dark-v9"
#'   , pitch = 35
#' ) %>%
#'   add_geojson(
#'     data = sf
#'     , lineWidth = 250,
#'     , layer_id = "geojson"
#'  )
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
	fill_colour = NULL,
	fill_opacity = NULL,
	radius = 1,
	line_width = 1,
	light_settings = list(),
	elevation = 0,
	palette = "viridis",
	legend = F,
	legend_options = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF"
	) {

	l <- list()
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_opacity"]] <- force( stroke_opacity )
	l[["fill_colour"]] <- force( fill_colour )
	l[["fill_opacity"]] <- force( fill_opacity )

	l[["geometry"]] <- "geometry"   ## TODO

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )

	## TODO( fill_colour, stroke_colour can refer to a .property. value? )
	## - it will have to be rendered as an sf object, though...

	## if SF object, we can do all the colour stuff


	# data <- normalisesGeojsonData( data )
	## Parameter checks

	checkNumeric( radius )
	checkNumeric( line_width )
	checkNumeric( elevation )
	isHexColour( stroke_colour )
	isHexColour( fill_colour )
	checkHexAlpha( highlight_colour )
	layer_id <- layerId( layer_id, "geojson" )
	## TODO(light_settings - test options are accurate)

	### end parameter checks

	data_types <- data_types( data )
	shape <- rcpp_geojson_geojson( data, data_types, l, "geometry" )

	print( shape )

	light_settings <- jsonify::to_json(light_settings, unbox = T)

	map <- addDependency(map, mapdeckGeojsonDependency())

	## TODO( invoke different methods for when using pure GeoJSON and when using sf)
	invoke_method(map, "add_geojson", shape[["data"]], layer_id, stroke_colour, fill_colour, radius,
								lineWidth, elevation, light_settings, auto_highlight, highlight_colour)
}


#' @rdname clear
#' @export
clear_geojson <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "geojson")
	invoke_method(map, "clear_geojson", layer_id )
}
