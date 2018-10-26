


## TODO( allow MULTI* objects)
sfrow <- function( sf , sfc_type ) {
	geom_column <- attr(sf, "sf_column")
	return( which(vapply(sf[[geom_column]], function(x) attr(x, "class")[[2]], "") == sfc_type ) )
}



## data using a single geometry ()
resolve_data <- function( data, l, force ) UseMethod( "resolve_data" )

## use the specificed st_geometry column
#' @export
resolve_data.sf <- function( data, l, force ) {
	## TODO( if there are rows other than LINESTRING, need to filter)
	sfc_col <- attr(data, "sf_column")
	if ( !force ) {
		data[ sfrow(data, "LINESTRING") , ]
	}
	l[["polyline"]] <- sfc_col
	l[["jsfunction"]] <- "geojson"
	return(l)
}

## TODO( needs to call the JS function which decodes the polyline )
#' @export
resolve_data.sfencoded <- function( data, l, force ) {
	if( !force ) {
		data <- data[ googlePolylines::geometryRow(data, geometry = "LINESTRING", multi = TRUE), ]
	}
	l <- resolve_data.sfencodedLite( data, l )
	return( l )
}

#' @export
resolve_data.sfencodedLite <- function( data, l, force ) {
	## TODO( requries polyline parameter )
	polyline <- findEncodedColumn(data, l[["polyline"]])

	## - if sf object, and geometry column has not been supplied, it needs to be
	## added to objArgs after the match.call() function
	if( !is.null(polyline) && !polyline %in% names(l) ) {
		l[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}

	l[["data"]] <- data ## attach the data becaue it gets modified and it needs to be returend
	l[["jsfunction"]] <- "decode"

	return( l )
}

resolve_data.data.frame <- function( data, l ) {
	stop("not done yet")
}

resolve_data.default <- function( data ) stop("This type of data is not supported")
