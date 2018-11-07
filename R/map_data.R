


## TODO( allow MULTI* objects)
sfrow <- function( sf , sfc_type ) {
	geom_column <- attr(sf, "sf_column")
	return( which(vapply(sf[[geom_column]], function(x) attr(x, "class")[[2]], "") == sfc_type ) )
}


resolve_od_data <- function( data, l, origin, destination ) UseMethod("resolve_od_data")

#' @export
resolve_od_data.sf <- function( data, l, origin, destination ) {
	if ( is.null( l[["origin"]] ) || is.null( l[["destination"]] ) ) {
		stop("origin and destination columns required")
	}
	l[["data_type"]] <- "sf"
	return( l )
}

#' @export
resolve_od_data.sfencoded <- function( data, l, origin, destination ) {
	# if ( is.null( l[["origin"]] ) || is.null( l[["destination"]] ) ) {
	# 	stop("origin and destination columns required")
	# }
	#
	# #data <- data[ googlePolylines::geometryRow(data, geometry = sf_geom, multi = TRUE), ]
	#
	# # l[["data_type"]] <- "sfencoded"
	# # l[["data"]] <- data
	# l <- resolve_od_data.sfencodedLite( data, l, origin, destination )
	# return( l )
  stop("data type not supported")
}

#' @export
resolve_od_data.sfencodedLite <- function( data, l, origin, destination ) {
#
# 	# if ( sf_geom != "POLYGON" ) {   ## TODO( I don't like this)
# 	# 	data <- unlistMultiGeometry( data, polyline )  ## TODO( move this to C++)
# 	# }
#
# 	data <- unlistMultiGeometry( data, origin )
# 	data <- unlistMultiGeometry( data, destination )
#
# 	l[["origin"]] <- origin
# 	l[["destination"]] <- destination
#
# 	l[["data_type"]] <- "sfencoded"
# 	l[["data"]] <- data ## attach the data becaue it gets modified and it needs to be returend
# 	return( l )
	stop("data type not supported")
}

#' @export
resolve_od_data.data.frame <- function( data, l, origin, destination ) {
	if ( is.null( l[["origin"]] ) || is.null( l[["destination"]] ) ) {
		stop("origin and destination columns required")
	}
	l[["data_type"]] <- "df"

	l[["start_lon"]] <- origin[1]
	l[["start_lat"]] <- origin[2]
	l[["end_lon"]] <- destination[1]
	l[["end_lat"]] <- destination[2]

	l[["origin"]] <- NULL
	l[["destination"]] <- NULL

	return( l )
}

resolve_elevation_data <- function( data, l, elevation, sf_geom ) UseMethod( "resolve_elevation_data" )

#' @export
resolve_elevation_data.data.frame <- function( data, l, elevation, sf_geom ) {
	if ( sf_geom != "POINT" )
		stop("only POINTS are supported for data.frames")

	l[["data"]] <- data
	l[["data_type"]] <- "df"

	return( l )
}

#' @export
resolve_elevation_data.sf <- function( data, l, elevation, sf_geom ) {
	return(
		resolve_data( data, l, sf_geom )
	)
}

## data using a single geometry ()
resolve_data <- function( data, l, sf_geom ) UseMethod( "resolve_data" )

## use the specificed st_geometry column
#' @export
resolve_data.sf <- function( data, l, sf_geom ) {
	## TODO( allow MULTI* objects)

	sfc_col <- attr( data, "sf_column" )
	l[["geometry"]] <- sfc_col

	if( paste0( "sfc_", sfc_col) != toupper( sf_geom ) ) {
		l[["data"]] <- data[ sfrow(data, sf_geom) , ]
	}
	l[["data_type"]] <- "sf"
	return(l)
}

## TODO( needs to call the JS function which decodes the polyline )
#' @export
resolve_data.sfencoded <- function( data, l, sf_geom ) {

	data <- data[ googlePolylines::geometryRow(data, geometry = sf_geom, multi = TRUE), ]

	l[["data_type"]] <- "sfencoded"
	l[["data"]] <- data
	l <- resolve_data.sfencodedLite( data, l, sf_geom )
	return( l )
}

#' @export
resolve_data.sfencodedLite <- function( data, l, sf_geom ) {
	## TODO( requries polyline parameter )
	# polyline <- findEncodedColumn(data, l[["polyline"]])

	## - if sf object, and geometry column has not been supplied, it needs to be
	## added to objArgs after the match.call() function
	# if( !is.null(polyline) && !polyline %in% names(l) ) {
	#	l[['polyline']] <- polyline
	polyline <- attr( data, "encoded_column")
	if ( sf_geom != "POLYGON" ) {   ## TODO( I don't like this)
  	data <- unlistMultiGeometry( data, polyline )  ## TODO( move this to C++)
	}

	l[["polyline"]] <- polyline

	l[["data_type"]] <- "sfencoded"
	l[["data"]] <- data ## attach the data becaue it gets modified and it needs to be returend
	return( l )
}

#' @export
resolve_data.data.frame <- function( data, l, sf_geom ) {

	## data.frame will only really work for points, with a lon & lat column
	## for speed, need to turn to GeoJSON?

	if ( sf_geom != "POINT" )
		stop("only POINTS are supported for data.frames")

	l[["data"]] <- data
	l[["data_type"]] <- "df"

	return( l )
}

resolve_data.default <- function( data ) stop("This type of data is not supported")


resolve_palette <- function( l, palette ) {
	if ( is.matrix( palette ) ) {
		l[['palette']] <- palette
	}
	return( l )
}


resolve_legend <- function( l, legend ) {
	l[['legend']] <- legend
	return( l )
}

resolve_legend_options <- function( l, legend_options ) {
	l[["legend_options"]] <- legend_options
	return( l )
}
