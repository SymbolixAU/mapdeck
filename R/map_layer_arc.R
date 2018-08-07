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
#' The Arc Layer renders raised arcs joining pairs of source and target coordinates
#'
#' @param map a mapdeck map object
#' @param data data to be used in the layer
#' @param layer_id single value specifying an id for the layer. Use this value to
#' distinguish between shape layers of the same type
#' @param origin vector of longitude and latitude columns, or an \code{sfc} column
#' @param destination vector of longitude and latitude columns, or an \code{sfc} column
#' @param id an id value in \code{data} to identify layers when interacting in Shiny apps
#' @param stroke_from variable or hex colour to use as the staring stroke colour
#' @param stroke_from_opacity value between 1 and 255. Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_to variable or hex colour to use as the ending stroke colour
#' @param stroke_to_opacity value between 1 and 255. Either a string specifying the
#' column of \code{data} containing the stroke opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_width width of the stroke
#' @param digits integer. Use this parameter to specify how many digits (decimal places)
#' should be used for the latitude / longitude coordinates.
#' @param palette a function, or list of functions which generates hex colours
#'
#' @examples
#' \dontrun{
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
#' 	add_arc(
#' 		data = flights
#' 		, layer_id = "arc_layer"
#' 		, origin = c("start_lon", "start_lat")
#' 		, destination = c("end_lon", "end_lat")
#' 		, stroke_from = "airport1"
#' 		, stroke_to = "airport2"
#' 		, stroke_width = "stroke"
#' 	)
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
add_arc <- function(
	map,
	data = get_map_data(map),
	layer_id,
	origin,
	destination,
	id = NULL,
	stroke_from = NULL,
	stroke_from_opacity = NULL,
	stroke_to = NULL,
	stroke_to_opacity = NULL,
	stroke_width = NULL,
	digits = 6,
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


	## end parameter checks

	# lon_from <- origin[1]
	# lat_from <- origin[2]
	# lon_to <- destination[1]
	# lat_to <- destination[2]
	# objArgs[['lat_from']] <- lat_from
	# objArgs[['lat_to']] <- lat_to
	# objArgs[['lon_from']] <- lon_from
	# objArgs[['lon_to']] <- lon_to


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
	invoke_method(map, "add_arc", shape, layer_id )
}

requiredArcColumns <- function() {
	c("stroke_width", "stroke_from", "stroke_to",
		"stroke_from_opacity","stroke_to_opacity")
}

arcColumns <- function() {
	c("origin", "destination",
		"stroke_width", "stroke_from", "stroke_to",
		"stroke_from_opacity", "stroke_to_opacity")
}

arcDefaults <- function(n) {
	data.frame(
		"stroke_from" = rep("#440154", n),
		"stroke_to" = rep("#FDE725", n),
		"stroke_from_opacity" = rep(255, n),
		"stroke_to_opacity" = rep(255, n),
		"stroke_width" = rep(1, n),
		stringsAsFactors = F
	)
}
