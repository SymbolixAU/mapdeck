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
#' The Polygon Layer renders filled and/or stroked polygons. If using \code{sf} objects
#' only POLYGONs are supported, MULTIPOLYGONs are ignored.
#'
#' @inheritParams add_arc
#'
#' @param polyline column of \code{data} containing the polylines
#' @param fill_colour column of \code{data} or hex colour for the fill colour
#' @param fill_opacity value between 1 and 255. Either a string specifying the
#' column of \code{data} containing the fill opacity of each shape, or a value
#' between 1 and 255 to be applied to all the shapes
#' @param stroke_colour variable of \code{data} or hex colour for the stroke
#' @param stroke_width width of the stroke
#' @param light_settings list of light setting parameters. See \link{light_settings}
#' @param elevation the height of the polygon
#'
#'
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @examples
#' \donttest{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- melbourne
#' df$elevation <- sample(100:5000, size = nrow(df))
#' df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#'
#' mapdeck(
#'   token = key
#'   , style = mapdeck_style('dark')
#'   , location = c(145, -38)
#'   , zoom = 8
#'   ) %>%
#'   add_polygon(
#'     data = df
#'     , polyline = "geometry"
#'     , layer = "polygon_layer"
#'     , fill_colour = "SA2_NAME",
#'     , elevation = "elevation"
#'     , stroke_width = 0
#'     , tooltip = 'info'
#'     , legend = T
#'   )
#'
#' library(sf)
#' library(geojsonsf)
#'
#' sf <- geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
#'
#' mapdeck(
#'   token = key
#'   , style = mapdeck_style('dark')
#' ) %>%
#'   add_polygon(
#'     data = sf
#'     , layer = "polygon_layer"
#'     , fill_colour = "SA2_NAME16"
#'   )
#'
#' }
#'
#' @details
#'
#' \code{add_polygon} supports POLYGON and MULTIPOLYGON sf objects
#'
#' @export
add_polygon <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	stroke_colour = NULL,
	stroke_width = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
	elevation = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	light_settings = list(),
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL
) {

	# l <- as.list( match.call( expand.dots = F) )
	# l[[1]] <- NULL
	# l[["data"]] <- NULL
	# l[["map"]] <- NULL
	# l[["auto_highlight"]] <- NULL
	# l[["light_settings"]] <- NULL
	# l[["layer_id"]] <- NULL

	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["stroke_colour"]] <- force( stroke_colour)
	l[["stroke_width"]] <- force( stroke_width )
	l[["fill_colour"]] <- force( fill_colour)
	l[["fill_opacity"]] <- force( fill_opacity )
	l[["elevation"]] <- force( elevation )
	l[["tooltip"]] <- force(tooltip)
	l[["id"]] <- force(id)
	l[["na_colour"]] <- force(na_colour)

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_data( data, l, c("POLYGON","MULTIPOLYGON") )



	# data <- normaliseSfData(data, "POLYGON", multi = FALSE)
	# polyline <- findEncodedColumn(data, polyline)
	#
	# ## - if sf object, and geometry column has not been supplied, it needs to be
	# ## added to objArgs after the match.call() function
	# if( !is.null(polyline) && !polyline %in% names(l) ) {
	# 	l[['polyline']] <- polyline
	# }

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}


	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "polygon")

	map <- addDependency(map, mapdeckPolygonDependency())
	data_types <- data_types( data )

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_polygon_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" ) ## This is where we woudl also specify 'origin' or 'destination'
	 	shape <- rcpp_polygon_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_polygon_polyline( data, data_types, l, geometry_column )
		jsfunc <- "add_polygon_polyline"
	}

	light_settings <- jsonlite::toJSON(light_settings, auto_unbox = T)

	invoke_method(map, jsfunc, shape[["data"]], layer_id, light_settings, auto_highlight, highlight_colour, shape[["legend"]])
}



#' @rdname clear
#' @export
clear_polygon <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "polygon")
	invoke_method(map, "clear_polygon", layer_id )
}


