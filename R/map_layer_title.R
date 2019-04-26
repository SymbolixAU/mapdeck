#' Add Title
#'
#' Adds a title to a map
#'
#' @inheritParams add_arc
#' @param title Either a single string for the title, or a list with a 'title' element,
#' and an optional 'css' element. See examples
#'
#' @examples
#' \donttest{
#'
#' mapdeck() %>%
#'   add_title(title = "first title", layer_id = "first") %>%
#'   add_title(title = list(
#'       title = "second title",
#'       css = "background-color: red;"),
#'     layer_id = "second") %>%
#'   add_title(title = list(
#'       title = "Another title",
#'       css = "background-color: transparent;"),
#'     layer_id = "third")
#'
#' }
#'
#' @export
add_title <- function(map, title, layer_id = NULL) {

	layer_id <- layerId( layer_id, layer = "title" )
	if(!inherits(title, "list")) title <- list(title = title)

	invoke_method(map, "add_title", map_type( map ), layer_id, jsonify::to_json( title, unbox = TRUE ) )
}


#' @rdname clear
#' @export
clear_title <- function(map, layer_id = NULL ) {
	layer_id <- layerId( layer_id, layer = "title")
	invoke_method(map, "clear_title", map_type( map ), layer_id)
}
