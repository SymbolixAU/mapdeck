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
#'
#' @export
add_path <- function(
	map,
	data = get_map_data(map),
	polyline,
	stroke_colour = NULL,
	stroke_width = NULL,
	layer_id = NULL,
	digits = 6,
	palette = viridisLite::viridis
) {

	objArgs <- match.call(expand.dots = F)

	## parameter checks
	layer_id <- layerId(layer_id)
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

#' @rdname clear
#' @export
clear_path <- function(map, layer_id) {
	layer_id <- layerId(layer_id)
	invoke_method(map, 'clear_path', layer_id)
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



