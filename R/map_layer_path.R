mapdeckPathDependency <- function() {
	list(
		htmltools::htmlDependency(
			"path",
			"1.0.0",
			system.file("htmlwidgets/lib/path", package = "mapdeck"),
			script = c("path.js")
		)
	)
}


#' Add Path
#'
#' The Path Layer takes in lists of coordinate points and renders them as
#' extruded lines with mitering.
#'
#' @inheritParams add_polygon
#'
#' @param stroke_opacity value between 1 and 255. Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
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
#'   , location = c(145, -37.8)
#'   , zoom = 10) %>%
#'   add_path(
#'   data = roads[1:100, ]
#'   , polyline = "geometry"
#'   , stroke_colour = "RIGHT_LOC"
#'   , layer_id = "path_layer"
#'   )
#'
#' }
#'
#' @export
add_path <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	layer_id,
	digits = 6,
	palette = viridisLite::viridis
) {

	## TODO(sf and lon/lat coordinates)

	objArgs <- match.call(expand.dots = F)

	data <- normaliseSfData(data, "LINESTRING")
	polyline <- findEncodedColumn(data, polyline)

	## - if sf object, and geometry column has not been supplied, it needs to be
	## added to objArgs after the match.call() function
	if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
		objArgs[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}

	## parameter checks


	## end parameter checks

	allCols <- pathColumns()
	requiredCols <- requiredPathColumns()

	colourColumns <- shapeAttributes(
		fill_colour = NULL
		, stroke_colour = stroke_colour
		, stroke_from = NULL
		, stroke_to = NULL
	)

	shape <- createMapObject(data, allCols, objArgs)

	# print(head(shape))
	pal <- createPalettes(shape, colourColumns)

	colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
	colours <- createColours(shape, colour_palettes)

	if(length(colours) > 0) {
		shape <- replaceVariableColours(shape, colours)
	}

	# print(head(shape))
	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "path")
	}

	# print(str(shape))
	#
	# if (!is.list(shape[["polyline"]])) {
	# 	f <- paste0("polyline ~ ", paste0(setdiff(names(shape),
	# 																						"polyline"), collapse = "+"))
	# 	shape <- stats::aggregate(stats::formula(f), data = shape,
	# 														list)
	# }
	#
	# print(str(shape))

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckPathDependency())
	invoke_method(map, "add_path", shape, layer_id)
}


requiredPathColumns <- function() {
	c("stroke_width", "stroke_colour","stroke_opacity")
}

pathColumns <- function() {
	c("polyline", "stroke_width", "stroke_colour", "stroke_opacity")
}

pathDefaults <- function(n) {
	data.frame(
		"stroke_colour" = rep("#440154", n),
		"stroke_width" = rep(1, n),
		"stroke_opacity" = rep(255, n),
		stringsAsFactors = F
	)
}



