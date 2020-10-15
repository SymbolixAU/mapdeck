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
#' token <- "your_api_token"
#' mapdeck(token = token) %>%
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
