#' mapbox dispatch
#'
#' Extension points for plugins
#'
#' @param map a map object, as returned from \code{\link{mapdeck}}
#' @param funcName the name of the function that the user called that caused
#'   this \code{mapdeck_dispatch} call; for error message purposes
#' @param mapdeck an action to be performed if the map is from
#'   \code{\link{mapdeck}}
#' @param mapdeck_update an action to be performed if the map is from
#'   \code{\link{mapdeck_update}}
#'
#' @return \code{mapdeck_dispatch} returns the value of \code{mapdeck} or
#' or an error. \code{invokeMethod} returns the
#' \code{map} object that was passed in, possibly modified.
#'
#' @export
mapbox_dispatch = function(
	map,
	funcName,
	mapbox = stop(paste(funcName, "requires a map update object")),
	mapbox_update = stop(paste(funcName, "does not support map update objects"))
) {
	if (inherits(map, "mapbox"))
		return(mapbox)
	else if (inherits(map, "mapbox_update"))
		return(mapbox_update)
	else
		stop("Invalid map parameter")
}

#' @param method the name of the JavaScript method to invoke
#' @param ... unnamed arguments to be passed to the JavaScript method
#' @rdname mapdeck_dispatch
#' @export
invoke_mapbox_method <- function(map, method, ...) {
	args = evalFormula(list(...))
	mapbox_dispatch(
		map,
		method,
		mapbox = {
			x = map$x$calls
			if (is.null(x)) x = list()
			n = length(x)
			x[[n + 1]] = list(functions = method, args = args)
			map$x$calls = x
			map
		},
		mapbox_update = {
			invoke_mapbox_remote(map, method, args)
		}
	)
}


invoke_mapbox_remote = function(map, method, args = list()) {
	if (!inherits(map, "mapbox_update"))
		stop("Invalid map parameter; mapbox_update object was expected")

	msg <- list(
		id = map$id,
		calls = list(
			list(
				dependencies = lapply(map$dependencies, shiny::createWebDependency),
				method = method,
				args = args
			)
		)
	)

	sess <- map$session
	if (map$deferUntilFlush) {

		sess$onFlushed(function() {
			sess$sendCustomMessage("mapboxmap-calls", msg)
		}, once = TRUE)

	} else {
		sess$sendCustomMessage("mapboxmap-calls", msg)
	}
	map
}
