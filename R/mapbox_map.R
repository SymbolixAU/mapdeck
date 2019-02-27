#' mapbox
#'
#' @import htmlwidgets
#'
#' @param token Mapbox Acess token. Use \code{set_token()} to set a global token.
#' If left empty layers will still be plotted, but without a Mapbox map.
#' @param data data to be used on the map. All coordinates are expected to be in
#' Web Mercator Projection
#' @param width the width of the map
#' @param height the height of the map
#' @param padding the padding of the map
#' @param style the style of the map
#' @param pitch the pitch angle of the map
#' @param zoom zoom level of the map
#' @param bearing bearing of the map between 0 and 360
#' @param location unnamed vector of lon and lat coordinates (in that order)
#'
#' @export
mapbox <- function(
	data = NULL,
	token = get_access_token( api = 'mapbox' ),
	width = NULL,
	height = NULL,
	padding = 0,
	style = 'mapbox://styles/mapbox/streets-v9',
	# pitch = 0,
	zoom = 0,
	# bearing = 0,
	location = c( 0, 0 )
) {

	# forward options using x
	x = list(
		access_token = force( token )
		, style = force( style )
		#, pitch = force( pitch )
		, zoom = force( zoom )
		, location = force( as.numeric( location ) )
		#, bearing = force( bearing )
	)

	# create widget
	mapboxmap <- htmlwidgets::createWidget(
		name = 'mapbox',
		x = structure(
			x,
			mapdeck_data = data
		),
		width = width,
		height = height,
		package = 'mapdeck',
		sizingPolicy = htmlwidgets::sizingPolicy(
			defaultWidth = '100%',
			defaultHeight = 800,
			padding = padding,
			browser.fill = FALSE
		),
		dependencies = mapboxDependency()
	)
	return(mapboxmap)
}

mapboxDependency <- function() {
	list(
		createHtmlDependency(
			name = "mapboxgl",
			version = "0.52.0",
			src = system.file("htmlwidgets/lib", package = "mapdeck"),
			script = c("mapbox-gl.js"),
			stylesheet = "mapbox-gl.css"
		)
	)
}


#' Shiny bindings for mapbox
#'
#' Output and render functions for using mapbox within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a mapbox
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name mapdeck-shiny
#'
#' @export
mapboxOutput <- function(outputId, width = '100%', height = '400px'){
	htmlwidgets::shinyWidgetOutput(outputId, 'mapbox', width, height, package = 'mapdeck')
}

#' @rdname mapdeck-shiny
#' @export
renderMapbox <- function(expr, env = parent.frame(), quoted = FALSE) {
	if (!quoted) { expr <- substitute(expr) } # force quoted
	htmlwidgets::shinyRenderWidget(expr, mapboxOutput, env, quoted = TRUE)
}


#' mapbox update
#'
#' Update a Mapdeck map in a shiny app. Use this function whenever the map needs
#' to respond to reactive content.
#'
#' @param map_id string containing the output ID of the map in a shiny application.
#' @param session the Shiny session object to which the map belongs; usually the
#' default value will suffice.
#' @param data data to be used in the map. All coordinates are expected to be in
#' Web Mercator Projection
#' @param deferUntilFlush indicates whether actions performed against this
#' instance should be carried out right away, or whether they should be held until
#' after the next time all of the outputs are updated; defaults to TRUE.
#' @export
mapbox_update <- function(
	map_id,
	session = shiny::getDefaultReactiveDomain(),
	data = NULL,
	deferUntilFlush = TRUE
) {

	if (is.null(session)) {
		stop("mapbox_update must be called from the server function of a Shiny app")
	}

	structure(
		list(
			session = session,
			id = map_id,
			x = structure(
				list(),
				mapbox_data = data
			),
			deferUntilFlush = deferUntilFlush,
			dependencies = NULL
		),
		class = "mapbox_update"
	)
}
