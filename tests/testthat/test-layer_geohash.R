context("geohash")


test_that("add_geohash accepts multiple objects", {

	testthat::skip_on_cran()

	library(geohashTools)

	geo <- "[{\"elevation\":0,\"fill_colour\":[68.0,1.0,84.0,255.0],\"stroke_colour\":[68.0,1.0,84.0,255.0],\"geohash\":\"9q8yu\"}]"
	poly <- '[{"weight":1.0,"polyline":"_ifpEo`ydL"}]'

	## sf
	set_token("abc")
	m <- mapdeck()
	sf <- sfheaders::sf_point( capitals[1, ], x = "lon", y = "lat" )
	p <- add_geohash(map = m, data = geohash[1,], geohash = "geohash")
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

	# ## sfencoded
	# enc <- googlePolylines::encode( sf )
	# p <- add_geohash( map = m, data = enc )
	# expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )
	#
	# ## sfencodedLite
	# enc <- googlePolylines::encode( sf, strip = T )
	# p <- add_geohash( map = m, data = enc )
	# expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame with polyline
	# df <- as.data.frame( enc )
	# df$geometry <- unlist( df$geometry )
	#
	# p <- add_geohash( map = m, data = df, polyline = "geometry" )
	# expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame
	# p <- add_geohash( map = m, data = capitals[1, ], lon = "lon", lat = "lat" )
	# expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

})

test_that("empty data doesn't crash",{
	m <- mapdeck()
	res <- mapdeck::add_geohash(map = m, data = data.frame())
	expect_true( res$x$calls[[1]]$functions == "md_layer_clear" )
})

