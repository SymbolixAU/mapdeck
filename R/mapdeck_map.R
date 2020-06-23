#' mapdeck
#'
#' @import htmlwidgets
#'
#' @param token Mapbox Acess token. Use \code{set_token()} or \code{Sys.setenv()} to set a global token.
#' See Access Tokens section for further details.
#' If left empty layers will still be plotted, but without a Mapbox map.
#' @param data data to be used in the layer. All coordinates are expected to be
#' EPSG:4326 (WGS 84) coordinate system
#' @param width the width of the map
#' @param height the height of the map
#' @param padding the padding of the map
#' @param style the style of the map (see \link{mapdeck_style})
#' @param pitch the pitch angle of the map
#' @param zoom zoom level of the map
#' @param bearing bearing of the map between 0 and 360
#' @param max_zoom sets the maximum zoom level
#' @param min_zoom sets the minimum zoom level
#' @param max_pitch sets the maximum pitch
#' @param min_pitch sets the minimum pitch
#' @param location unnamed vector of lon and lat coordinates (in that order)
#' @param show_view_state logical, indicating whether to add the current View State to the map.
#' When \code{TRUE}, the following is added as an overlay to the map
#' \itemize{
#'   \item{width}
#'   \item{height}
#'   \item{latitude & longitude}
#'   \item{zoom}
#'   \item{bearing}
#'   \item{pitch}
#'   \item{altitude}
#'   \item{viewBounds}
#'   \item{interactionState}
#' }
#'
#' @param repeat_view Logical indicating if the layers should repeat at low zoom levels
#'
#' @section Access Tokens:
#'
#' If the \code{token} argument is not used, the map will search for the token, firstly by
#' checking if \code{set_token()} was used, then it will search environment variables using
#' \code{Sys.getenv()} and the following values, in this order
#'
#' c("MAPBOX_TOKEN","MAPBOX_KEY","MAPBOX_API_TOKEN", "MAPBOX_API_KEY", "MAPBOX", "MAPDECK")
#'
#' If multiple tokens are found, the first one is used
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
	max_zoom = 20,
	min_zoom = 0,
	max_pitch = 60,
	min_pitch = 0,
	location = c(0, 0),
	show_view_state = FALSE,
	repeat_view = FALSE
	) {

  # forward options using x
  x = list(
    access_token = force( token )
    , style = force( style )
    , pitch = force( pitch )
    , zoom = force( zoom )
    , location = force( as.numeric( location ) )
    , bearing = force( bearing )
    , max_zoom = force( max_zoom )
    , min_zoom = force( min_zoom )
    , max_pitch = force( max_pitch )
    , min_pitch = force( min_pitch )
    , show_view_state = force( show_view_state )
    , repeat_view = force( repeat_view )
  )

  # deps <- list(
  # 	createHtmlDependency(
  # 		name = "map",
  # 		version = "1.0.0",
  # 		src = system.file("htmlwidgets/lib/map", package = "mapdeck"),
  # 		script = c("legend.js", "title.js", "location.js", "coordinates.js", "colours.js")
  # 	)
  # )

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
    #dependencies = deps,
    sizingPolicy = htmlwidgets::sizingPolicy(
    	defaultWidth = '100%',
    	defaultHeight = 800,
    	padding = padding,
    	browser.fill = FALSE
    )
  )

  mapdeckmap <- add_dependencies( mapdeckmap )
  mapdeckmap$dependencies <- c(
  	mapdeckmap$dependencies
  	, mapboxgl()
  	, mapdeck_css()
  	, mapdeck_js()
  	, htmlwidgets_js()
  	#, mapdeckViewStateDependency()
  	)

  return(mapdeckmap)
}


#' update style
#'
#' @param map a mapdeck map object
#' @param style the style of the map (see \link{mapdeck_style})
#'
#' @export
update_style <- function( map, style ) {
	invoke_method(
		map, "md_update_style", style
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
	htmlwidgets::shinyWidgetOutput(outputId, 'mapdeck', width, height, package = 'mapdeck')
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
#' @param data data to be used in the layer. All coordinates are expected to be
#' EPSG:4326 (WGS 84) coordinate system
#' @param deferUntilFlush indicates whether actions performed against this
#' instance should be carried out right away, or whether they should be held until
#' after the next time all of the outputs are updated; defaults to TRUE.
#' @param map_type either mapdeck_update or google_map_update
#' @export
mapdeck_update <- function(
	data = NULL,
	map_id,
	session = shiny::getDefaultReactiveDomain(),
	deferUntilFlush = TRUE,
	map_type = c("mapdeck_update", "google_map_update")
	) {

	map_type <- match.arg( map_type )

	if (is.null(session)) {
		stop("mapdeck - mapdeck_update must be called from the server function of a Shiny app")
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
		class = c(map_type)
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
		map, 'md_change_location', map_type( map ) , as.numeric( location ), zoom, pitch,
		bearing, duration, transition
		)
}

# Get Map Data
#
# extracts the data attribute from the map
#
# @param map a mapdeck map object
#
get_map_data <- function( map ) {
	attr( map$x, "mapdeck_data", exact = TRUE )
}

# map_type
#
# determines the source/type of map
map_type <- function( map ) {

	map_type <- attr( map, "class")
	if( any( c("mapdeck", "mapdeck_update") %in% map_type ) ) return( "mapdeck" )

	if( any( c("google_map", "google_map_update") %in% map_type ) ) return( "google_map" )

	return(NULL)
}
