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
	invoke_method( map_id, "md_clear_legend", layer_id );
}



#' Mapdeck Legend
#'
#' @param colours vector of hex colours
#' @param variables
#' @param colour_type one of "fill" or "stroke"
#' @param variable_type one of category (discrete) or gradient (continuous)
#' @param title string used as the legend title
#' @param css
#'
#' @export
mapdeck_legend <- function(
	colours,
	variables,
	colour_type = c("fill", "stroke"),
	variable_type = c("category", "gradient"),
	title = "",
	css = ""
	) {

	if( length( colours ) != length( variables ) ) {
		stop("colours and variables should be the same length")
	}

	## TODO
	## Use this function to create a 'mapdeck_legend' object
	## which will be json legend
	l <- list(
		colour = colours
		, variable = variables
		, colourType = legend_colour_type( colour_type )
		, type = variable_type
		, title = title
		, css = css
	)

	l <- list(
		fill_colour = l
	)

	jsonify::to_json( l )
}


legend_colour_type <- function( colour_type ) {
	switch(
		colour_type
		, "fill" = "fill_colour"
		, "stroke" = "stroke_colour"
	)
}
