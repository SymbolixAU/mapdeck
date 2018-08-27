context("map_utilities")


test_that("invoke_method works", {

	m <- mapdeck(token = 'abc')
	x <- invoke_method(m, 'add_layer')

	expect_true(all(attr(x, 'class') == c("mapdeck", "htmlwidget")))
	expect_true(x$x$calls[[1]]$functions == 'add_layer')

})


test_that("layer_ids are set", {

	expect_true("arc-defaultLayerId" == mapdeck:::layerId(NULL, "arc"))
	expect_true("myLayer" == mapdeck:::layerId("myLayer"))
	expect_true("myLayer" == mapdeck:::layerId("myLayer", "grid"))
	expect_true("myLayer" == mapdeck:::layerId("myLayer", "scatterplot"))

})
