
#' Add Legend
#'
#' Add a custom legend to the map
#'
#' @inheritParams add_scatterplot
#'
#' @examples
#'
#' \donttest{
#' sf <- spatialwidget::widget_melbourne
#' sf$my_colour <- ifelse( substr(sf$SA2_NAME, 1, 1) == "A", "#00FF00FF", "#FF0000FF")
#'
#' l1 <- legend_element(
#' 	variables = c("Begins with A", "Doesn't begin with A")
#' 	, colours = c("#00FF00FF", "#FF0000FF")
#' 	, colour_type = "fill"
#' 	, variable_type = "category"
#' )
#' js <- mapdeck_legend(l1)
#'
#' set_token(secret::get_secret("MAPBOX"))
#' mapdeck() %>%
#'   add_legend(legend = js, layer_id = "my_layer")
#'
#'
#'mapdeck() %>%
#'   add_legend(legend = js, layer_id = "my_layer") %>%
#'   clear_legend(layer_id = "my_layer")
#'
#' }
#'
#' @export
add_legend <- function(map, legend, layer_id) {

	legend_format <- "hex"

	invoke_method(
		map, "md_add_legend", map_type(map), layer_id, legend, legend_format
	)
}


#' Clear Legend
#'
#' Removes a legend from the map
#'
#' @inheritParams add_legend
#'
#' @examples
#' \donttest{
#'
#' sf <- spatialwidget::widget_melbourne
#' sf$my_colour <- ifelse( substr(sf$SA2_NAME, 1, 1) == "A", "#00FF00FF", "#FF0000FF")
#'
#' l1 <- legend_element(
#' 	variables = c("Begins with A", "Doesn't begin with A")
#' 	, colours = c("#00FF00FF", "#FF0000FF")
#' 	, colour_type = "fill"
#' 	, variable_type = "category"
#' )
#' js <- mapdeck_legend(l1)
#'
#' set_token(secret::get_secret("MAPBOX"))
#'
#' ## Add a legend
#' mapdeck() %>%
#'   add_legend(legend = js, layer_id = "my_layer")
#'
#' ## Calling `clear_legend` should immediately remove it
#' mapdeck() %>%
#'   add_legend(legend = js, layer_id = "my_layer") %>%
#'   clear_legend(layer_id = "my_layer")
#'
#' }
#'
#' @export
clear_legend <- function(map, layer_id) {

	invoke_method(
		map, "md_clear_legend", map_type(map), layer_id
	)
}
