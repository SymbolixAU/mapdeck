


## TODO( allow MULTI* objects)
sfrow <- function( sf , sfc_type ) {
	geom_column <- attr(sf, "sf_column")
	return( which(vapply(sf[[geom_column]], function(x) attr(x, "class")[[2]], "") == sfc_type ) )
}



## data using a single geometry ()
resolve_data <- function( data, l, force, sf_geom ) UseMethod( "resolve_data" )

## use the specificed st_geometry column
#' @export
resolve_data.sf <- function( data, l, force, sf_geom ) {
	## TODO( if there are rows other than LINESTRING, need to filter)
	## TODO( if attr(roads$geometry, "class") == sf_geom we can set force = TRUE, becaues the whole geometry is one type )
	sfc_col <- attr(data, "sf_column") ## TODO( handle multiple geometry columns, such as origin & destination )
	#print("sfc_col: ")
	#print(sfc_col)
	if ( !force ) {
		l[["data"]] <- data[ sfrow(data, sf_geom) , ]
	}
	l[["geometry"]] <- sfc_col
	# l[["polyline"]] <- sfc_col
	# l[["jsfunction"]] <- "geojson"
	# l[["geoconversion"]] <- "sf"
	return(l)
}

## TODO( needs to call the JS function which decodes the polyline )
#' @export
resolve_data.sfencoded <- function( data, l, force, sf_geom ) {
	if( !force ) {
		data <- data[ googlePolylines::geometryRow(data, geometry = sf_geom, multi = TRUE), ]
	}
	# l[["geoconversion"]] <- "sfencoded"
	l <- resolve_data.sfencodedLite( data, l )
	return( l )
}

#' @export
resolve_data.sfencodedLite <- function( data, l, force, sf_geom ) {
	## TODO( requries polyline parameter )
	polyline <- findEncodedColumn(data, l[["polyline"]])

	## - if sf object, and geometry column has not been supplied, it needs to be
	## added to objArgs after the match.call() function
	if( !is.null(polyline) && !polyline %in% names(l) ) {
		l[['polyline']] <- polyline
		data <- unlistMultiGeometry( data, polyline )
	}

	l[["data"]] <- data ## attach the data becaue it gets modified and it needs to be returend
	# l[["jsfunction"]] <- "decode"
	# l[["geoconversion"]] <- "sfencodedLite"

	return( l )
}

resolve_data.data.frame <- function( data, l, force, sf_geom ) {

	## data.frame will only really work for points, with a lon & lat column
	## for speed, need to turn to GeoJSON?
	if ( sf_geom != "POINT" )
		stop("only POINTS are supported for data.frames")
	## TODO( lon & lat are required )
	# lon <- l[["lon"]]
	# lat <- l[["lat"]]

	l[["data"]] <- data
	# l[["geoconversion"]] <- "dataframe"
	# l[["jsfunction"]] <- "geojson"

	return( l )
	#stop("not done yet")
}

resolve_data.default <- function( data ) stop("This type of data is not supported")


resolve_palette <- function( l, palette ) {

	if ( is.matrix( palette ) ) {
		#print("resolving matrix palette")
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
