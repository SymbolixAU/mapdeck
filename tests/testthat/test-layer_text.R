context("text")

test_that("add_text accepts multiple objects", {

	testthat::skip_on_cran()

	library(sfheaders)

	geo <- '[{"type":"Feature","properties":{"fill_colour":"#440154FF","anchor":"middle","angle":0.0,"alignment_baseline":"center","size":32.0,"text":"Kabul"},"geometry":{"geometry":{"type":"Point","coordinates":[69.11,34.28]}}}]'
	poly <- '[{"fill_colour":"#440154FF","anchor":"middle","angle":0.0,"alignment_baseline":"center","size":32.0,"polyline":"_ifpEo`ydL","text":"Kabul"}]'

	## sf
	set_token("abc")
	m <- mapdeck(style = mapdeck_style("dark"))

	sf <- sfheaders::sf_point( capitals[1, ], x = "lon", y = "lat", keep = T )
	p <- add_text(map = m, data = sf, text = "capital")
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	p <- add_text( map = m, data = enc, text = "capital" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	p <- add_text( map = m, data = enc, text = "capital" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )

	p <- add_text( map = m, data = df, polyline = "geometry", text = "capital")
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame
	p <- add_text( map = m, data = capitals[1, ], lon = "lon", lat = "lat", text = "capital" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

})
