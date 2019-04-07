context("styles")


test_that("style arguments checked", {

	expect_error(mapdeck_style(style = 'abc'))

	expect_equal(mapdeck_style(style = 'streets'), "mapbox://styles/mapbox/streets-v11")
	expect_equal(mapdeck_style(style = 'outdoors'), "mapbox://styles/mapbox/outdoors-v11")
	expect_equal(mapdeck_style(style = 'light'), "mapbox://styles/mapbox/light-v10")
	expect_equal(mapdeck_style(style = 'dark'), "mapbox://styles/mapbox/dark-v10")
	expect_equal(mapdeck_style(style = 'satellite'), "mapbox://styles/mapbox/satellite-v9")
	expect_equal(mapdeck_style(style = 'satellite-streets'), "mapbox://styles/mapbox/satellite-streets-v11")

})
