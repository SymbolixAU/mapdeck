
#' mapbox vector source
#'
#'
#' @export
add_vector_source <- function( map, js ) {

	invoke_mapbox_method(
		map, "add_mapbox_layer", js
	)
}
