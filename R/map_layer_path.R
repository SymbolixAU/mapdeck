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
#' @inheritParams add_arc
#'
#' @param polyline column of \code{data} containing the polyline
#' @param stroke_colour variable of \code{data} or hex colour for the stroke
#' @param stroke_width width of the stroke
#'
#' @examples
#' \dontrun{
#' mapdeck(
#'   token = key
#'   , style = 'mapbox://styles/mapbox/dark-v9'
#'   , location = c(145.688269, -38.101062)
#'   , zoom = 8) %>%
#'   add_path(
#'   data = roads[1:10000, ]
#'   , polyline = "geometry"
#'   , stroke_colour = "RIGHT_LOC"
#'   )
#' }
#'
#' @export
add_path <- function(
	map,
	data = get_map_data(map),
	polyline,
	stroke_colour = NULL,
	stroke_width = NULL,
	layer_id,
	digits = 6,
	palette = viridisLite::viridis
) {

	objArgs <- match.call(expand.dots = F)

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

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckPathDependency())
	invoke_method(map, "add_path", shape, layer_id)
}


requiredPathColumns <- function() {
	c("stroke_width", "stroke_colour")
}

pathColumns <- function() {
	c("polyline", "stroke_width", "stroke_colour")
}

pathDefaults <- function(n) {
	data.frame(
		"stroke_colour" = rep("#440154", n),
		"stroke_width" = rep(1, n),
		stringsAsFactors = F
	)
}



