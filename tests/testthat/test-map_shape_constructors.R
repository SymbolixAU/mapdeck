context("map shape constructors")

test_that("map object created", {

	objArgs <- quote(add_polygon(data = melbourne, fill_colour = "AREASQKM", stroke_colour = "#FF00FF"))
	data <- mapdeck::melbourne
	cols <- mapdeck:::polygonColumns()
	shape <- mapdeck:::createMapObject(data, cols, objArgs)

	expect_true(nrow(shape) == nrow(mapdeck::melbourne))
	expect_true(all.equal(names(shape), c("fill_colour", "stroke_colour")))
	expect_true(unique(shape$stroke_colour) == "#FF00FF")


	objArgs <- quote(add_polygon(data = melbourne, fill_colour = "AREASQKM", stroke_colour = viridisLite::viridis(1)))
	data <- mapdeck::melbourne
	cols <- mapdeck:::polygonColumns()
	shape <- mapdeck:::createMapObject(data, cols, objArgs)

	expect_true(unique(shape$stroke_colour) == viridisLite::viridis(1))

	objArgs <- quote(add_polygon(data = melbourne, fill_colour = "AREASQKM",
															 stroke_colour = mapdeck:::removeAlpha(viridisLite::viridis(1))))
	data <- mapdeck::melbourne
	cols <- mapdeck:::polygonColumns()
	shape <- mapdeck:::createMapObject(data, cols, objArgs)

	expect_true(unique(shape$stroke_colour) == "#440154")

})
