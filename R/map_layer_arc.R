mapdeckArcDependency <- function() {
	list(
		htmltools::htmlDependency(
			"arc",
			"1.0.0",
			system.file("htmlwidgets/lib/arc", package = "mapdeck"),
			script = c("arc.js")
		)
	)
}


#' Add arc
#'
#'
#' @examples
#' \dontrun{
#'
#' key <- "MAPBOX_KEY"
#'
#' url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
#' flights <- read.csv(url)
#' flights$id <- seq_len(nrow(flights))
#' flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#' 	add_arc(
#' 		data = flights
#' 		, lat_from = "start_lat"
#' 		, lon_from = "start_lon"
#' 		, lat_to = "end_lat"
#' 		, lon_to = "end_lon"
#' 		, stroke_from = "airport1"
#' 		, stroke_to = "airport2"
#' 		, stroke_width = "stroke"
#' 	)
#' }
#'
#' @export
add_arc <- function(
	map,
	data = get_map_data(map),
	lat_from,
	lon_from,
	lat_to,
	lon_to,
	id = NULL,
	stroke_from = NULL,
	stroke_to = NULL,
	stroke_width = NULL,
	layer_id = NULL,
	digits = 6,
	palette = viridisLite::viridis
) {

	objArgs <- match.call(expand.dots = F)

	## parameter checks
	layer_id <- layerId(layer_id)

	## end parameter checks

	allCols <- arcColumns()
	requiredCols <- requiredArcColumns()

	colourColumns <- shapeAttributes(
		fill_colour = NULL
		, stroke_colour = NULL
		, stroke_from = stroke_from
		, stroke_to = stroke_to
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
		shape <- addDefaults(shape, requiredDefaults, "arc")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckArcDependency())
	invoke_method(map, "add_arc", shape, layer_id)
}




requiredArcColumns <- function() {
	c("stroke_width", "stroke_from", "stroke_to")
}

arcColumns <- function() {
	c('lat_from', 'lon_from', "lat_to", "lon_to",
		"stroke_width", "stroke_from", "stroke_to")
}

arcDefaults <- function(n) {
	data.frame(
		"stroke_from" = rep("#440154", n),
		"stroke_to" = rep("#FDE725", n),
		"stroke_width" = rep(1, n),
		stringsAsFactors = F
	)
}
