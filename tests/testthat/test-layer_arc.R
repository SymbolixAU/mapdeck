context("arc")

test_that("add_arc accepts multiple objects", {
	testthat::skip_on_cran()
	library(sfheaders)

	# poly <- '[{"radius":1000,"fill_colour":"#440154FF","polyline":"_ifpEo`ydL"}]'

	## sf
	set_token("abc")
	m <- mapdeck()

	df_from <- capitals[ capitals$country == "Australia", c("country", "lat", "lon") ]
	df_to <- capitals[ capitals$country == "United Kingdom of Great Britain and Northern Ireland", c("country", "lat", "lon") ]

	df_from <- setNames(object = df_from, c("country_from", "lat_from", "lon_from"))
	df_to <- setNames(object = df_to, c("country_to", "lat_to", "lon_to"))

	df <- cbind( df_from, df_to)

	sf_from <- sfheaders::sf_point( df_from, x = "lon_from", y = "lat_from", keep = T)
	sf_to <- sfheaders::sf_point( df_to, x = "lon_to", y = "lat_to", keep = T)
	sf_to <- setNames( object = sf_to, c("country_to", "geometry.1"))

	sf <- cbind( sf_from, sf_to )
	attr( sf, "class" ) <- c("sf", "data.frame")

	geo <- '[{"type":"Feature","properties":{"stroke_from":"#440154FF","stroke_to":"#440154FF","tilt":0.0,"height":1.0},"geometry":{"origin":{"type":"Point","coordinates":[149.08,-35.15]},"destination":{"type":"Point","coordinates":[-0.05,51.36]}}}]'

	p <- add_arc(map = m, data = sf, origin = "geometry", destination = "geometry.1")
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

	# ## sfencoded
	# enc_from <- googlePolylines::encode( sf_from )
	# enc_to <- googlePolylines::encode( sf_to )
	# enc <- cbind( enc_from, enc_to )
	# enc <- setNames(object = enc, nm = c("country_from", "origin", "country_to", "destination"))
	#
	# p <- add_arc( map = m, data = enc, origin = "origin", destination = "destination" )
	#
	# expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	# ## sfencodedLite
	# enc <- googlePolylines::encode( sf, strip = T )
	# p <- add_arc( map = m, data = enc )
	# expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	# ## data.frame with polyline
	# df <- as.data.frame( enc )
	# df$geometry <- unlist( df$geometry )
	# p <- add_arc( map = m, data = df, polyline = "geometry" )
	# expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## data.frame - gets 0.0 elevation as a default
	geo <- '[{"type":"Feature","properties":{"stroke_from":"#440154FF","stroke_to":"#440154FF","tilt":0.0,"height":1.0},"geometry":{"origin":{"type":"Point","coordinates":[149.08,-35.15,0.0]},"destination":{"type":"Point","coordinates":[-0.05,51.36,0.0]}}}]'

	p <- add_arc( map = m, data = df, origin = c("lon_from", "lat_from"), destination = c("lon_to", "lat_to") )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

})
