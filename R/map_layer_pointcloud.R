mapdeckPointcloudDependency <- function() {
	list(
		htmltools::htmlDependency(
			"pointcloud",
			"1.0.0",
			system.file("htmlwidgets/lib/pointcloud", package = "mapdeck"),
			script = c("pointcloud.js")
		)
	)
}


#' Add Pointcloud
#'
#' The Pointcloud Layer takes in coordinate points and renders them as circles
#' with a certain radius.
#'
#' @inheritParams add_scatterplot
#' @param elevation column containing the elevation values
#' @param light_settings list of light setting parameters. See \link{light_settings}
#'
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @examples
#' \donttest{
#' ## You need a valid access token from Mapbox
#' key <- 'abc'
#'
#' df <- capitals
#' df$z <- sample(10000:10000000, size = nrow(df))
#'
#' mapdeck(token = key, style = 'mapbox://styles/mapbox/dark-v9') %>%
#' add_pointcloud(
#'   data = df
#'   , lon = 'lon'
#'   , lat = 'lat'
#'   , elevation = 'z'
#'   , layer_id = 'point'
#'   , fill_colour = "country"
#'   , tooltip = "country"
#' )
#'
#' ## as an sf object wtih a Z attribute
#' library(sf)
#' sf <- sf::st_as_sf( df , coords = c("lon","lat","z"))
#'
#' mapdeck(token = key, style = 'mapbox://styles/mapbox/dark-v9') %>%
#' add_pointcloud(
#'   data = sf
#'   , layer_id = 'point'
#'   , fill_colour = "country"
#'   , tooltip = "country"
#' )
#'
#' }
#'
#' @details
#'
#' \code{add_pointcloud} supports POINT and MULTIPOINT sf objects
#'
#' @export
add_pointcloud <- function(
	map,
	data = get_map_data(map),
	lon = NULL,
	lat = NULL,
	elevation = NULL,
	polyline = NULL,
	radius = NULL,
	fill_colour = NULL,
	fill_opacity = NULL,
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

	# message("Using development version. Please check plots carefully")

	# l <- as.list( match.call( expand.dots = F) )
	# l[[1]] <- NULL    ## function call
	# l[["map"]] <- NULL
	# l[["data"]] <- NULL
	# l[["auto_highlight"]] <- NULL
	# l[["light_settings"]] <- NULL
	# l[["layer_id"]] <- NULL

	l <- list()
	l[["lon"]] <- force( lon )
	l[["lat"]] <- force( lat )
	l[["polyline"]] <- force( polyline )
	l[["elevation"]] <- force( elevation )
	l[["fill_colour"]] <- force( fill_colour)
	l[["fill_opacity"]] <- force( fill_opacity )
	l[["tooltip"]] <- force( tooltip )
	l[["id"]] <- force( id )
	l[["na_colour"]] <- force( na_colour )

	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )
	l <- resolve_elevation_data( data, l, elevation, c("POINT","MULTIPOINT") )

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "pointcloud")

	map <- addDependency( map, mapdeckPointcloudDependency() )
	data_types <- data_types( data )

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL
	jsfunc <- "add_pointcloud_geo"

	if ( tp == "sf" ) {
		geometry_column <- c( "geometry" )

		# print(data)
		# print( data_types )
		# print( l )
		# print( geometry_column )

		shape <- rcpp_pointcloud_geojson( data, data_types, l, geometry_column )
	} else if ( tp == "df" ) {

		## TODO( here or in rcpp? )
		if( is.null(elevation) ){
			l[["elevation"]] <- 0
		}

		geometry_column <- list( geometry = c("lon","lat","elevation") )
	  shape <- rcpp_pointcloud_geojson_df( data, data_types, l, geometry_column )

	} else if ( tp == "sfencoded" ) {

		geometry_column <- "polyline"
		shape <- rcpp_pointcloud_polyline( data, data_types, l, geometry_column )
		jsfunc <- "add_pointcloud_polyline"
	}

	light_settings <- jsonify::to_json(light_settings, auto_unbox = T)

	invoke_method(
		map, jsfunc, shape[["data"]], layer_id, light_settings,
		auto_highlight, highlight_colour, shape[["legend"]]
		)
}


#' @rdname clear
#' @export
clear_pointcloud <- function( map, layer_id = NULL) {
	layer_id <- layerId( layer_id, "pointcloud" )
	invoke_method(map, "clear_pointcloud", layer_id )
}

