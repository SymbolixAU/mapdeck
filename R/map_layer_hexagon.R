mapdeckHexagonDependency <- function() {
	list(
		htmltools::htmlDependency(
			"hexagon",
			"1.0.0",
			system.file("htmlwidgets/lib/hexagon", package = "mapdeck"),
			script = c("hexagon.js")
		)
	)
}


#' Add hexagon
#'
#' The Hexagon Layer renders a hexagon heatmap based on an array of points.
#' It takes the radius of hexagon bin, projects points into hexagon bins.
#' The color and height of the hexagon is scaled by number of points it contains.
#'
#' @inheritParams add_arc
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param radius in metres
#' @param elevation_scale value to sacle the elevations of the hexagons
#' @param colour_range palette of colours
#'
#' @examples
#' \dontrun{
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/3d-heatmap/heatmap-data.csv'
#' ))
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_hexagon(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "hex_layer"
#'   , elevation_scale = 100
#' )
#'
#' }
#'
#' @export
add_hexagon <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	lon = NULL,
	lat = NULL,
	layer_id,
	radius = 1000,
	elevation_scale = 1,
	colour_range = colourvalues::colour_values(1:6, palette = "viridis")
) {

	l <- as.list( match.call( expand.dots = F) )
	l[[1]] <- NULL
	l[["data"]] <- NULL
	l[["map"]] <- NULL
	l[["auto_highlight"]] <- NULL
	l[["light_settings"]] <- NULL
	l[["layer_id"]] <- NULL

	data <- normaliseSfData(data, "POINT")
	polyline <- findEncodedColumn(data, polyline)

	if( !is.null(polyline) && !polyline %in% names(l) ) {
		l[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}

	checkHex(colour_range)
	usePolyline <- isUsingPolyline(polyline)


	if ( !usePolyline ) {
		## TODO(check only a data.frame)
		data[['polyline']] <- googlePolylines::encode(data, lon = lon, lat = lat, byrow = TRUE)
		polyline <- 'polyline'
		## TODO(check lon & lat exist / passed in as arguments )
		l[['lon']] <- NULL
		l[['lat']] <- NULL
		l[['polyline']] <- polyline
	}

	layer_id <- layerId(layer_id, "hexagon")

	shape <- rcpp_hexagon( data, l )

	map <- addDependency(map, mapdeckHexagonDependency())
	invoke_method(map, "add_hexagon", shape[["data"]], layer_id, radius, elevation_scale, colour_range )
}

#' @rdname clear
#' @export
clear_hexagon <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "hexagon")
	invoke_method(map, "clear_hexagon", layer_id )
}
