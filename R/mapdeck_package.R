#' Pipe
#'
#' Uses the pipe operator (\code{\%>\%}) to chain statements. Useful for adding
#' layers to a \code{google_map}
#'
#' @importFrom magrittr %>%
#' @name %>%
#' @rdname pipe
#' @export
#' @param lhs,rhs A google map and a layer to add to it
#' @examples
#' \dontrun{
#'
#' key <- "your_api_key"
#' mapdeck_map(key = key) %>%
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
