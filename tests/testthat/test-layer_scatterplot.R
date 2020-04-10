context("scatterplot")

test_that("add_scatterplot accepts multiple objects", {
	testthat::skip_on_cran()
	library(sfheaders)

	geo <- '{"fill_colour":[68.0,1.0,84.0,255.0],"stroke_colour":[68.0,1.0,84.0,255.0],"stroke_width":0.0,"radius":1,"lon":69.11,"lat":34.28,"geometry":[69.11,34.28]}'
	poly <- '[{"fill_colour":"#440154FF","stroke_colour":"#440154FF","stroke_width":0.0,"radius":1,"polyline":"_ifpEo`ydL"}]'


	check <- function( geo, res ) {
		geo <- jsonify::from_json( geo )
		res <- jsonify::from_json( res$x$calls[[1]]$args[[2]] )
		expect_equal(geo[["lon"]], res[["lon"]])
		expect_equal(geo[["lat"]], res[["lat"]])
		expect_equal(geo[["fill_colour"]], res[["fill_colour"]])
		expect_equal(geo[["stroke_colour"]], res[["stroke_colour"]])
		expect_equal(geo[["stroke_width"]], res[["stroke_width"]])
	}

	## sf
	set_token("abc")
	m <- mapdeck()

	sf <- sfheaders::sf_point( capitals[1, ], x = "lon", y = "lat" )
	p <- add_scatterplot(map = m, data = sf)
	check( geo, p )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	p <- add_scatterplot( map = m, data = enc )
	check( poly, p )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	p <- add_scatterplot( map = m, data = enc )
	check( poly, p )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )

	p <- add_scatterplot( map = m, data = df, polyline = "geometry" )
	check( poly, p )

	## data.frame
	p <- add_scatterplot( map = m, data = capitals[1, ], lon = "lon", lat = "lat" )
	check( geo, p )

})
