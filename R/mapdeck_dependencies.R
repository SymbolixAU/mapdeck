## from htmltools::htmlDependency()
createHtmlDependency <- function(name, version, src, script = NULL, stylesheet = NULL) {
	structure(
		list(
			name = name
			, version = version
			, src = list( file = src )
			, meta = NULL
			, script = script
			, stylesheet = stylesheet
			, head = NULL
			, attachment = NULL
			, package = NULL
			, all_files = TRUE
		)
		, class = "html_dependency"
	)
}


addDependency <- function(map, dependencyFunction) {

	existingDeps <- sapply(map$dependencies, function(x) x[['name']])
	addingDependency <- sapply(dependencyFunction, function(x) x[['name']])

	if(!addingDependency %in% existingDeps)
		map$dependencies <- c(map$dependencies, dependencyFunction)

	return(map)
}

#' Add Dependencies
#'
#' Add javascript dependencies to a map when not using a mapdeck map.
#'
#' @examples
#' \donttest{
#'
#' ## use with a google map from googleway
#' library(googleway)
#'
#' set_key("GOOGLE_MAP_KEY")
#'
#' google_map() %>%
#' 	add_dependencies() %>%
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
add_dependencies <- function( map ) {
	map$dependencies <- c( map$dependencies, mapdeck_dependencies() )
	return( map )
}

#' Mapdeck Dependencies
#'
#' @export
mapdeck_dependencies <- function() c( mapdeck_functions(), deckgl_min_js() )

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

# css specific to mapdeck map
mapdeck_css <- function() {
	list(
		createHtmlDependency(
			name = "mapdeck",
			version = "0.0.1",
			src = system.file("htmlwidgets/lib/", package = "mapdeck"),
			stylesheet = c("mapdeck.css")
		)
	)
}

mapdeck_legend <- function() {
	list(
		createHtmlDependency(
			name = "legend",
			version = "0.0.1",
			src = system.file("htmlwidgets/lib/map/", package = "mapdeck"),
			script = c("legend.js")
		)
	)
}

mapdeck_title <- function() {
	list(
		createHtmlDependency(
			name = "title",
			version = "0.0.1",
			src = system.file("htmlwidgets/lib/map/", package = "mapdeck"),
			script = c("title.js")
		)
	)
}

