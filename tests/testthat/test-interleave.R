
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


test_that("polygon multicoloured coordinates are coloured correctly", {

	df <- data.frame(
		x = c(0,1,1,0,0)
		, y = c(0,0,1,1,0)
		, z = 1:5
		, s = 1:5
	)

	l <- list(fill_colour = "s")

	sf_square <- sfheaders::sf_polygon(
		obj = df
		, x = "x"
		, y = "y"
		, z = "z"
		, list_columns = "s"
		, keep = TRUE
	)

	## why does this crash??
	## because it's expecting a LINESTRING??
	# res <- mapdeck:::rcpp_path_interleaved(
	# 	sf = sf_square
	# 	, params = l
	# 	, list_columns = 1L
	# 	, digits = 6L
	# 	, layer_name = "polygon"
	# )

	# mapdeck:::rcpp_interleave_primitive_triangle(
	# 	data = sf_square
	# 	, list_columns = integer()
	# )

	res <- mapdeck:::rcpp_triangle_interleaved(
		data = sf_square
		, params = l
		, list_columns = integer()
		, digits = 6L
		, layer_name = "polygon"
	)

	res_df <- jsonify::from_json( res[["data"]] )

	res_colours <- colourvalues::convert_colours( matrix(res_df$data$fill_colour, ncol = 4, byrow = TRUE) * 255.0 )

	expect_true( length( res_colours ) == 6 ) ## because there are 2 triangles

	## The first coordinate in sf_squares is 0,0 , and therefore so is the last one.

 	# res_coords <- matrix( res_df$coordinates, ncol = 3, byrow = TRUE )
	# input_matrix <- as.matrix( df[, c("x", "y", "z" ) ] )

	# mapdeck:::rcpp_interleave_primitive_triangle(
	# 	data = sf_square
	# 	, list_columns = integer()
	# )

})



