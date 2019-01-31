# Find Encoded Column
#
# This function is called early in each add_layer function to see if the
# object is sfencoded, and therefore tries to find the polyline column.
# This is required if the user has supplied an `sfencoded` object
#
# @param data the data object
# @param polyline the 'polyline' parameter set by the user in the add_ funciton call
findEncodedColumn <- function(data, polyline) UseMethod("findEncodedColumn")

#' @export
findEncodedColumn.sfencoded <- function(data, polyline) {
	if(is.null(polyline)) polyline <- attr(data, "encoded_column")
	return(polyline)
}

#' @export
findEncodedColumn.default <- function(data, polyline) polyline

normaliseMultiSfData <- function(data, origin, destination) UseMethod("normaliseMultiSfData")

#' @export
normaliseMultiSfData.sf <- function(data, origin, destination) {
	attr(data, 'sf_column') <- origin
	enc_origin <- googlePolylines::encode( data[, origin ] )

	attr(data, 'sf_column') <- destination

	enc <- googlePolylines::encode( data )
	enc[, origin ] <- enc_origin

	attr(enc, 'encoded_column') <- origin
	one <- googlePolylines::geometryRow( enc, "POINT" )

	attr(enc, 'encoded_column') <- destination
	two <- googlePolylines::geometryRow( enc, "POINT" )

	point_rows <- intersect(one, two)
	attr(enc, 'class') <- c("sfencoded", "data.frame")
	return(enc[ point_rows, ])
}

normaliseSfData <- function(data, geom, multi = TRUE) UseMethod("normaliseSfData")

#' @export
normaliseSfData.sf <- function(data, geom, multi = TRUE) {
	enc <- googlePolylines::encode(data)
	data <- normaliseSfData(enc, geom, multi)
	return(data)
}

#' @export
normaliseSfData.sfencoded <- function(data, geom, multi = TRUE) {
	idx <- googlePolylines::geometryRow(data, geom, multi)
	return(data[idx, names(data), drop = F])
}

#' @export
normaliseSfData.default <- function(data, geom, multi = TRUE) data


normalisesGeojsonData <- function(data) UseMethod("normalisesGeojsonData")

#' @export
normalisesGeojsonData.sf <- function(data) {
	geo <- geojsonsf::sf_geojson( data, simplify = FALSE)
	attr(geo, 'class') <- 'json'
	return(geo)
}

#' @export
normalisesGeojsonData.character <- function(data) {
	attr(data, 'class') <- 'json'
	return(data)
}

#' @export
normalisesGeojsonData.default <- function(data) data ## allow it through?

