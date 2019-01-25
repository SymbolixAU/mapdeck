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


#' viewdeck dispatch
#'
#' Extension points for plugins
#'
#' @param view a viewdeck object, as returned from \code{\link{viewdeck}}
#' @param funcName the name of the function that the user called that caused
#'   this \code{viewdeck_dispatch} call; for error message purposes
#' @param viewdeck an action to be performed if the map is from
#'   \code{\link{viewdeck}}
#' @param mapdeck_update an action to be performed if the map is from
#'   \code{\link{viewdeck_update}}
#'
#' @return \code{mapdeck_dispatch} returns the value of \code{viewdeck} or
#' or an error. \code{invokeMethod} returns the
#' \code{map} object that was passed in, possibly modified.
#'
#' @export
viewdeck_dispatch = function(
	view,
	funcName,
	viewdeck = stop(paste(funcName, "requires a view update object")),
	viewdeck_update = stop(paste(funcName, "does not support view update objects"))
) {
	if (inherits(view, "viewdeck"))
		return(viewdeck)
	else if (inherits(view, "mapdeck_update"))
		return(viewdeck_update)
	else
		stop("Invalid viewdeck parameter")
}


#' @param method the name of the JavaScript method to invoke
#' @param ... unnamed arguments to be passed to the JavaScript method
#' @rdname viewdeck_dispatch
#' @export
invoke_viewdeck_method = function(view, method, ...) {
	args = evalFormula(list(...))
	viewdeck_dispatch(
		view,
		method,
		viewdeck = {
			x = view$x$calls
			if (is.null(x)) x = list()
			n = length(x)
			x[[n + 1]] = list(functions = method, args = args)
			view$x$calls = x
			view
		},
		viewdeck_update = {
			invoke_remote(view, method, args)
		}
	)
}


invoke_viewdeck_remote = function(view, method, args = list()) {
	if (!inherits(view, "mapdeck_update"))
		stop("Invalid view parameter; mapdeck_update object was expected")

	msg <- list(
		id = view$id,
		calls = list(
			list(
				dependencies = lapply(view$dependencies, shiny::createWebDependency),
				method = method,
				args = args
			)
		)
	)

	sess <- view$session
	if (view$deferUntilFlush) {

		sess$onFlushed(function() {
			sess$sendCustomMessage("viewdeckview-calls", msg)
		}, once = TRUE)

	} else {
		sess$sendCustomMessage("viewdeckview-calls", msg)
	}
	view
}

