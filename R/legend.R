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
#' Constructs legend elements into the correct JSON format for plotting on the map
#'
#' @param legend_elements vector of legend elements (made from \link{legend_element})
#'
#' @examples
#' l1 <- legend_element(
#' 	variables = c("a","b")
#' 	, colours = c("#00FF00","#FF0000")
#' 	, colour_type = "fill"
#' 	, variable_type = "category"
#' 	, title = "my title"
#' )
#'
#' mapdeck_legend(l1)
#'
#' @seealso \link{legend_element}
#'
#' @export
mapdeck_legend <- function(legend_elements) UseMethod("mapdeck_legend")

#' @export
mapdeck_legend.mapdeck_legend <- function( legend_elements ) jsonify::to_json(legend_elements)

#' @export
mapdeck_legend.default <- function( legend_elements ) {
	stop("mapdeck - mapdeck_legend will only work on objects created with legend_element")
}

#' Legend Element
#'
#' Creates a mapdeck legend element for when you want to manually specify a legend (using \link{mapdeck_legend})
#'
#' @param variables variables assigned to colours
#' @param colours vector of hex colours assigned to variables
#' @param colour_type one of "fill" or "stroke"
#' @param variable_type one of category (discrete) or gradient (continuous)
#' @param title string used as the legend title
#' @param css string of css to control appearance.
#'
#' @seealso \link{mapdeck_legend}
#'
#' @examples
#'
#' l1 <- legend_element(
#' 	variables = c("a","b")
#' 	, colours = c("#00FF00","#FF0000")
#' 	, colour_type = "fill"
#' 	, variable_type = "category"
#' 	, title = "my title"
#' )
#'
#' @export
legend_element <- function(
	variables,
	colours,
	colour_type = c("fill", "stroke"),
	variable_type = c("category", "gradient"),
	title = "",
	css = ""
	) {

	if( length( colours ) != length( variables ) ) {
		stop("mapdeck - colours and variables should be the same length")
	}

	colour_type <- legend_colour_type( colour_type )

	l <- list(
		colour = colours
		, variable = variables
		, colourType = colour_type
		, type = variable_type
		, title = title
		, css = css
	)

	l <- list( l )
	names(l) <- colour_type
	attr(l, "class") <- c("mapdeck_legend", attr(l, "class"))
	return(l)
}


legend_colour_type <- function( colour_type ) {
	switch(
		colour_type
		, "fill" = "fill_colour"
		, "stroke" = "stroke_colour"
	)
}

aggregation_legend <- function( legend, legend_options ) {

	if( is.null( legend_options ) ) {
		legend_options <- list(
			css = ""
			, title = "value"
			, digits = 2
		)
	}
	if( is.null( legend_options[["css"]] ) ) {
		legend_options[["css"]] <- ""
	}

	if( is.null( legend_options[["title"]] ) ) {
		legend_options[["title"]] <- "value"
	}

	if( is.null( legend_options[["digits"]] ) ) {
		legend_options[["digits"]] <- 2
	}

	legend <- list(
		legend = legend
		, css = legend_options[["css"]]
		, title = legend_options[["title"]]
		, digits = legend_options[["digits"]]
	)

	return( legend )
}


