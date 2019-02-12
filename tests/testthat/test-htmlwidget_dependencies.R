context("htmlwidgetDependencies")

test_that("dependencies are loaded", {

	lst <- list(
		mapdeck:::mapdeckArcDependency()
		, mapdeck:::mapdeckGeojsonDependency()
		, mapdeck:::mapdeckGridDependency()
		, mapdeck:::mapdeckHexagonDependency()
		, mapdeck:::mapdeckLineDependency()
		, mapdeck:::mapdeckPathDependency()
		, mapdeck:::mapdeckPointcloudDependency()
		, mapdeck:::mapdeckPolygonDependency()
		, mapdeck:::mapdeckScatterplotDependency()
		, mapdeck:::mapdeckScreengridDependency()
		, mapdeck:::mapdeckTextDependency()
	)

	n <- sapply(lst, function(x) x[[1]]$name)
	cl <- sapply(lst, function(x) attr(x[[1]], 'class') )

	expect_true(all(c("arc","geojson", "grid","hexagon","line","path","pointcloud","polygon","scatterplot", "screengrid","text") %in% n))
	expect_true(unique(cl) == "html_dependency")

})
