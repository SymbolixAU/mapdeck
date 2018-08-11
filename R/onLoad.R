.onLoad <- function(...){

	if(is.null(getOption("mapdeck"))) {

		options <- list(
			mapdeck = list(
				mapbox = NA_character_
			)
		)
		attr(options, "class") <- "mapdeck_api"
		options(mapdeck = options)
	}
}
