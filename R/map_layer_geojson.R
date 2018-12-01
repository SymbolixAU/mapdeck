
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
#' @inheritParams add_polygon
#' @param stroke_colour column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for colour
#' @param stroke_opacity column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for opacity
#' @param stroke_width column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for width
#' @param fill_colour column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for colour
#' @param fill_opacity column of an \code{sf} object, or field inside a GeoJSON \code{property} to use for opacity
#' @param radius radius of points in meters. See details
#' @param elevation elevation of polygons. See details
#' @param light_settings list of light setting parameters. See \link{light_settings}
#' @param tooltip variable of \code{data} containing text or HTML to render as a tooltip.
#' Only works on \code{sf} objects.
#'
#' @details
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
#'
#' ## Not supplying colouring arguments, the function will try and find them in the GeoJSON
#' mapdeck(
#'  token = key
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
#'  token = key
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
#'  token = key
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
#'  token = key
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
#' sf <- geojsonsf::geojson_sf( geojson )
#' sf$width <- sample(1:100, size = nrow(sf), replace = TRUE)
#' sf$elevation <- sample(100:1000, size = nrow(sf), replace = T)
#' geo <- geojsonsf::sf_geojson( sf )
#'
#' mapdeck(
#'  token = key
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
	fill_colour = NULL,
	fill_opacity = NULL,
	radius = NULL,
	elevation = NULL,
	#evaluate = FALSE,            ## TODO( if TRUE, make to SF and resolve all teh stuff)
	light_settings = list(),
	legend = F,
	legend_options = NULL,
	auto_highlight = FALSE,
	tooltip = NULL,
	highlight_colour = "#AAFFFFFF",
	palette = "viridis",
	na_colour = "#808080FF",
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL
	) {

	l <- list()
	l[["stroke_colour"]] <- force( stroke_colour )
	l[["stroke_opacity"]] <- force( stroke_opacity )
	l[["stroke_width"]] <- force( stroke_width )
	l[["fill_colour"]] <- force( fill_colour )
	l[["fill_opacity"]] <- force( fill_opacity )
	l[["elevation"]] <- force( elevation )
	l[["radius"]] <- force( radius )
	l[["tooltip"]] <- force( tooltip )
	l[["na_colour"]] <- force(na_colour)


	bbox <- init_bbox()
	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	#evaluate <- force( evaluate )

	## if the user supplied any of the 'get' accessors, AND they supplied geoJSON, conver to SF.
	#if ( evaluate ) {
		if ( any (
			!is.null( l[["stroke_colour"]] ) |
			!is.null( l[["stroke_opacity"]] ) |
			!is.null( l[["stroke_width"]] ) |
			!is.null( l[["fill_colour"]] ) |
			!is.null( l[["fill_opacity"]] ) |
			!is.null( l[["elevation"]] ) |
			!is.null( l[["radius"]] )
		) ) {
			if( inherits( data, "geojson" ) | inherits( data, "json" ) | inherits( data, "character" ) ) {
				message("converting geojson to sf")
				data <- geojsonsf::geojson_sf( data )
			}
		}
	#}

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_geojson_data( data, l )

	if( !is.null(l[["data"]] ) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	if( !is.null( l[["bbox"]] ) ) {
		bbox <- l[["bbox"]]
		l[["bbox"]] <- NULL
	}

	## TODO( fill_colour, stroke_colour can refer to a .property. value? )
	## - it will have to be rendered as an sf object, though...

	## if SF object, we can do all the colour stuff
	## If the user supplies fill_colour / stroke_colour, convert to sf, then use as sf
	## if none are supplied, the javascript function will look for `fillColor`, / `lineColor` etc.


	# data <- normalisesGeojsonData( data )
	## Parameter checks

	# checkNumeric( radius )
	# checkNumeric( stroke_width )
	# checkNumeric( elevation )
	# isHexColour( stroke_colour )
	# isHexColour( fill_colour )
	# checkHexAlpha( highlight_colour )
	layer_id <- layerId( layer_id, "geojson" )
	## TODO(light_settings - test options are accurate)

	### end parameter checks

	data_types <- data_types( data )

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	if( tp == "sf" ) {
	  shape <- rcpp_geojson_geojson( data, data_types, l, "geometry" )
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

	## TODO( invoke different methods for when using pure GeoJSON and when using sf)
	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, light_settings, auto_highlight,
		highlight_colour, shape[["legend"]], bbox, update_view, focus_layer,
		js_transitions
		)
}


#' @rdname clear
#' @export
clear_geojson <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "geojson")
	invoke_method(map, "clear_geojson", layer_id )
}
