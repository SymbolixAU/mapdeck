context("dependencie")

test_that("dependencies are loaded", {

	## mapdeck-only dependencies
	## - mapgoxgl.js
	## - dekc.min.js
	## - mapdeck.css
	## - mapdeck_functions.js
	## - legend.js
	## - location.js
	## - colours.js
	## - coordinates.js

	## mapdeck() will include mapboxgl, deckgl

	m <- mapdeck()
	l <- lapply( m$dependencies, function(x) x[["script"]] )
	s <- unlist( l )
	expect_equal(
		s,
		c("mapdeck_functions.js", "deckgl.min.js","legend.js","title.js","mapdeck_location.js",
			"mapdeck_colours.js","mapdeck_coordinates.js", "mapbox-gl.js","mapdeck.js","htmlwidgets.js")
	)

	l <- lapply( m$dependencies, function(x) x[["stylesheet"]])
	s <- unlist( l )
	expect_equal(
		s,
		c("mapbox-gl.css","mapdeck.css")
	)

	## madpeck_dependencies are those required for shiny
	md <- mapdeck::mapdeck_dependencies()
	l <- lapply( md, function(x) x[["script"]])
	s <- unlist( l )
	expect_equal(
		s,
		c("mapdeck_functions.js", "deckgl.min.js","legend.js","title.js","mapdeck_location.js",
			"mapdeck_colours.js","mapdeck_coordinates.js")
	)

	## googleway google map object
	g <- structure(list(x = list(lat = -37.9, lng = 144.5, zoom = 8, styles = NULL,
															 search_box = FALSE, update_map_view = TRUE, zoomControl = TRUE,
															 mapTypeControl = TRUE, scaleControl = FALSE, streetViewControl = TRUE,
															 rotateControl = TRUE, fullscreenControl = TRUE, event_return_type = "list",
															 split_view = NULL, split_view_options = list(heading = 34,
															 																						 pitch = 10), geolocation = FALSE), width = NULL, height = NULL,
											sizingPolicy = list(defaultWidth = "100%", defaultHeight = 800,
																					padding = 0, viewer = list(defaultWidth = NULL, defaultHeight = NULL,
																																		 padding = NULL, fill = TRUE, suppress = FALSE, paneHeight = NULL),
																					browser = list(defaultWidth = NULL, defaultHeight = NULL,
																												 padding = NULL, fill = FALSE, external = FALSE),
																					knitr = list(defaultWidth = NULL, defaultHeight = NULL,
																											 figure = TRUE)), dependencies = list(structure(list(
																											 	name = "googleway", version = "9999", src = list(file = "."),
																											 	meta = NULL, script = NULL, stylesheet = NULL, head = "<script src=\"https://maps.googleapis.com/maps/api/js?key=abc&libraries=visualization,geometry,places,drawing\"></script><script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>",
																											 	attachment = NULL, package = NULL, all_files = FALSE), class = "html_dependency")),
											elementId = NULL, preRenderHook = NULL, jsHooks = list()), class = c("google_map",
																																													 "htmlwidget"), package = "googleway")
	ad <- mapdeck::add_dependencies(g)

	l <- lapply( ad$dependencies, function(x) x[["script"]])
	s <- unlist(l)
	expect_equal(
		s,
		c("mapdeck_functions.js", "deckgl.min.js","legend.js","title.js","mapdeck_location.js",
			"mapdeck_colours.js","mapdeck_coordinates.js")
	)

})




