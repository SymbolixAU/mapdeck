#' mapdeck Map
#'
#' @import htmlwidgets
#'
#' @export
mapdeck_map <- function(key,
											 data = NULL,
											 width = NULL,
											 height = NULL,
											 elementId = NULL,
											 padding = 0,
											 style = 'mapbox://styles/mapbox/streets-v9') {

  # forward options using x
  x = list(
    access_token = key
    , style = style
  )

  # create widget
  mapdeckmap <- htmlwidgets::createWidget(
    name = 'mapdeck_map',
    x = structure(
    	x,
    	mapdeck_map_data = data
    ),
    width = width,
    height = height,
    package = 'mapdeck',
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
    	defaultWidth = '100%',
    	defaultHeight = 800,
    	padding = padding,
    	browser.fill = FALSE
    )
  )

  header <- paste0(
    '<script src="https://unpkg.com/deck.gl@latest/deckgl.min.js"></script>
     <script src="https://api.tiles.mapbox.com/mapbox-gl-js/v0.46.0/mapbox-gl.js"></script>
    <link href="https://api.tiles.mapbox.com/mapbox-gl-js/v0.46.0/mapbox-gl.css" rel="stylesheet" />'
    )


  mapdeckmap$dependencies <- c(
  	mapdeckmap$dependencies,
  	list(
  		htmltools::htmlDependency(
  			name = "mapdeck",
  			version = "9999",
  			src=".",
  			head = header,
  			all_files = FALSE
  		)
  	)
  )

  return(mapdeckmap)
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
  htmlwidgets::shinyWidgetOutput(outputId, 'mapdeck_map', width, height, package = 'mapdeck')
}

#' @rdname mapdeck-shiny
#' @export
renderMapdeck <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, mapdeckOutput, env, quoted = TRUE)
}


# Get Map Data
#
# extracts the data attribute from the map
#
# @param map a mapdeck_map object
#
get_map_data = function(map){
	attr(map$x, "map_map_data", exact = TRUE)
}
