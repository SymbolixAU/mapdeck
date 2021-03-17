
context("interleave")

test_that("interleaving primitives (POINT, LINE, TRIANGLE) return the same interleaved structures", {


	sf_roads <- mapdeck::roads

	l <- list(stroke_colour = "EZI_RDNAME")

	# res <- mapdeck:::rcpp_path_interleaved(
	# 	sf = sf
	# 	, params = l
	# 	, list_columns = integer()
	# 	, digits = 6L
	# 	, layer_name = "path"
	# )

	res_line <- mapdeck:::rcpp_interleave_primitive_line(
		sf = sf_roads
	)

	expect_equal(
		names( res_line )
		, c("data", "coordinates", "total_coordinates", "geometry_coordinates", "start_indices", "stride")
	)

	coords <- res_line[["coordinates"]]
	expect_equal(
		coords,
		interleave::interleave( sf_roads$geometry )
	)

	sf_poly <- spatialwidget::widget_melbourne

	res_triangle <- mapdeck:::rcpp_interleave_primitive_triangle(
		data = sf_poly
		, list_columns = integer()
	)

	expect_equal(
		names( res_triangle )
		, names( res_line )
	)


})
