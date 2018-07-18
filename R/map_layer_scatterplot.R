mapdeckScatterplotDependency <- function() {
	list(
		htmltools::htmlDependency(
			"scatterplot",
			"1.0.0",
			system.file("htmlwidgets/lib/scatterplot", package = "mapdeck"),
			script = c("scatterplot.js")
		)
	)
}


#' Add Scatterplot
#'
#'
#' @export
add_scatterplot <- function(map, data = get_map_data(map)) {
	map <- addDependency(map, mapdeckScatterplotDependency())
	invoke_method(map, "add_scatterplot", data)
}
