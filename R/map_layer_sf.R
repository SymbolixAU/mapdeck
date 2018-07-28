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


normaliseSfData <- function(data, geom) UseMethod("normaliseSfData")

#' @export
normaliseSfData.sf <- function(data, geom) {
	enc <- googlePolylines::encode(data)
	data <- normaliseSfData(enc, geom)
	return(data)
}

#' @export
normaliseSfData.sfencoded <- function(data, geom) {
	idx <- googlePolylines::geometryRow(data, geom)
	return(data[idx, names(data), drop = F])
}

#' @export
normaliseSfData.default <- function(data, geom) data



normalise_sf <- function(sf) UseMethod("normalise_sf")

#' @export
normalise_sf.sf <- function(sf) googlePolylines::encode(sf)

#' @export
normalise_sf.sfencoded <- function(sf) sf

#' @export
normalise_sf.default <- function(sf) stop("Expecting an sf or sfencoded object to add_sf")
