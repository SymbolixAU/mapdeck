context("pointcloud")

test_that("add_pointcloud accepts multiple objects", {
	testthat::skip_on_cran()
	library(sfheaders)

	geo <- '{"elevation":12345.0,"fill_colour":[68.0,1.0,84.0,255.0],"lon":69.11,"lat":34.28,"geometry":[69.11,34.28,12345.0]}'
	poly <- '[{\"elevation\":123.0,\"fill_colour\":\"#440154FF\",\"polyline\":\"_ifpEo`ydL\"}]'

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

	df <- capitals[1, ]
	df$elev <- 12345
	sf <- sfheaders::sf_point( df[1, ], x = "lon", y = "lat", z = "elev" )
	p <- add_pointcloud(map = m, data = sf)
	check( geo, p )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	enc$z <- 123
	p <- add_pointcloud( map = m, data = enc, elevation = "z" )
	check( poly, p )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	enc$z <- 123
	p <- add_pointcloud( map = m, data = enc, elevation = "z" )
	check( poly, p )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )
	p <- add_pointcloud( map = m, data = df, elevation = "z", polyline = "geometry")
	check( poly, p )

	## data.frame
	df <- capitals[1, ]
	df$z <- 12345
	geo <- '{"elevation":12345.0,"fill_colour":[68.0,1.0,84.0,255.0],"lon":69.11,"lat":34.28,"geometry":[69.11,34.28,12345.0]}'
	p <- add_pointcloud( map = m, data = df, lon = "lon", lat = "lat", elevation = "z" )
	check( geo, p )

})

test_that("pointcloud reads elevation from sf Z attribute", {

	geo <- '[{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0,1]}},{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0,2]}}]'
	sf <- geojsonsf::geojson_sf( geo )
	# mapdeck:::resolve_data( sf, list(), "POINT" )

	check <- function( geo, res ) {
		geo <- jsonify::from_json( geo )
		res <- jsonify::from_json( res )
		expect_equal(geo[["lon"]], res[["lon"]])
		expect_equal(geo[["lat"]], res[["lat"]])
		expect_equal(geo[["fill_colour"]], res[["fill_colour"]])
		expect_equal(geo[["stroke_colour"]], res[["stroke_colour"]])
		expect_equal(geo[["stroke_width"]], res[["stroke_width"]])
	}

	l <- list()
	l[["palette"]] <- "viridis"
	l[["legend"]] <- FALSE
	l[["geometry"]] <- "geometry"
	geometry_column <- list( geometry = c("lon","lat","elevation") )
	shape <- mapdeck:::rcpp_point_sf_columnar( sf, l, geometry_column, digits = 6, "pointcloud" )
	js <- '{"elevation":[1.0,2.0],"fill_colour":[68.0,1.0,84.0,255.0,68.0,1.0,84.0,255.0],"lat":[0.0,0.0],"lon":[0.0,0.0],"geometry":[0.0,0.0,1.0,0.0,0.0,2.0]}'
	check( js, shape$data )
})
