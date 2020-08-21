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


test_that("list columns found",{
	m1 <- matrix(c(0,0,0,1,1,1,1,0,0,0), ncol = 2, byrow = T)
	m2 <- matrix(c(0,0,0,2,2,2,2,0,0,0), ncol = 2, byrow = T)
	m1 <- cbind(1, m1)
	m2 <- cbind(2, m2)
	ls <- rbind(m1,m2)

	sf <- sfheaders::sf_polygon(
		obj = ls
		, polygon_id = 1
	)

	p1 <- letters[1:5]
	p2 <- letters[21:25]
	p <- list( p1, p2)

	sf$prop <- p
	sf$prop2 <- list(p2, p1)

	expect_equal( mapdeck:::list_columns( sf, "geometry" ), c(2,3) )

})
