

lonZoomLevel <- function() {
	c(360, 180, 90, 45, 22.5, 11.25, 5.65,2.813, 1.406,0.703, 0.352, 0.176, 0.088, 0.044, 0.022, 0.011, 0.005)
}

latZoomLevel <- function() {
	c(90, 45, 22.5, 11.25, 5.65,2.813, 1.406, 0.703, 0.352, 0.176, 0.088, 0.044, 0.022, 0.011, 0.005, 0.0025, 0.000175)
}

get_zoom <- function(obj) UseMethod("get_zoom")

#' @export
get_zoom.sf <- function(obj) {
	l <- list(geometry = attr(obj, "sf_column") )
	bbox <- get_box( obj, l )
	lonDiff <- abs( bbox[[2]][1] - bbox[[1]][1] )
	latDiff <- abs( bbox[[2]][2] - bbox[[1]][2] )

	pmin(
		max(which(lonZoomLevel() > lonDiff))
		, max(which(latZoomLevel() > latDiff))
	)
}

#' @export
get_zoom.default <- function(obj) stop("can not calculate zoom level")


get_location <- function(obj) UseMethod("get_location")

#' @export
get_location.sf <- function(obj) {
	l <- list(geometry = attr(obj, "sf_column") )
	bbox <- get_box( obj, l )
	c(
		mean(bbox[[1]][1], bbox[[2]][1])
		, mean(bbox[[1]][2], bbox[[2]][2])
	)
}
