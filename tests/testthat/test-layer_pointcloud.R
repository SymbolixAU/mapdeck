context("pointcloud")

test_that("add_pointcloud accepts multiple objects", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	geo <- '[{"type":"Feature","properties":{"fill_colour":"#440154FF"},"geometry":{"geometry":{"type":"Point","coordinates":[69.11,34.28,12345.0]}}}]'
	poly1 <- '[{"fill_colour":"#440154FF","polyline":"_ifpEo`ydL","elevation":123.0}]'
	poly2 <- '[{"fill_colour":"#440154FF","elevation":123.0,"polyline":"_ifpEo`ydL"}]'

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
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly1 )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	enc$z <- 123
	p <- add_pointcloud( map = m, data = enc, elevation = "z" )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly1 )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )
	p <- add_pointcloud( map = m, data = df, elevation = "z", polyline = "geometry")
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly2 )

	## data.frame
	df <- capitals[1, ]
	df$z <- 12345
	geo <- '[{"type":"Feature","properties":{"fill_colour":"#440154FF"},"geometry":{"geometry":{"type":"Point","coordinates":[69.11,34.28,12345.0]}}}]'
	p <- add_pointcloud( map = m, data = df, lon = "lon", lat = "lat", elevation = "z" )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), geo )

})

test_that("pointcloud reads elevation from sf Z attribute", {

	geo <- '[{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0,1]}},{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0,2]}}]'
	sf <- geojsonsf::geojson_sf( geo )
	mapdeck:::resolve_data( sf, list(), "POINT" )

	l <- list()
	l[["palette"]] <- "viridis"
	l[["legend"]] <- FALSE
	l[["geometry"]] <- "geometry"
	geometry_column <- "geometry"
	shape <- mapdeck:::rcpp_pointcloud_geojson( sf, l, geometry_column )
	js <- '[{"type":"Feature","properties":{"fill_colour":"#440154FF"},"geometry":{"geometry":{"type":"Point","coordinates":[0.0,0.0,1.0]}}},{"type":"Feature","properties":{"fill_colour":"#440154FF"},"geometry":{"geometry":{"type":"Point","coordinates":[0.0,0.0,2.0]}}}]'
	expect_equal(as.character( shape$data ), js)
})
