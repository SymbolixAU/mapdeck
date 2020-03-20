context("scatterplot")

test_that("add_scatterplot accepts multiple objects", {

	library(sfheaders)

	geo <- '{"fill_colour":[0.266667,0.003922,0.329412,1.0],"stroke_colour":[0.266667,0.003922,0.329412,1.0],"stroke_width":0.0,"radius":1,"lon":69.11,"lat":34.28,"geometry":[69.11,34.28]}'
	poly <- '[{"fill_colour":"#440154FF","stroke_colour":"#440154FF","stroke_width":0.0,"radius":1,"polyline":"_ifpEo`ydL"}]'

	## sf
	set_token("abc")
	m <- mapdeck()

	sf <- sfheaders::sf_point( capitals[1, ], x = "lon", y = "lat" )
	p <- add_scatterplot(map = m, data = sf)
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	p <- add_scatterplot( map = m, data = enc )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	p <- add_scatterplot( map = m, data = enc )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )

	p <- add_scatterplot( map = m, data = df, polyline = "geometry" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame
	p <- add_scatterplot( map = m, data = capitals[1, ], lon = "lon", lat = "lat" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

})
