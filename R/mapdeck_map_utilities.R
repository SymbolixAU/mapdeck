#' mapdeck dispatch
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
mapdeck_dispatch = function(
  map,
  funcName,
  mapdeck = stop(paste(funcName, "requires a map update object")),
  mapdeck_update = stop(paste(funcName, "does not support map update objects"))
  ) {
  if (inherits(map, "mapdeck"))
    return(mapdeck)
  else if (inherits(map, "mapdeck_update"))
    return(mapdeck_update)
  else
    stop("Invalid map parameter")
}


#' @param method the name of the JavaScript method to invoke
#' @param ... unnamed arguments to be passed to the JavaScript method
#' @rdname mapdeck_dispatch
#' @export
invoke_method = function(map, method, ...) {
	args = evalFormula(list(...))
	mapdeck_dispatch(
		map,
		method,
		mapdeck = {
			x = map$x$calls
			if (is.null(x)) x = list()
			n = length(x)
			x[[n + 1]] = list(functions = method, args = args)
			map$x$calls = x
			map
		},
		mapdeck_update = {
			invoke_remote(map, method, args)
		}
	)
}


invoke_remote = function(map, method, args = list()) {
  if (!inherits(map, "mapdeck_update"))
    stop("Invalid map parameter; mapdeck_update object was expected")

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
      sess$sendCustomMessage("mapdeckmap-calls", msg)
    }, once = TRUE)

  } else {
    sess$sendCustomMessage("mapdeckmap-calls", msg)
  }
  map
}


# Evaluate list members that are formulae, using the map data as the environment
# (if provided, otherwise the formula environment)
evalFormula = function(list, data) {
	evalAll = function(x) {
		if (is.list(x)) {
			structure(lapply(x, evalAll), class = class(x))
		} else resolveFormula(x, data)
	}
	evalAll(list)
}

resolveFormula = function(f, data) {
	if (!inherits(f, 'formula')) return(f)
	if (length(f) != 2L) stop("Unexpected two-sided formula: ", deparse(f))

	doResolveFormula(data, f)
}

doResolveFormula = function(data, f) {
	UseMethod("doResolveFormula")
}


doResolveFormula.data.frame = function(data, f) {
	eval(f[[2]], data, environment(f))
}


createHtmlDependency <- function(name, version, src, script) {
	structure(
		list(
			name = name
			, version = version
			, src = list( file = src )
			, meta = NULL
			, script = script
			, stylesheet = NULL
			, head = NULL
			, attachment = NULL
			, package = NULL
			, all_files = TRUE
		)
		, class = "html_dependency"
	)
}

## from htmlwidgets::createWidget
localCreateWidget <- function (name, x, width = NULL, height = NULL, sizingPolicy = localSizingPolicy(),
					package = name, dependencies = NULL, elementId = NULL, preRenderHook = NULL)
{
	if (inherits(dependencies, "html_dependency"))
		dependencies <- list(dependencies)
	structure(list(x = x, width = width, height = height, sizingPolicy = sizingPolicy,
								 dependencies = dependencies, elementId = elementId, preRenderHook = preRenderHook,
								 jsHooks = list()), class = c(name, if (sizingPolicy$viewer$suppress) "suppress_viewer",
								 														 "htmlwidget"), package = package)
}

## from htmlwidgets::sizingPolicy
localSizingPolicy <- function (defaultWidth = NULL, defaultHeight = NULL, padding = NULL,
															 viewer.defaultWidth = NULL, viewer.defaultHeight = NULL,
															 viewer.padding = NULL, viewer.fill = TRUE, viewer.suppress = FALSE,
															 viewer.paneHeight = NULL, browser.defaultWidth = NULL, browser.defaultHeight = NULL,
															 browser.padding = NULL, browser.fill = FALSE, browser.external = FALSE,
															 knitr.defaultWidth = NULL, knitr.defaultHeight = NULL, knitr.figure = TRUE)
{
	list(defaultWidth = defaultWidth, defaultHeight = defaultHeight,
			 padding = padding, viewer = list(defaultWidth = viewer.defaultWidth,
			 																 defaultHeight = viewer.defaultHeight, padding = viewer.padding,
			 																 fill = viewer.fill, suppress = viewer.suppress, paneHeight = viewer.paneHeight),
			 browser = list(defaultWidth = browser.defaultWidth, defaultHeight = browser.defaultHeight,
			 							 padding = browser.padding, fill = browser.fill, external = browser.external),
			 knitr = list(defaultWidth = knitr.defaultWidth, defaultHeight = knitr.defaultHeight,
			 						 figure = knitr.figure))
}

addDependency <- function(map, dependencyFunction) {

	existingDeps <- sapply(map$dependencies, function(x) x[['name']])
	addingDependency <- sapply(dependencyFunction, function(x) x[['name']])

	if(!addingDependency %in% existingDeps)
		map$dependencies <- c(map$dependencies, dependencyFunction)

	return(map)
}

# Layer Id
#
# Checks the layer_id parameter, and provides a default one if NULL
# @param layer_id
layerId <- function(layer_id, layer = c("arc", "geojson","grid","hexagon","line","path","pointcloud",
																				"polygon","scatterplot", "screengrid","text")){
	layer <- match.arg( layer )
	if (!is.null(layer_id) & length(layer_id) != 1)
		stop("please provide a single value for 'layer_id'")

	if (is.null(layer_id)) {
		return(paste0(layer, "-defaultLayerId"))
	} else {
		return(layer_id)
	}
}

