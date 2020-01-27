context("geojson")

test_that("empty data doesn't crash",{
	## issue 252
	m <- mapdeck()
	res <- mapdeck::add_geojson(map = m, data = roads[0,])
	expect_true( res$x$calls[[1]]$functions == "md_layer_clear" )
})
