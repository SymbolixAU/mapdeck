mapdeckScatterplotDependency <- function() {
	list(
		htmltools::htmlDependency(
			"scatterplot",
			"1.0.0",
			system.file("htmlwidgets/lib/scatterplot", package = "mapdeck"),
			script = c("scatterplot.js")
		)
	)
}


#' Add Scatterplot
#'
#' @inheritParams add_arc
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param radius in metres
#'
#' @examples
#'
#' key <- "pk.eyJ1Ijoic3ltYm9saXgiLCJhIjoiY2pqbm45Zmo1MGl1aTNxbmxwamFqb3Z6MSJ9.yIkj0tGNNh4u61DliOXV6g"
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' add_scatterplot(
#'   data = capitals
#'   , lat = "lat"
#'   , lon = "lon"
#'   , radius = 100000
#'   , fill_colour = "country"
#' )
#'
#' @export
add_scatterplot <- function(
	map,
	data = get_map_data(map),
	lon,
	lat,
	radius = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	stroke_width = NULL,
	layer_id = NULL,
	digits = 6,
	palette = viridisLite::viridis
	) {

	objArgs <- match.call(expand.dots = F)

	## parmater checks


	## end parameter checks

	allCols <- scatterplotColumns()
	requiredCols <- requiredScatterplotColumns()

	colourColumns <- shapeAttributes(
		fill_colour = fill_colour
		, stroke_colour = NULL
		, stroke_from = NULL
		, stroke_to = NULL
		)

	shape <- createMapObject(data, allCols, objArgs)

	pal <- createPalettes(shape, colourColumns)

	colour_palettes <- createColourPalettes(data, pal, colourColumns, palette)
	colours <- createColours(shape, colour_palettes)

	if(length(colours) > 0){
		shape <- replaceVariableColours(shape, colours)
	}

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "scatterplot")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckScatterplotDependency())
	invoke_method(map, "add_scatterplot", shape, layer_id)
}




requiredScatterplotColumns <- function() {
	c("stroke_width", "radius",
		"fill_opacity", "fill_colour")
}


scatterplotColumns <- function() {
	c('lat', 'lon', "elevation", "radius",
		'fill_colour', 'fill_opacity',
		'stroke_width')
}

scatterplotDefaults <- function(n) {
	data.frame(
		"elevation" = rep(0, n),
		"radius" = rep(1, n),
		"fill_colour" = rep("#0000FF", n),
		"fill_opacity" = rep(0.8, n),
		"stroke_width" = rep(1, n),
		stringsAsFactors = F
	)
}
