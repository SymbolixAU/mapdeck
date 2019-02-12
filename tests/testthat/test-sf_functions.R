context("sf")

test_that("sf objects are subset correctly", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()
	library(sf)


	f <- function(sf) {
		c( mapdeck:::sf_needs_subsetting( sf, "geometry", "POINT")
			 , mapdeck:::sf_needs_subsetting( sf, "geometry", "MULTIPOINT")
			 , mapdeck:::sf_needs_subsetting( sf, "geometry", "LINESTRING")
			 , mapdeck:::sf_needs_subsetting( sf, "geometry", "MULTILINESTRING")
			 , mapdeck:::sf_needs_subsetting( sf, "geometry", "POLYGON")
			 , mapdeck:::sf_needs_subsetting( sf, "geometry", "MULTIPOLYGON")
		)
	}

	sf <- geojsonsf::geojson_sf('{"type":"Point","coordinates":[0,0]}')
	expect_identical( f(sf), c(F,T,T,T,T,T) )
	sf <- geojsonsf::geojson_sf('{"type":"MultiPoint","coordinates":[[0,0],[1,1]]}')
	expect_identical( f(sf), c(T,F,T,T,T,T) )
	sf <- geojsonsf::geojson_sf('{"type":"LineString","coordinates":[[0,0],[1,1]]}')
	expect_identical( f(sf), c(T,T,F,T,T,T) )
	sf <- geojsonsf::geojson_sf('{"type":"MultiLineString","coordinates":[[[0,0],[1,1]],[[0,0],[1,1]]]}')
	expect_identical( f(sf), c(T,T,T,F,T,T) )
	sf <- geojsonsf::geojson_sf('{"type":"Polygon","coordinates":[[[0,0],[0,1],[1,1],[1,0],[0,0]]]}')
	expect_identical( f(sf), c(T,T,T,T,F,T) )
	sf <- geojsonsf::geojson_sf('{"type":"MultiPolygon","coordinates":[[[[0,0],[0,1],[1,1],[1,0],[0,0]],[[2,2],[2,3],[3,3],[3,2],[2,2]]]]}')
	expect_identical( f(sf), c(T,T,T,T,T,F) )
	sf <- geojsonsf::geojson_sf('{"type":"MultiPolygon","coordinates":[[[[0,0],[0,1],[1,1],[1,0],[0,0]],[[0,0],[0,-1],[-1,-1],[1,0],[0,0]]]]}')
	expect_identical( f(sf), c(T,T,T,T,T,F) )


	js <- '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{},"geometry":{"type":"LineString","coordinates":[[0.0,0.0],[1.0,1.0],[2.0,1.0]]}},{"type":"Feature","properties":{},"geometry":{"type":"MultiLineString","coordinates":[[[2.0,2.0],[1.0,3.0]],[[0.0,0.0],[1.0,1.0],[2.0,1.0]]]}}]}'
	sf <- geojsonsf::geojson_sf( js )
	expect_identical( f(sf), c(T,T,T,T,T,T) )

	expect_identical( f(roads), c(T,T,F,T,T,T) )

	l <- list()
	l <- mapdeck:::resolve_data( sf, l, "LINESTRING" )
	expect_true(nrow(l$data) == 1)

	l <- list()
	l <- mapdeck:::resolve_data( sf, l, "MULTILINESTRING" )
	expect_true(nrow(l$data) == 1)

})


