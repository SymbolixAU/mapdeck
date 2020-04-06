
init_bbox <- function() return(  list(c(-180,-90),c(180,90)) )

# sfrow <- function( sf , sfc_type ) {
# 	geom_column <- attr(sf, "sf_column")
# 	return( which(vapply(sf[[geom_column]], function(x) attr(x, "class")[[2]], "") %in% sfc_type ) )
# }

resolve_od_data <- function( data, l, origin, destination ) UseMethod("resolve_od_data")

#' @export
resolve_od_data.sf <- function( data, l, origin, destination ) {
	if ( is.null( l[["origin"]] ) || is.null( l[["destination"]] ) ) {
		stop("mapdeck - origin and destination columns required")
	}

	## downcast each side of the sf object to POINT
	attr( data, "sf_column" ) <- origin
	data <- sfheaders::sf_cast( data, "POINT" )

	attr( data, "sf_column" ) <- destination
	data <- sfheaders::sf_cast( data, "POINT" )

	l[["data"]] <- data


	l[["data_type"]] <- "sf"
	l[["bbox"]] <- get_od_box( data, l )
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
  stop("mapdeck - data type not yet for supported origin-destination plots")
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
	stop("mapdeck - data type not supported")
}

#' @export
resolve_od_data.data.frame <- function( data, l, origin, destination ) {
	if ( is.null( l[["origin"]] ) || is.null( l[["destination"]] ) ) {
		stop("mapdeck - origin and destination columns required")
	}

	if( length( origin ) == 2 ) {
		l[["start_lon"]] <- origin[1]
		l[["start_lat"]] <- origin[2]
		l[["start_elev"]] <- 0
	} else if ( length( origin ) == 3 ) {
		l[["start_lon"]] <- origin[1]
		l[["start_lat"]] <- origin[2]
		l[["start_elev"]] <- origin[3]
	} else {
		stop("mapdeck - origin and destination columns should contain lon & lat, and optionally elevation columns")
	}

	if( length( destination ) == 2 ) {
		l[["end_lon"]] <- destination[1]
		l[["end_lat"]] <- destination[2]
		l[["end_elev"]] <- 0
	} else if ( length( destination ) == 3 ) {
		l[["end_lon"]] <- destination[1]
		l[["end_lat"]] <- destination[2]
		l[["end_elev"]] <- destination[3]
	} else {
		stop("mapdeck - origin and destination columns should contain lon & lat, and optionally elevation columns")
	}

	# if( length(origin) != 2 | length(destination) != 2 ) {
	# 	stop("mapdeck - origin and destination columns should both contain lon & lat values")
	# }

	l[["data_type"]] <- "df"
	l[["bbox"]] <- get_od_box( data, l )

	# l[["start_lon"]] <- origin[1]
	# l[["start_lat"]] <- origin[2]
	# l[["end_lon"]] <- destination[1]
	# l[["end_lat"]] <- destination[2]

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
		  stop("mapdeck - unsupported data type")

		l[["data_type"]] <- "df"
		l[["bbox"]] <- get_box( data, l )
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
	l[["bbox"]] <- get_box( data, l )
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

# sfc_type <- function( sf, sfc_col ) {
# 	cls <- attr(sf[[sfc_col]], "class")
# 	return( gsub("sfc_", "", cls[1] ) )
# }

##
# sf_needs_subsetting <- function( data, sfc_col, sf_geom ) {
# 	return( !sfc_type( data, sfc_col ) %in% toupper( sf_geom ) )
# }


#' @export
resolve_data.mesh3d <- function( data, l, sf_geom ) {
	l[["data"]] <- data
	l[["bbox"]] <- get_box( data, l )
	l[["geometry"]] <- "geometry"
	l[["data_type"]] <- "mesh"
	return(l)
}
#' @export
resolve_data.quadmesh <- function( data, l, sf_geom ) {
	l[["data"]] <- data
	l[["bbox"]] <- get_box( data, l )
	l[["geometry"]] <- "geometry"
	l[["data_type"]] <- "mesh"
	return(l)
}

## use the specificed st_geometry column
#' @export
resolve_data.sf <- function( data, l, sf_geom ) {

	sfc_col <- attr( data, "sf_column" )
	l[["geometry"]] <- sfc_col

	# if( sf_needs_subsetting( data, sfc_col, sf_geom ) ) {
	# 	l[["data"]] <- data[ sfrow(data, sf_geom) , ]
	# }

	## TODO: move to c++
	## only cast if it's needed
	cls <- attr( data[[ sfc_col ]], "class" )

	if( is.null( cls ) ) {
		stop("mapdeck - invalid sf object; have you loaded library(sf)?")
	}

	cls <- gsub("sfc_", "", cls[1])
	if( cls != sf_geom ) {
		l[["data"]] <- sfheaders::sf_cast( data, sf_geom )
	}

	l[["bbox"]] <- get_box( data, l )
	l[["data_type"]] <- "sf"
	return(l)
}

get_box <- function( data, l ) UseMethod("get_box")

#' @export
get_box.mesh3d <- function( data, l ) {
	xrange <- range(data[["vb"]][1L, ], na.rm = TRUE)
	yrange <- range(data[["vb"]][2L, ], na.rm = TRUE)

	bbox <- list(
		c(xrange[1L], yrange[1L]), c(xrange[2L], yrange[2L])
	)
	return( jsonify::to_json( bbox ) )
}
#' @export
get_box.quadmesh <- function( data, l ) {
	md <- data[["raster_metadata"]]
	if(is.null(md)) {
		stop("mapdeck - expecting raster_metadata attribute on quadmesh object. Make sure you are using v0.4.0 of quadmesh")
	}
  bbox <- list(
  	 c(md[["xmn"]], md[["ymn"]]), c(md[["xmx"]], md[["ymx"]])
  	 )
  return( jsonify::to_json( bbox ) )
}


#' @export
get_box.sfencoded <- function( data, l ) {
	bbox <- attr( data, "sfAttributes")[["bbox"]]
	bbox <- list(c(bbox[1:2]), c(bbox[3:4]))
	return( jsonify::to_json( bbox ) )
}

#' @export
get_box.sf <- function( data, l ) {
	bbox <- attr(data[[ l[["geometry"]] ]], "bbox")
	bbox <- list(c(bbox[1:2]), c(bbox[3:4]))
	return( jsonify::to_json( bbox ) )
}

#' @export
get_box.data.frame <- function( data, l ) {

	lat <- data[, l[["lat"]], drop = TRUE ]
	lon <- data[, l[["lon"]], drop = TRUE ]
	xmin <- min(lon); xmax <- max(lon)
	ymin <- min(lat); ymax <- max(lat)
	bbox <- list( c(xmin, ymin), c(xmax, ymax) )
	return( jsonify::to_json( bbox ) )
}

get_od_box <- function( data, l ) UseMethod("get_od_box")

#' @export
get_od_box.sf <- function( data, l ) {

	obbox <- attr( data[[ l[["origin"]] ]], "bbox" )
	dbbox <- attr( data[[ l[["destination"]] ]], "bbox" )

	xmin <- min( obbox[1], dbbox[1] )
	ymin <- min( obbox[2], dbbox[2] )
	xmax <- max( obbox[3], dbbox[3] )
	ymax <- max( obbox[4], dbbox[4] )
	bbox <- list( c(xmin, ymin), c(xmax, ymax) )
	return( jsonify::to_json( bbox ) )
}

#' @export
get_od_box.data.frame <- function( data, l ) {

	lon <- c( data[, l[["origin"]][1], drop = TRUE ], data[, l[["destination"]][1], drop = TRUE ] )
	lat <- c( data[, l[["origin"]][2], drop = TRUE ], data[, l[["destination"]][2], drop = TRUE ] )

	xmin <- min(lon); xmax <- max(lon)
	ymin <- min(lat); ymax <- max(lat)
	bbox <- list( c(xmin, ymin), c(xmax, ymax) )
	return( jsonify::to_json( bbox ) )
}

#' @export
resolve_data.sfencoded <- function( data, l, sf_geom ) {

	if ( "POLYGON" %in% sf_geom & !("list" %in% attr( data[[ attr( data, "encoded_column") ]], "class" )) ) {
		stop("mapdeck - sfencoded POLYGON must be a list column")
	}

	if( !attr( data, "sfAttributes" )[["type"]] %in% sf_geom ) {
	  data <- data[ googlePolylines::geometryRow(data, geometry = sf_geom[1], multi = TRUE), ]
	}

	l[["bbox"]] <- get_box( data, l )
	l[["data_type"]] <- "sfencoded"
	l[["data"]] <- data
	l <- resolve_data.sfencodedLite( data, l, sf_geom )
	return( l )
}

#' @export
resolve_data.sfencodedLite <- function( data, l, sf_geom ) {

	polyline <- attr( data, "encoded_column")
	if ( sf_geom[1] != "POLYGON" ) {   ## TODO( POLYGONs must be a list column I don't like this)
  	data <- unlistMultiGeometry( data, polyline )  ## TODO( move this to C++)
	}

	l[["polyline"]] <- polyline
	l[["data_type"]] <- "sfencoded"
	l[["data"]] <- data ## attach the data becaue it gets modified and it needs to be returend
	return( l )
}

#' @export
resolve_data.data.frame <- function( data, l, sf_geom ) {

	if( !inherits(data, "sf") &
			!inherits(data, "sfencoded") &
			!inherits(data, "sfencodedLite" ) &
			is.null( l[["polyline"]] )
		) {

		if( is.null(l[["lon"]] ) ) {
			l[["lon"]] <- find_lon_column( names( data ) )
		}
		if( is.null(l[["lat"]] ) ) {
			l[["lat"]] <- find_lat_column( names( data ) )
		}
	}

	## data.frame will only really work for points, with a lon & lat column
	if ( !is.null( l[["polyline"]] ) ) {
		## the user supplied a polyline in a data.frame, so we need to allow this through
		l[["data_type"]] <- "sfencoded"
	} else {
		if ( sf_geom[1] != "POINT" )
			stop("mapdeck - unsupported data type")

		l[["bbox"]] <- get_box( data, l )
		l[["data_type"]] <- "df"
	}

	l[["data"]] <- data
	return( l )
}

#' @export
resolve_data.default <- function( data, ... ) stop("mapdeck - This type of data is not supported")

resolve_geojson_data <- function( data, l ) UseMethod("resolve_geojson_data")

#' @export
resolve_geojson_data.sf <- function( data, l ) {
	geom <- attr(data, "sf_column")
	l[["geometry"]] <- geom
	l[["data_type"]] <- "sf"
	l[["bbox"]] <- get_box( data, l )
	return( l )
}

#' @export
resolve_geojson_data.json <- function( data, l ) {
  l[["data_type"]] <- "geojson"
	return( l )
}

#' @export
resolve_geojson_data.geojson <- function( data, l ) {
  l[["data_type"]] <- "geojson"
  return( l )
}

#' @export
resolve_geojson_data.character <- function( data, l ) {
	if ( is_url( data ) ) {
		sf <- geojsonsf::geojson_sf( data )
		l[["data"]] <- sf
		return(
			resolve_geojson_data( sf, l )
		)
	}
	l[["data_type"]] <- "geojson"
	return( l )
}

#' @export
resolve_geojson_data.default <- function( data, l ) stop("mapdeck - I don't know how to handle this type of data")


resolve_palette <- function( l, palette ) {
	if ( is.function( palette ) ) {
		warning("Function palettes have been deprecated, reverting to the viridis palette. See the palette arguemnt in the help file for valid arguments")
	} else {
		l[['palette']] <- palette
	}
	return( l )
}


resolve_legend <- function( l, legend ) {
	if(inherits( legend, "json" ) ) {
		l[["legend"]] <- FALSE
	} else {
	  l[['legend']] <- legend
	}
	return( l )
}

resolve_legend_options <- function( l, legend_options ) {
	l[["legend_options"]] <- legend_options
	return( l )
}

resolve_legend_format <- function( l, legend_format ) {
	if( is.null( legend_format ) ) return( l )

	l <- jsonlite::fromJSON( l )

	for( i in names( legend_format ) ) {

		var <- l[[ i ]][[ "variable" ]]
		l[[ i ]][[ "variable" ]] <- legend_format[[ i ]]( var )
	}
	l <- jsonify::to_json( l, numeric_dates = FALSE )
	return( l )
}

is_url <- function(geojson) grepl("^https?://", geojson, useBytes=TRUE)


# resolve opacity
#
resolve_opacity <- function( opacity ) {
	if( !is.null( opacity ) ) {
		if( is.numeric( opacity ) ) {
	    if( opacity < 1 & opacity >= 0 ) opacity <- opacity * 255
		}
	}
	return( opacity )
}


find_lat_column = function(names) {

	lats = names[grep("^(lat|lats|latitude|latitudes|stop_lat|shape_pt_lat)$", names, ignore.case = TRUE)]

	if (length(lats) == 1) {
		return(lats)
	}
	stop("mapdeck - could not find latitude column")
}


find_lon_column = function(names) {

	lons = names[grep("^(lon|lons|lng|lngs|long|longs|longitude|longitudes|stop_lon|shape_pt_lon)$", names, ignore.case = TRUE)]

	if (length(lons) == 1) {
		return(lons)
	}
	stop("mapdeck - could not find longitude column")
}
