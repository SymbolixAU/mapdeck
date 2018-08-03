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

test_that("Defaults columns returned", {

	## arc
	## grid
	## line
	## path
	## cloud
	## polygon
	## scatterplot
	## screengrid

	arcCols <- mapdeck::arcColumns()
	gridCols <- mapdeck::gridColumns()
	lineCols <- mapdeck::lineColumns()
	pathCols <- mapdeck::pathColumns()
	pointCols <- mapdeck::pointcloudColumns()
	polyCols <- mapdeck::polygonColumns()
	scatterCols <- mapdeck::scatterplotColumns()
	screenCols <- mapdeck::screengridColumns()

	#setdiff(mapdeck::arcColumns(), mapdeck::requiredArcColumns())
	#setdiff(mapdeck::gridColumns(), mapdeck::requiredGridColumns())
	#setdiff(mapdeck::lineColumns(), mapdeck::requiredLineColumns())
	#setdiff(mapdeck::pathColumns(), mapdeck::requiredPathColumns())
	#setdiff(mapdeck::pointcloudColumns(), mapdeck::requiredPointcloudColumns())
	#setdiff(mapdeck::polygonColumns(), mapdeck::requiredPolygonColumns())
	#setdiff(mapdeck::scatterplotColumns(), mapdeck::requiredScatterplotColumns())
	#setdiff(mapdeck::screengridColumns(), mapdeck::requiredScreengridColumns())

	arcShape <- data.frame(origin = "a", destination = "b")
	gridShape <- data.frame(polyline = 1)
	lineShape <- arcShape
	pathShape <- gridShape
	pointShape <- data.frame(polyline = 1, elevation = 1)
	polyShape <- gridShape
	scatterShape <- pointShape
	screenShape <- gridShape

	arcDefaults <- setdiff(arcCols, names(arcShape))
	gridDefaults <- setdiff(gridCols, names(gridShape))
	lineDefaults <- setdiff(lineCols, names(lineShape))
	pathDefaults <- setdiff(pathCols, names(pathShape))
	pointDefaults <- setdiff(pointCols, names(pointShape))
	polyDefaults <- setdiff(polyCols, names(polyShape))
	scatterDefaults <- setdiff(scatterCols, names(scatterShape))
	screenDefaults <- setdiff(screenCols, names(screenShape))

	if( length(arcDefaults) > 0 ) {
		arcRes <- mapdeck::addDefaults(arcShape, arcDefaults, 'arc')
	  expect_true(all(arcCols %in% names(arcRes)))
	}

	if( length(gridDefaults) > 0 ) {
		gridRes <- mapdeck::addDefaults(gridShape, gridDefaults, 'grid')
		expect_true(all(gridCols %in% names(gridRes)))
	}

	if( length(lineDefaults) > 0 ) {
		lineRes <- mapdeck::addDefaults(lineShape, lineDefaults, 'line')
		expect_true(all(lineCols %in% names(lineRes)))
	}

	if( length(pathDefaults) > 0 ) {
		pathRes <- mapdeck::addDefaults(pathShape, pathDefaults, 'path')
		expect_true(all(pathCols %in% names(pathRes)))
	}

	if( length(pointDefaults) > 0 ) {
		pointRes <- mapdeck::addDefaults(pointShape, pointDefaults, 'pointcloud')
		expect_true(all(pointCols %in% names(pointRes)))
	}

	if( length(polyDefaults) > 0 ) {
		polyRes <- mapdeck::addDefaults(polyShape, polyDefaults, 'polygon')
		expect_true(all(polyCols %in% names(polyRes)))
	}

	if( length(scatterDefaults) > 0 ) {
		scatterRes <- mapdeck::addDefaults(scatterShape, scatterDefaults, 'scatterplot')
		expect_true(all(scatterCols %in% names(scatterRes)))
	}

	if( length(screenDefaults) > 0 ) {
		screenRes <- mapdeck::addDefaults(screenShape, screenDefaults, 'screengrid')
		expect_true(all(screenCols %in% names(screenRes)))
	}
})

test_that("shape attributes returned", {

	shapeAttr <- mapdeck::shapeAttributes(
		fill_colour = "fill"
		, stroke_colour = "stroke"
		, stroke_from = "from"
		, stroke_to = "to"
	)
	expect_true(all(c("stroke_colour", "fill_colour", "stroke_from", "stroke_to") %in% names(shapeAttr)))

})

