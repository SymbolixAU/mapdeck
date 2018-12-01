#' Clear Legend
#'
#' Clears the legend for a given layer_id
#'
#' @param map_id the id of the map you want to clear the legend from.
#' @param layer_id single value specifying an id for the layer. Use this value to
#' distinguish between shape layers of the same type. Layers with the same id are likely
#' to conflict and not plot correctly
#'
#' @export
clear_legend <- function( map_id, layer_id ) {
	invoke_method( map_id, "clear_legend", layer_id );
}
