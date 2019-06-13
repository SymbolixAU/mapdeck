
#' Add sf
#'
#' Adds an sf object to the map.
#'
#' @inheritParams add_polygon
#' @param ... other argumetns passed to one of the plotting layers. See details
#'
#' @details
#' The plotting layer is determined by the type of sf geometries.
#'
#' \itemize{
#'   \item{POINT and MULTIPOINT objects will call \link{add_scatterplot}}
#'   \item{LINESTRING and MULTILINESTRING objects will call \link{add_path}}
#'   \item{POLYGON and MULTIPOLYGON objects will call \link{add_polygon}}
#'   \item{GEOMETRY objects will call \link{add_geojson}}
#' }
#'
#' @export
add_sf <- function( map, data = get_map_data(map), ... ) {

	if (!inherits(data, "sf")) stop("mapdeck - expecting sf object")

	geom <- data[[ attr( data, "sf_column" ) ]]
	cls <- substr( class(geom)[1], 5, nchar(class(geom)[1]))

	if( cls %in% c("POINT","MULTIPOINT")) {
		add_scatterplot( map = map, data = data, ... )
	} else if ( cls %in% c("LINESTRING", "MULTILINESTRING")) {
		add_path( map = map, data = data, ... )
	} else if ( cls %in% c("POLYGON", "MULTIPOLYGON")) {
		add_polygon( map = map, data = data, ... )
	} else {
		add_geojson( map = map, data = data, ... )
	}
}
