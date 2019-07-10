context("tokens")

test_that("tokens accessed",{

	mapdeck::clear_tokens()
	expect_null( mapdeck:::get_access_token() )

	Sys.setenv("MAPBOX" = "abc")
	expect_equal( mapdeck:::get_access_token(), "abc" )
	Sys.unsetenv("MAPBOX")
	expect_null( mapdeck:::get_access_token() )

	Sys.setenv("MAPBOX_TOKEN" = "abc")
	expect_equal( mapdeck:::get_access_token(), "abc" )
	Sys.unsetenv("MAPBOX_TOKEN")
	expect_null( mapdeck:::get_access_token() )

	Sys.setenv("MAPBOX_KEY" = "abc")
	expect_equal( mapdeck:::get_access_token(), "abc" )
	Sys.unsetenv("MAPBOX_KEY")
	expect_null( mapdeck:::get_access_token() )

	Sys.setenv("MAPBOX_API_TOKEN" = "abc")
	expect_equal( mapdeck:::get_access_token(), "abc" )
	Sys.unsetenv("MAPBOX_API_TOKEN")
	expect_null( mapdeck:::get_access_token() )

	Sys.setenv("MAPBOX_API_KEY" = "abc")
	expect_equal( mapdeck:::get_access_token(), "abc" )
	Sys.unsetenv("MAPBOX_API_KEY")
	expect_null( mapdeck:::get_access_token() )

	Sys.setenv("MAPDECK" = "abc")
	expect_equal( mapdeck:::get_access_token(), "abc" )
	Sys.unsetenv("MAPDECK")
	expect_null( mapdeck:::get_access_token() )
})
