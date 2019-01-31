#' Add Title
#'
#' Adds a title to a map
#'
#' @inheritParams add_arc
#' @param title
#'
#' @export
add_title <- function(map, title, layer_id = NULL) {

	layer_id <- layerId( layer_id, layer = "title" )
	if(!inherits(title, "list")) title <- list(title = title)

	invoke_method(map, "add_title", layer_id, jsonify::to_json( title, unbox = TRUE ) )
}

## TODO( update title )
