sfrow <- function( sf , sfc_type ) {
	geom_column <- attr(sf, "sf_column")
	return( which(vapply(sf[[geom_column]], function(x) attr(x, "class")[[2]], "") %in% sfc_type ) )
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

	if ( !is.null( l[["polyline"]] ) ) {
		## the user supplied a polyline in a data.frame, so we need to allow this through
		l[["data_type"]] <- "sfencoded"
	} else {
	  if ( !(all(sf_geom %in% c( "POINT", "MULTIPOINT") ) ) )
		  stop("unsupported data type")

		l[["data_type"]] <- "df"
	}

	l[["data"]] <- data

	return( l )
}

#' @export
resolve_elevation_data.sf <- function( data, l, elevation, sf_geom ) {
	return(
		resolve_data( data, l, sf_geom )
	)
}

#' @export
resolve_elevation_data.sfencoded <- function( data, l, elevation, sf_geom ) {

	data <- data[ googlePolylines::geometryRow(data, geometry = sf_geom[1], multi = TRUE), ]

	l[["data_type"]] <- "sfencoded"
	l[["data"]] <- data
	l <- resolve_elevation_data.sfencodedLite( data, l, elevation, sf_geom )
	return( l )
}

#' @export
resolve_elevation_data.sfencodedLite <- function( data, l, elevation, sf_geom ) {
	polyline <- attr( data, "encoded_column")
	if ( !all(sf_geom %in% c("POLYGON","MULTIPOLYGON") ) ) {   ## TODO( I don't like this)
		data <- unlistMultiGeometry( data, polyline )  ## TODO( move this to C++)
	}

	l[["polyline"]] <- polyline

	l[["data_type"]] <- "sfencoded"
	l[["data"]] <- data ## attach the data becaue it gets modified and it needs to be returend
	return( l )
}

## data using a single geometry ()
resolve_data <- function( data, l, sf_geom ) UseMethod( "resolve_data" )

sfc_type <- function( sf, sfc_col ) {
	cls <- attr(sf[[sfc_col]], "class")
	return( gsub("sfc_", "", cls[1] ) )
}

##
sf_needs_subsetting <- function( data, sfc_col, sf_geom ) {
	return( !sfc_type( data, sfc_col ) %in% toupper( sf_geom ) )
}

## use the specificed st_geometry column
#' @export
resolve_data.sf <- function( data, l, sf_geom ) {

	sfc_col <- attr( data, "sf_column" )
	l[["geometry"]] <- sfc_col

	if( sf_needs_subsetting( data, sfc_col, sf_geom ) ) {
		l[["data"]] <- data[ sfrow(data, sf_geom) , ]
	}
	l[["data_type"]] <- "sf"
	return(l)
}

## TODO( needs to call the JS function which decodes the polyline )
#' @export
resolve_data.sfencoded <- function( data, l, sf_geom ) {

	data <- data[ googlePolylines::geometryRow(data, geometry = sf_geom[1], multi = TRUE), ]

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
	if ( sf_geom[1] != "POLYGON" ) {   ## TODO( I don't like this)
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
	if ( !is.null( l[["polyline"]] ) ) {
		## the user supplied a polyline in a data.frame, so we need to allow this through
		l[["data_type"]] <- "sfencoded"
	} else {
		if ( sf_geom[1] != "POINT" )
			stop("unsupported data type")

		l[["data_type"]] <- "df"
	}
	l[["data"]] <- data
	return( l )
}

resolve_data.default <- function( data ) stop("This type of data is not supported")


resolve_palette <- function( l, palette ) {
	if ( is.function( palette ) ) {
		warning("Function palettes have been deprecated, reverting to the viridis palette. See the palette arguemnt in the help file for valid arguments")
	} else {
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
