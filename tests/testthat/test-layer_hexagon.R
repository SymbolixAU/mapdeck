context("hexagon")


test_that("add_hexagon accepts multiple objects", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	geo <- '[{"type":"Feature","properties":{},"geometry":{"geometry":{"type":"Point","coordinates":[69.11,34.28]}}}]'
	poly <- '[{"polyline":"_ifpEo`ydL"}]'

	## sf
	set_token("abc")
	m <- mapdeck()

	sf <- sf::st_as_sf( capitals[1, ], coords = c("lon", "lat") )
	p <- add_hexagon(map = m, data = sf)
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), geo )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	p <- add_hexagon( map = m, data = enc )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	p <- add_hexagon( map = m, data = enc )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )

	p <- add_hexagon( map = m, data = df, polyline = "geometry" )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## data.frame
	p <- add_hexagon( map = m, data = capitals[1, ], lon = "lon", lat = "lat" )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), geo )

})
