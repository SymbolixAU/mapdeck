
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
#' @param lineColor hex value for all line colours. See details
#' @param fillColor hex value for all fill colours. See details
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
	layer_id,
	lineColor = "#440154",
	fillColor = "#440154",
	radius = 1,
	lineWidth = 1,
	light_settings = list(),
	elevation = 0,
	auto_highlight = FALSE
	) {

	data <- normalisesGeojsonData(data)
	## Parameter checks

	checkNumeric(radius)
	checkNumeric(lineWidth)
	checkNumeric(elevation)
	isHexColour(lineColor)
	isHexColour(fillColor)
	## TODO(light_settings - test options are accurate)

	### end parameter checks

	map <- addDependency(map, mapdeckGeojsonDependency())
	invoke_method(map, "add_geojson", data, layer_id, lineColor, fillColor, radius, lineWidth, elevation, light_settings, auto_highlight)
}
