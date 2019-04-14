#' mapdeck
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
#' @param style the style of the map (see \link{mapdeck_style})
#' @param pitch the pitch angle of the map
#' @param zoom zoom level of the map
#' @param bearing bearing of the map between 0 and 360
#' @param location unnamed vector of lon and lat coordinates (in that order)
#'
#' @export
mapdeck <- function(
	data = NULL,
	token = get_access_token( api = 'mapbox' ),
	width = NULL,
	height = NULL,
	padding = 0,
	style = 'mapbox://styles/mapbox/streets-v9',
	pitch = 0,
	zoom = 0,
	bearing = 0,
	location = c( 0, 0 )
	) {

  # forward options using x
  x = list(
    access_token = force( token )
    , style = force( style )
    , pitch = force( pitch )
    , zoom = force( zoom )
    , location = force( as.numeric( location ) )
    , bearing = force( bearing )
  )

  #dep <- mapdeck_dependencies()

  # create widget
  mapdeckmap <- htmlwidgets::createWidget(
    name = 'mapdeck',
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
    )
    #, dependencies = dep
  )

  mapdeckmap <- mapdeck_dependencies( mapdeckmap )
  mapdeckmap$dependencies <- c( mapdeckmap$dependencies, mapboxgl())

  return(mapdeckmap)
}

#' Mapdeck Dependencies
#'
#' Javascript dependencies for mapdeck and deck.gl, useful for when not using
#' a Mapbox map
#'
#' @examples
#' mapdeck_dependencies()
#' \dontrun{
#'
#' ## use with a google map from googleway
#' library(googleway)
#'
#' set_key("GOOGLE_MAP_KEY")
#'
#' google_map() %>%
#' 	mapdeck_dependencies() %>%
#' 	add_scatterplot(
#' 		data = capitals
#' 		, lon = "lon"
#' 		, lat = "lat"
#' 		, fill_colour = "country"
#' 		, radius = 10000
#' 	)
#'
#' }
#'
#'
#'
#' @export
mapdeck_dependencies <- function( map ) {
	deps <- c(
		mapdeck_functions()
		, deckgl_min_js()
	)

	map$dependencies <- c( map$dependencies, deps )
	return( map )
}

mapdeck_functions <- function() {
	list(
		createHtmlDependency(
			name = "mpadeck_functions",
			version = "7.0.0",
			src = system.file("htmlwidgets/", package = "mapdeck"),
			script = c("mapdeck_functions.js")
		)
	)
}

deckgl_min_js <- function() {
	list(
		createHtmlDependency(
			name = "deckgl",
			version = "7.0.0",
			src = system.file("htmlwidgets/lib/", package = "mapdeck"),
			script = c("deckgl.min.js")
		)
	)
}

mapboxgl <- function() {
	list(
		createHtmlDependency(
			name = "mapboxgl",
			version = "0.52.0",
			src = system.file("htmlwidgets/lib/", package = "mapdeck"),
			script = c("mapbox-gl.js"),
			stylesheet = c("mapbox-gl.css")
		)
	)
}

#' Shiny bindings for mapdeck
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
#' @name mapdeck-shiny
#'
#' @export
mapdeckOutput <- function(outputId, width = '100%', height = '400px'){
	#htmlwidgets::shinyWidgetOutput(outputId, 'mapdeck', width, height, package = 'mapdeck')
  shinyWidgetOutput2(outputId, 'mapdeck', width, height, package = 'mapdeck')
}


shinyWidgetOutput2 <- function (outputId, name, width, height, package = name, inline = FALSE,
					reportSize = FALSE){
	# checkShinyVersion()
	html <- htmltools::tagList(
		widget_html2(
			name
			, package
			, id = outputId
			, class = paste0(
				name
				, " html-widget html-widget-output"
				, if (reportSize) " shiny-report-size"
				)
			, style = sprintf(
				"width:%s; height:%s; %s"
				, htmltools::validateCssUnit(width)
				, htmltools::validateCssUnit(height)
				, if (inline) "display: inline-block;" else ""
				)
			, width = width
			, height = height
			)
		)

	dependencies = htmlwidgets:::getDependency(name, package)
	dependencies <- c(dependencies, deckgl_min_js(), mapdeck_functions(), mapboxgl() )
	htmltools::attachDependencies(html, dependencies)
}

widget_html2 <- function (name, package, id, style, class, inline = FALSE, ...)
{
	fn <- tryCatch(get(paste0(name, "_html"), asNamespace(package),
										 inherits = FALSE), error = function(e) NULL)
	if (is.function(fn)) {
		fn(id = id, style = style, class = class, ...)
	}
	else if (inline) {
		tags$span(id = id, style = style, class = class)
	}
	else {
		tags$div(id = id, style = style, class = class)
	}
}

#' @rdname mapdeck-shiny
#' @export
renderMapdeck <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, mapdeckOutput, env, quoted = TRUE)
}


#' Mapdeck update
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


#' Mapdeck view
#'
#' Changes the view of the of the map
#'
#' @inheritParams mapdeck
#' @param map a \code{mapdeck} map object
#' @param duration time in milliseconds of the transition
#' @param transition type of transition
#' @export
mapdeck_view <- function(
	map,
	location = NULL,
	zoom = NULL,
	pitch = NULL,
	bearing = NULL,
	duration = NULL,
	transition = c("linear", "fly")
	) {

	transition <- match.arg(transition)
	invoke_method(
		map, 'md_change_location', as.numeric( location ), zoom, pitch,
		bearing, duration, transition
		)
}

# Get Map Data
#
# extracts the data attribute from the map
#
# @param map a mapdeck map object
#
get_map_data = function( map ) {
	attr( map$x, "mapdeck_data", exact = TRUE )
}
