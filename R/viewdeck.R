#' viewdeck
#'
#' @import htmlwidgets
#'
#' @export
viewdeck <- function(
	padding = 0
) {

	# forward options using x
	x = list()

	# create widget
	viewdeckplot <- htmlwidgets::createWidget(
		name = 'viewdeck',
		x = structure(
			x,
			viewdeck_data = data
		),
		package = 'mapdeck',
		sizingPolicy = htmlwidgets::sizingPolicy(
			defaultWidth = '100%',
			defaultHeight = 800,
			padding = padding,
			browser.fill = FALSE
		)
	)
	return(viewdeckplot)
}

#' Shiny bindings for viewdeck
#'
#' Output and render functions for using mapdeck within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a mapdeck
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name viewdeck-shiny
#'
#' @export
viewdeckOutput <- function(outputId, width = '100%', height = '400px'){
	htmlwidgets::shinyWidgetOutput(outputId, 'viewdeck', width, height, package = 'viewdeck')
}

#' @rdname viewdeck-shiny
#' @export
renderViewDeck <- function(expr, env = parent.frame(), quoted = FALSE) {
	if (!quoted) { expr <- substitute(expr) } # force quoted
	htmlwidgets::shinyRenderWidget(expr, viewdeckOutput, env, quoted = TRUE)
}


