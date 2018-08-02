mapdeckPolygonDependency <- function() {
	list(
		htmltools::htmlDependency(
			"polygon",
			"1.0.0",
			system.file("htmlwidgets/lib/polygon", package = "mapdeck"),
			script = c("polygon.js")
		)
	)
}


#' Add Polygon
#'
#' The Polygon Layer renders filled and/or stroked polygons.
#'
#' @inheritParams add_arc
#'
#' @param polyline column of \code{data} containing the polylines
#' @param fill_colour column of \code{data} or hex colour for the fill colour
#' @param stroke_colour variable of \code{data} or hex colour for the stroke
#' @param stroke_width width of the stroke
#'
#' @examples
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck(
#'   token = key
#'   , style = 'mapbox://styles/mapbox/dark-v9'
#'   , location = c(145, -38)
#'   , zoom = 8
#'   ) %>%
#'   add_polygon(
#'   	data = melbourne
#'     , polyline = "geometry"
#'     , layer = "polygon_layer"
#'   	, fill_colour = "fillColor"
#'   	)
#'
#' library(sf)
#' library(geojsonsf)
#'
#' sf <- geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
#'
#' mapdeck(
#' 	token = key
#' 	, style = 'mapbox://styles/mapbox/dark-v9'
#' ) %>%
#' 	add_polygon(
#' 		data = sf
#' 		, layer = "polygon_layer"
#' 		, fill_colour = "SA2_NAME16"
#' 	)
#'
#' }
#'
#' @export
add_polygon <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	fill_colour = NULL,
	layer_id,
	digits = 6,
	palette = viridisLite::viridis
) {

	## TODO( sf and lon/lat coordinates )
	## TODO( elevation )
	## TODO( is this too slow? )

	objArgs <- match.call(expand.dots = F)

	data <- normaliseSfData(data, "POLYGON")
	polyline <- findEncodedColumn(data, polyline)

	## - if sf object, and geometry column has not been supplied, it needs to be
	## added to objArgs after the match.call() function
	if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
		objArgs[['polyline']] <- polyline
	}

	## parameter checks


	## end parameter checks

	allCols <- polygonColumns()
	requiredCols <- requiredPolygonColumns()

	colourColumns <- shapeAttributes(
		fill_colour = fill_colour
		, stroke_colour = stroke_colour
		, stroke_from = NULL
		, stroke_to = NULL
	)

	shape <- createMapObject(data, allCols, objArgs)

	pal <- createPalettes(shape, colourColumns)

	colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
	colours <- createColours(shape, colour_palettes)

	if(length(colours) > 0) {
		shape <- replaceVariableColours(shape, colours)
	}

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "polygon")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckPolygonDependency())
	invoke_method(map, "add_polygon", shape, layer_id)
}


requiredPolygonColumns <- function() {
	c("fill_colour", "stroke_width", "stroke_colour")
}

polygonColumns <- function() {
	c("polyline", "fill_colour", "stroke_width", "stroke_colour")
}

polygonDefaults <- function(n) {
	data.frame(
		"fill_colour" = rep("#440154", n),
		"stroke_colour" = rep("#440154", n),
		"stroke_width" = rep(1, n),
		stringsAsFactors = F
	)
}
