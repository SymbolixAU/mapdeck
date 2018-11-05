


## TODO( allow MULTI* objects)
sfrow <- function( sf , sfc_type ) {
	geom_column <- attr(sf, "sf_column")
	return( which(vapply(sf[[geom_column]], function(x) attr(x, "class")[[2]], "") == sfc_type ) )
}


resolve_od_data <- function( data, l ) UseMethod("resolve_od_data")

resolve_od_data.sf <- function( data, l ) {
	if ( is.null( l[["origin"]] ) || is.null( l[["destination"]] ) ) {
		stop("origin and destination columns required")
	}
	return( l )
}


## data using a single geometry ()
resolve_data <- function( data, l, sf_geom ) UseMethod( "resolve_data" )

## use the specificed st_geometry column
#' @export
resolve_data.sf <- function( data, l, sf_geom ) {
	## TODO( allow MULTI* objects)

	sfc_col <- attr( data, "sf_column" )
	l[["geometry"]] <- sfc_col

	if( paste0( "sfc_", sf_col) != toupper( sf_geom ) ) {
		l[["data"]] <- data[ sfrow(data, sf_geom) , ]

	}

	# l[["polyline"]] <- sfc_col
	# l[["jsfunction"]] <- "geojson"
	# l[["geoconversion"]] <- "sf"
	return(l)
}

## TODO( needs to call the JS function which decodes the polyline )
#' @export
resolve_data.sfencoded <- function( data, l, sf_geom ) {

	data <- data[ googlePolylines::geometryRow(data, geometry = sf_geom, multi = TRUE), ]

	# l[["geoconversion"]] <- "sfencoded"
	l <- resolve_data.sfencodedLite( data, l )
	return( l )
}

#' @export
resolve_data.sfencodedLite <- function( data, l, sf_geom ) {
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
	l[["data_type"]] <- "sf"
	return( l )
}

#' @export
resolve_data.data.frame <- function( data, l, sf_geom ) {

	## data.frame will only really work for points, with a lon & lat column
	## for speed, need to turn to GeoJSON?

	if ( sf_geom != "POINT" )
		stop("only POINTS are supported for data.frames")
	## TODO( lon & lat are required )
	# lon <- l[["lon"]]
	# lat <- l[["lat"]]

	## convert lon & lat columns to a matrix? like waht sf::st_as_sf(df, coords = c() ) does?

	l[["data"]] <- data
	l[["data_type"]] <- "df"
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
