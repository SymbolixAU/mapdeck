context("pointcloud")

test_that("add_pointcloud accepts multiple objects", {

	geo <- '[{"type":"Feature","properties":{"fill_colour":"#440154FF"},"geometry":{"geometry":{"type":"Point","coordinates":[69.11,34.28,12345.0]}}}]'
	poly <- '[{"fill_colour":"#440154FF","polyline":"_ifpEo`ydL","elevation":123.0}]'

	## sf
	set_token("abc")
	m <- mapdeck()

	sf <- capitals[1, ]
	sf$elev <- 12345
	sf <- sf::st_as_sf( sf, coords = c("lon", "lat", "elev") )
	p <- add_pointcloud(map = m, data = sf)
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), geo )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	enc$z <- 123
	p <- add_pointcloud( map = m, data = enc, elevation = "z" )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	enc$z <- 123
	p <- add_pointcloud( map = m, data = enc, elevation = "z" )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )
	p <- add_pointcloud( map = m, data = df, polyline = "geometry", elevation = "z")
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## data.frame
	df <- capitals[1, ]
	df$z <- 12345
	geo <- '[{"type":"Feature","properties":{"fill_colour":"#440154FF"},"geometry":{"geometry":{"type":"Point","coordinates":[69.11,34.28,12345.0]}}}]'
	p <- add_pointcloud( map = m, data = df, lon = "lon", lat = "lat", elevation = "z" )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), geo )

})
