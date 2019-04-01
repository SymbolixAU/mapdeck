mapdeckColumnDependency <- function() {
	list(
		createHtmlDependency(
			name = "column",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/column", package = "mapdeck"),
			script = c("column.js")
		)
	)
}


#' Add column
#'
#'The ColumnLayer can be used to render a heatmap of vertical cylinders. It renders
#'a tesselated regular polygon centered at each given position (a "disk"), and extrude it in 3d.
#'
#' @inheritParams add_arc
#' @param lon column containing longitude values
#' @param lat column containing latitude values
#' @param polyline column of \code{data} containing the polylines
#' @param disk_resolution The number of sides to render the disk as.
#' The disk is a regular polygon that fits inside the given radius.
#' A higher resolution will yield a smoother look close-up, but also requires more resources to render.
#' @param radius in metres. Default 1000
#' @param coverage radius multiplier, in range [0,1]. The radius of the disk is calcualted
#' by coverage * radius
#' @param elevation_scale value to sacle the elevations of the hexagons. Default 1
#'
#' @inheritSection add_polygon data
#'
#' @examples
#' \dontrun{
#'
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#' set_token( key )
#'
#' df <- read.csv(paste0(
#' 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/'
#' , '3d-heatmap/heatmap-data.csv'
#' ))
#'
#' df <- df[!is.na(df$lng), ]
#' df$elev <- sample(500:5000, size = nrow(df), replace = T)
#'
#' mapdeck(style = mapdeck_style("dark"), pitch = 45) %>%
#' add_column(
#'   data = df[1:5000, ]
#'   , lat = "lat"
#'   , lon = "lng"
#'   , elevation = "elev"
#'   , fill_colour = "elev"
#'   , disk_resolution = 3
#'   , radius = 100
#'   , layer_id = "col_layer"
#'   , legend = TRUE
#'   , tooltip = "elev"
#' )
#'
#' library( sf )
#' sf <- sf::st_as_sf( df, coords = c("lng", "lat"))
#' sf$elev <- df$elev
#' mapdeck( style = mapdeck_style("dark"), pitch = 45 ) %>%
#' add_column(
#'   data = sf[1:500, ]
#'   , layer_id = "col_layer"
#'   , elevation = "elev"
#'   , radius = 10
#' )
#'
#' ## Using elevation and colour
#' df$weight <- 1
#' df$colour <- 1
#' df[10, ]$weight <- 100000
#' df[1000, ]$colour <- 100000
#'
#' mapdeck( token = key, style = mapdeck_style("dark"), pitch = 45) %>%
#' add_column(
#'   data = df
#'   , lat = "lat"
#'   , lon = "lng"
#'   , layer_id = "col_layer"
#'   , elevation_scale = 100
#'   , elevation = "weight"
#'   , colour = "colour"
#' )
#'
#'
#' }
#'
#' @details
#'
#' \code{add_column} supports POINT and MULTIPOINT sf objects
#'
#'
#' @export
add_column <- function(
	map,
	data = get_map_data(map),
	polyline = NULL,
	lon = NULL,
	lat = NULL,
	fill_colour = NULL,
	radius = 1000,
	elevation = NULL,
	elevation_scale = 1,
	coverage = 1,
	angle = 0,
	disk_resolution = 20,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	legend_format = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	transitions = NULL
) {

	l <- list()
	l[["polyline"]] <- force( polyline )
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )
	l[["fill_colour"]] <- force( fill_colour )
	l[["elevation"]] <- force( elevation )
	l[["tooltip"]] <- force( tooltip )
	l[["id"]] <- force( id )
	l[["na_colour"]] <- force( na_colour )


	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_elevation_data( data, l, elevation, c("POINT","MULTIPOINT") )

	bbox <- init_bbox()
	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	if( !is.null(l[["bbox"]] ) ) {
		bbox <- l[["bbox"]]
		l[["bbox"]] <- NULL
	}

	checkHexAlpha(highlight_colour)

	layer_id <- layerId(layer_id, "column")
	map <- addDependency(map, mapdeckColumnDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_column_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )
		shape <- rcpp_column_geojson( data, l, geometry_column )
	} else if ( tp == "df" ) {
		geometry_column <- list( geometry = c("lon", "lat") )
		shape <- rcpp_column_geojson_df( data, l, geometry_column )
	} else if ( tp == "sfencoded" ) {
		geometry_column <- "polyline"
		shape <- rcpp_column_polyline( data, l, geometry_column )
		jsfunc <- "add_column_polyline"
	}

	js_transitions <- resolve_transitions( transitions, "column" )

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, auto_highlight, highlight_colour,
		radius, elevation_scale, disk_resolution, angle, coverage, shape[["legend"]], bbox, update_view,
		focus_layer, js_transitions
	)
}


#' @rdname clear
#' @export
clear_column <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "column")
	invoke_method(map, "md_layer_clear", layer_id, "column" )
}
