mapdeckLineDependency <- function() {
	list(
		htmltools::htmlDependency(
			"line",
			"1.0.0",
			system.file("htmlwidgets/lib/line", package = "mapdeck"),
			script = c("line.js")
		)
	)
}


#' Add line
#'
#' The Line Layer renders raised lines joining pairs of source and target coordinates
#'
#' @inheritParams add_arc
#' @param stroke_opacity value between 1 and 255. Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_colour variable or hex colour to use as the ending stroke colour
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
#' flights <- read.csv(url)
#' flights$id <- seq_len(nrow(flights))
#' flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
#'
#' mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#'   add_line(
#'     data = flights
#'     , layer_id = "line_layer"
#'     , origin = c("start_lon", "start_lat")
#'     , destination = c("end_lon", "end_lat")
#'     , stroke_colour = "airport1"
#'     , stroke_width = "stroke"
#'     , auto_highlight = TRUE
#'  )
#' }
#'
#' @details
#'
#' MULTIPOINT objects will be treated as single points. That is, if an sf objet
#' has one row with a MULTIPOINT object consisting of two points, this will
#' be expanded to two rows of single POINTs.
#' Therefore, if the origin is a MULTIPOINT of two points, and the destination is
#' a single POINT, the code will error as there will be an uneven number of rows
#'
#' @export
add_line <- function(
	map,
	data = get_map_data(map),
	layer_id = NULL,
	origin,
	destination,
	id = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	palette = "viridis",
	legend = FALSE,
	legend_options = NULL
) {

	l <- as.list( match.call() )
	l[[1]] <- NULL
	l[["data"]] <- NULL
	l[["map"]] <- NULL
	l[["layer_id"]] <- NULL
	l[["digits"]] <- NULL
	l[["auto_highlight"]] <- NULL

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )

	## if origin && destination == one column each, it's an sf_encoded
	## else, it's two column, which need to be encoded!
	if ( length(origin) == 2 && length(destination) == 2) {
		## lon / lat columns
		data[[ origin[1] ]] <- googlePolylines::encode(
			data[, origin, drop = F ]
			, lon = origin[1]
			, lat = origin[2]
			, byrow = T
		)
		data[[ destination[1] ]] <- googlePolylines::encode(
			data[, destination, drop = F ]
			, lon = destination[1]
			, lat = destination[2]
			, byrow = T
		)

		l[['origin']] <- origin[1]
		l[['destination']] <- destination[1]

	} else if (length(origin) == 1 && length(destination) == 1) {
		## encoded
		data <- normaliseMultiSfData(data, origin, destination)
		o <- unlist(data[[origin]])
		d <- unlist(data[[destination]])
		if(length(o) != length(d)) {
			stop("There are a different number of origin and destination POINTs, possibly due to MULTIPOINT geometries?")
		}
		data[[origin]] <- o
		data[[destination]] <- d

	} else {
		stop("expecting lon/lat origin destinations or sfc columns")
	}

	shape <- rcpp_line( data, l )
	#print( shape )

	map <- addDependency(map, mapdeckLineDependency())
	invoke_method(map, "add_line2", shape[["data"]], layer_id, auto_highlight, shape[["legend"]] )
}


#' @export
add_line_old <- function(
	map,
	data = get_map_data(map),
	layer_id = NULL,
	origin,
	destination,
	id = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	stroke_opacity = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	digits = 6,
	legend = FALSE,
	legend_options = NULL,
	palette = viridisLite::viridis
) {

	objArgs <- match.call(expand.dots = F)

	## if origin && destination == one column each, it's an sf_encoded
	## else, it's two column, which need to be encoded!
	if ( length(origin) == 2 && length(destination) == 2) {
		## lon / lat columns
		data[[ origin[1] ]] <- googlePolylines::encode(
			data[, origin, drop = F ]
			, lon = origin[1]
			, lat = origin[2]
			, byrow = T
		)
		data[[ destination[1] ]] <- googlePolylines::encode(
			data[, destination, drop = F ]
			, lon = destination[1]
			, lat = destination[2]
			, byrow = T
		)

		objArgs[['origin']] <- origin[1]
		objArgs[['destination']] <- destination[1]

	} else if (length(origin) == 1 && length(destination) == 1) {
		## encoded
		data <- normaliseMultiSfData(data, origin, destination)
		o <- unlist(data[[origin]])
		d <- unlist(data[[destination]])
		if(length(o) != length(d)) {
			stop("There are a different number of origin and destination POINTs, possibly due to MULTIPOINT geometries?")
		}
		data[[origin]] <- o
		data[[destination]] <- d

	} else {
		stop("expecting lon/lat origin destinations or sfc columns")
	}

	## parameter checks
	checkNumeric(digits)
	checkPalette(palette)
	layer_id <- layerId(layer_id, "line")

	## end parameter checks

	allCols <- lineColumns()
	requiredCols <- requiredLineColumns()

	colourColumns <- shapeAttributes(
		fill_colour = NULL
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

	## LEGEND
	legend <- resolveLegend(legend, legend_options, colour_palettes)

	requiredDefaults <- setdiff(requiredCols, names(shape))

	if(length(requiredDefaults) > 0){
		shape <- addDefaults(shape, requiredDefaults, "line")
	}

	shape <- jsonlite::toJSON(shape, digits = digits)

	map <- addDependency(map, mapdeckLineDependency())
	invoke_method(map, "add_line", shape, layer_id, auto_highlight, legend )
}



#' @rdname clear
#' @export
clear_line <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "line")
	invoke_method(map, "clear_line", layer_id )
}

requiredLineColumns <- function() {
	c("stroke_colour", "stroke_width", "stroke_opacity")
}

lineColumns <- function() {
	c("origin", "destination",
		"stroke_width", "stroke_colour", "stroke_opacity")
}

lineDefaults <- function(n) {
	data.frame(
		"stroke_colour" = rep("#440154", n),
		"stroke_width" = rep(1, n),
		"stroke_opacity" = rep(255, n),
		stringsAsFactors = F
	)
}
