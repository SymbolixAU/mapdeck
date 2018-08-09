mapdeckTextDependency <- function() {
	list(
		htmltools::htmlDependency(
			"text",
			"1.0.0",
			system.file("htmlwidgets/lib/text", package = "mapdeck"),
			script = c("text.js")
		)
	)
}


#' Add Text
#'
#' The Text Layer takes in coordinate points and renders them as circles
#' with a certain radius.
#'
#' @inheritParams add_scatterplot
#' @param text column of \code{data} containing the text
#' @param size column of \code{data} containing the size of the text
#' @param angle column of \code{data} containging the angle of the text
#' @param anchor column of \code{data} containing the anchor of the text. One of
#' 'start', 'middle' or 'end'
#' @param alignment_baseline column of \code{data} containing the alignment. One of
#' 'top', 'center' or 'bottom'
#'
#' @examples
#'
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' mapdeck(
#'   token = key,
#'   style = mapdeck_style('dark')
#' ) %>%
#'   add_text(
#'     data = capitals
#'     , lon = 'lon'
#'     , lat = 'lat'
#'     , fill_colour = 'country'
#'     , text = 'capital'
#'     , layer_id = 'text'
#'   )
#' }
#'
#' @export
add_text <- function(
	map,
	data = get_map_data(map),
	text,
	lon = NULL,
	lat = NULL,
	polyline = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	size = NULL,
	angle = NULL,
	anchor = NULL,
	alignment_baseline = NULL,
	tooltip = NULL,
	layer_id,
	digits = 6,
	palette = viridisLite::viridis
) {

	objArgs <- match.call(expand.dots = F)

	data <- normaliseSfData(data, "POINT")
	polyline <- findEncodedColumn(data, polyline)

	if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
		objArgs[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}

	## parmater checks
	usePolyline <- isUsingPolyline(polyline)
	checkNumeric(digits)
	checkPalette(palette)
	checkNumeric(size)
	checkNumeric(angle)

	## end parameter checks
	if ( !usePolyline ) {
		## TODO(check only a data.frame)
		data[['polyline']] <- googlePolylines::encode(data, lon = lon, lat = lat, byrow = TRUE)
		polyline <- 'polyline'
		## TODO(check lon & lat exist / passed in as arguments )
		objArgs[['lon']] <- NULL
		objArgs[['lat']] <- NULL
		objArgs[['polyline']] <- polyline
	}

	allCols <- textColumns()
	requiredCols <- requiredTextColumns()

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
		shape <- addDefaults(shape, requiredDefaults, "text")
	}
	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckTextDependency())
	invoke_method(map, "add_text", shape, layer_id)
}


requiredTextColumns <- function() {
	c('fill_colour', 'size','angle','anchor','alignment_baseline')
}


textColumns <- function() {
	c('polyline', 'fill_colour', 'size','angle','anchor','alignment_baseline')
}

textDefaults <- function(n) {
	data.frame(
		"size" = rep(32, n),
		"angle" = rep(0, n),
		"fill_colour" = rep("#440154", n),
		"anchor" = rep('middle', n),
		"alignment_baseline" = rep('center', n),
		stringsAsFactors = F
	)
}
