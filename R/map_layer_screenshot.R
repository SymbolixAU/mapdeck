#' Add Screenshot
#'
#' Adds a screenshot button to a map
#'
#'
#' @examples
#' \donttest{
#'
#' mapdeck()
#'
#' }
#'
#' @export
add_screenshot <- function( map ) {

	if(!inherits(title, "list")) title <- list(title = title)

	invoke_method(map, "add_screenshot", map_type( map ) )
}
