#' Mapdeck map update
#'
#' Update a mapdeck map in a shiny app. Use this function whenever the map needs
#' to respond to reactive content.
#'
#' @param map_id string containing the output ID of the map in a shiny application.
#' @param session the Shiny session object to which the map belongs; usually the
#' default value will suffice.
#' @param data data to be used in the map. See the details section for \code{\link{mapdeck_map}}.
#' @param deferUntilFlush indicates whether actions performed against this
#' instance should be carried out right away, or whether they should be held until
#' after the next time all of the outputs are updated; defaults to TRUE.
#' @examples
#' \dontrun{
#'
#' library(shiny)
#' library(mapdeck)
#'
#' ui <- pageWithSidebar(
#'   headerPanel("Toggle markers"),
#'   sidebarPanel(
#'     actionButton(inputId = "markers", label = "toggle markers")
#'   ),
#'   mainPanel(
#'     mapdeck_Output("map")
#'   )
#' )
#'
#' server <- function(input, output, session){
#'
#'   # api_key <- "your_api_key"
#'
#'   df <- structure(list(lat = c(-37.8201904296875, -37.8197288513184,
#'   -37.8191299438477, -37.8187675476074, -37.8186187744141, -37.8181076049805
#'   ), lon = c(144.968612670898, 144.968414306641, 144.968139648438,
#'  144.967971801758, 144.967864990234, 144.967636108398), weight = c(31.5698964400217,
#'  97.1629025738221, 58.9051092562731, 76.3215389118996, 37.8982300488278,
#'  77.1501972114202), opacity = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)), .Names = c("lat",
#'  "lon", "weight", "opacity"), row.names = 379:384, class = "data.frame")
#'
#'
#'   output$map <- renderMapdeck_map({
#'     mapdeck_map(key = api_key)
#'   })
#'
#'   observeEvent(input$markers,{
#'
#'     if(input$markers %% 2 == 1){
#'       mapdeck_map_update(map_id = "map") %>%
#'         add_markers(data = df)
#'     }else{
#'       mapdeck_map_update(map_id = "map") %>%
#'         clear_markers()
#'     }
#'   })
#'  }
#' shinyApp(ui, server)
#' }
#' @export
mapdeck_update <- function(
	map_id,
	session = shiny::getDefaultReactiveDomain(),
	data = NULL,
	deferUntilFlush = TRUE
	) {

	if (is.null(session)) {
		stop("mapdeck_update must be called from the server function of a Shiny app")
	}

	structure(
		list(
			session = session,
			id = map_id,
			x = structure(
				list(),
				mapdeck_data = data
			),
			deferUntilFlush = deferUntilFlush,
			dependencies = NULL
		),
		class = "mapdeck_update"
	)
}


#' mapdeck dispatch
#'
#' Extension points for plugins
#'
#' @param map a map object, as returned from \code{\link{mapdeck_map}}
#' @param funcName the name of the function that the user called that caused
#'   this \code{mapdeck_dispatch} call; for error message purposes
#' @param mapdeck_map an action to be performed if the map is from
#'   \code{\link{mapdeck_map}}
#' @param mapdeck_map_update an action to be performed if the map is from
#'   \code{\link{mapdeck_map_update}}
#'
#' @return \code{mapdeck_dispatch} returns the value of \code{mapdeck_map} or
#' or an error. \code{invokeMethod} returns the
#' \code{map} object that was passed in, possibly modified.
#'
#' @export
mapdeck_dispatch = function(
	map,
	funcName,
	mapdeck = stop(paste(funcName, "requires a map update object")),
	mapdeck_update = stop(paste(funcName, "does not support map udpate objects"))
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

	mapdeck_dispatch(map,
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


addDependency <- function(map, dependencyFunction) {

	existingDeps <- sapply(map$dependencies, function(x) x[['name']])
	addingDependency <- sapply(dependencyFunction, function(x) x[['name']])

	if(!addingDependency %in% existingDeps)
		map$dependencies <- c(map$dependencies, dependencyFunction)

	return(map)
}

