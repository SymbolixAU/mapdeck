context("grid")


test_that("add_grid accepts multiple objects", {

	testthat::skip_on_cran()

	library(sfheaders)

	geo <- '[{"type":"Feature","properties":{"weight":1.0},"geometry":{"geometry":{"type":"Point","coordinates":[69.11,34.28]}}}]'
	poly <- '[{"weight":1.0,"polyline":"_ifpEo`ydL"}]'

	## sf
	set_token("abc")
	m <- mapdeck()

	sf <- sfheaders::sf_point( capitals[1, ], x = "lon", y = "lat" )
	p <- add_grid(map = m, data = sf)
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	p <- add_grid( map = m, data = enc )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	p <- add_grid( map = m, data = enc )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )

	p <- add_grid( map = m, data = df, polyline = "geometry" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame
	p <- add_grid( map = m, data = capitals[1, ], lon = "lon", lat = "lat" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

})

