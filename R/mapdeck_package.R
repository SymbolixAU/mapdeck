#' @useDynLib mapdeck, .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL

#' Pipe
#'
#' Uses the pipe operator (\code{\%>\%}) to chain statements. Useful for adding
#' layers to a \code{mapdeck} map
#'
#' @importFrom magrittr %>%
#' @name %>%
#' @rdname pipe
#' @export
#' @param lhs,rhs A mapdeck map and a layer to add to it
#' @examples
#' \donttest{
#'
#' key <- "your_api_key"
#' mapdeck(key = key) %>%
#' add_scatterplot(
#'   data = capitals
#'   , lat = "lat"
#'   , lon = "lon"
#'   , radius = 100000
#'   , fill_colour = "country"
#'   , layer_id = "scatter_layer"
#' )
#' }
NULL

experimental_layer <- function(layer) {
	message(layer, " is an experimental layer and the function may change without warning")
}

# returns 0-based index of all the list columns in a data.frame (sf object)
list_columns <- function(x, geometry_col) {
	geom_col <- which(names(x) == geometry_col)
	return( setdiff( which( vapply(x, is.list, T) ), geom_col ) - 1 )
}

