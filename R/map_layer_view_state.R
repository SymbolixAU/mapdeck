mapdeckViewStateDependency <- function() {
	list(
		createHtmlDependency(
			name = "view_state",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/view_state", package = "mapdeck"),
			script = c("view_state.js"),
			all_files = FALSE
		)
	)
}


#' Add View State
#'
#' Adds the current View State to a map. The view state consists of
#' \itemize{
#'   \item{width}
#'   \item{height}
#'   \item{latitude & longitude}
#'   \item{zoom}
#'   \item{bearing}
#'   \item{pitch}
#'   \item{altitude}
#'   \item{viewBounds}
#'   \item{interactionState}
#' }
#'
#'
#' @inheritParams add_arc
#'
#' @examples
#' \donttest{
#'
#' mapdeck() %>%
#'   add_view_state()
#' }
#'
#' @export
add_view_state <- function(map, layer_id = NULL) {

	layer_id <- layerId( layer_id, layer = "view_state" )

	map <- addDependency(map, mapdeckViewStateDependency())

	invoke_method(map, "add_view_state", map_type( map ), layer_id )
}


#' @rdname clear
#' @export
clear_view_state <- function(map, layer_id = NULL ) {
	layer_id <- layerId( layer_id, layer = "view_state")
	invoke_method(map, "clear_view_state", map_type( map ), layer_id)
}
