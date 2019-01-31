#' Add Title
#'
#'
#' @export
add_title <- function(map, title, layer_id = NULL) {

	layer_id <- layerId( layer_id )

	# title <- list(
	# 	title = "my title"
	# 	#, position = "TOP_RIGHT"
	# 	#, css = "background: #00FF00;"
	# )

	invoke_method(map, "add_title", layer_id, jsonify::to_json( title, unbox = TRUE ) )
}

## TODO( update title )
