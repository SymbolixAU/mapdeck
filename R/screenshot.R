mapdeckHtml2canvasDependency <- function() {
	list(
		createHtmlDependency(
			name = "html2canvas",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib", package = "mapdeck"),
			script = c("html2canvas.min.js","screenshot.js"),
			all_files = FALSE
		)
	)
}


take_screenshot <- function( htmlwidget ) {
	htmlwidget <- addDependency( htmlwidget, mapdeckHtml2canvasDependency() )
	invoke_method(
		htmlwidget, "md_screenshot"
	)
}

