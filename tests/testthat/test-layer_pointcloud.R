context("pointcloud")

test_that("add_pointcloud accepts multiple objects", {

	library(sfheaders)

	geo <- '{"elevation":12345.0,"fill_colour":[0.266667,0.003922,0.329412,1.0],"lon":69.11,"lat":34.28,"geometry":[69.11,34.28,12345.0]}'
	poly <- '[{\"elevation\":123.0,\"fill_colour\":\"#440154FF\",\"polyline\":\"_ifpEo`ydL\"}]'

	## sf
	set_token("abc")
	m <- mapdeck()

	df <- capitals[1, ]
	df$elev <- 12345
	sf <- sfheaders::sf_point( df[1, ], x = "lon", y = "lat", z = "elev" )
	p <- add_pointcloud(map = m, data = sf)
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	enc$z <- 123
	p <- add_pointcloud( map = m, data = enc, elevation = "z" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	enc$z <- 123
	p <- add_pointcloud( map = m, data = enc, elevation = "z" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )
	p <- add_pointcloud( map = m, data = df, elevation = "z", polyline = "geometry")
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), poly )

	## data.frame
	df <- capitals[1, ]
	df$z <- 12345
	geo <- '{"elevation":12345.0,"fill_colour":[0.266667,0.003922,0.329412,1.0],"lon":69.11,"lat":34.28,"geometry":[69.11,34.28,12345.0]}'
	p <- add_pointcloud( map = m, data = df, lon = "lon", lat = "lat", elevation = "z" )
	expect_equal( as.character( p$x$calls[[1]]$args[[2]] ), geo )

})

test_that("pointcloud reads elevation from sf Z attribute", {

	geo <- '[{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0,1]}},{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0,2]}}]'
	sf <- geojsonsf::geojson_sf( geo )
	# mapdeck:::resolve_data( sf, list(), "POINT" )

	l <- list()
	l[["palette"]] <- "viridis"
	l[["legend"]] <- FALSE
	l[["geometry"]] <- "geometry"
	geometry_column <- list( geometry = c("lon","lat","elevation") )
	shape <- mapdeck:::rcpp_point_sf_columnar( sf, l, geometry_column, digits = 6, "pointcloud" )
	js <- '{"elevation":[1.0,2.0],"fill_colour":[0.266667,0.003922,0.329412,1.0,0.266667,0.003922,0.329412,1.0],"lat":[0.0,0.0],"lon":[0.0,0.0],"geometry":[0.0,0.0,1.0,0.0,0.0,2.0]}'
	expect_equal(as.character( shape$data ), js)
})
