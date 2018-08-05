
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
#' \dontrun{
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
#'  )
#'
#' ## add colours, elevation and opacities
#' sf <- geojsonsf::geojson_sf(geojson)
#' sf$fillColor <- substr(viridisLite::viridis(nrow(sf)), 1, 7) ## doesn't support alpha
#' sf$lineColor <- substr(viridisLite::viridis(nrow(sf)), 1, 7)
#' sf$elevation <- sample(100:5000, size = nrow(sf), replace = T)
#' sf$fillOpacity <- sample(1:255, size = nrow(sf), replace = T)
#' g <- geojsonsf::sf_geojson(sf)
#' attr(g, 'class') <- 'json'
#'
#' mapdeck(
#'   token = key
#'   , location = c(145, -37.9)
#'   , zoom = 8
#'   , style = "mapbox://styles/mapbox/dark-v9"
#'   , pitch = 35
#' ) %>%
#'   add_geojson(
#'     data = g
#'     , lineWidth = 100,
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
	elevation = 0
	) {


	map <- addDependency(map, mapdeckGeojsonDependency())
	invoke_method(map, "add_geojson", data, layer_id, lineColor, fillColor, radius, lineWidth, elevation)
}
