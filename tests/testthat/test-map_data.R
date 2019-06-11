context("map_data")

test_that("lon & lat columns are found", {

  ## TODO
	## sf/sfencoded/sfencodedlite objects are not affected

	df <- mapdeck::capitals

	expect_true( mapdeck:::find_lon_column(names(df)) == "lon" )
	expect_true( mapdeck:::find_lat_column(names(df)) == "lat" )

	l <- mapdeck:::resolve_data( df, list(), "POINT" )
	expect_true( l[["lon"]] == "lon" )
	expect_true( l[["lat"]] == "lat" )

})
