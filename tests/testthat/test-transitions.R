context("transitions")

test_that("transition names replaced", {

	## arc
	t <- mapdeck:::arc_transitions()
	res <- mapdeck:::transitions_arc( t )
	expect_true( all( names( res ) %in% c("getSourcePosition", "getTargetPosition", "getSourceColor", "getTargetColor","getStrokeWidth") ) )
	expect_true( length( res ) == 5 )

	## line
	t <- mapdeck:::line_transitions()
	res <- mapdeck:::transitions_line( t )
	expect_true( all( names( res ) %in% c("getSourcePosition", "getTargetPosition", "getColor", "getStrokeWidth") ) )
	expect_true( length( res ) == 4 )

	## path
	t <- mapdeck:::path_transitions()
	res <- mapdeck:::transitions_path( t )
	expect_true( all( names( res ) %in% c("getColor", "getStrokeWidth") ) )
	expect_true( length( res ) == 2 )

	## pointcloud
	t <- mapdeck:::pointcloud_transitions()
	res <- mapdeck:::transitions_pointcloud( t )
	expect_true( all( names( res ) %in% c("getColor") ) )
	expect_true( lenght( res ) == 1)

	## polygon
	t <- mapdeck:::polygon_transitions()
	res <- mapdeck:::transitions_polygon( t )
	expect_true( all( names( res ) %in% c("getFillColor","getLineColor","getLineWidth","getElevation") ) )
	expect_true( lenght( res ) == 4)

	## scatterplot
	t <- mapdeck:::scatterplot_transitions()
	res <- mapdeck:::transitions_scatterplot( t )
	expect_true( all( names( res ) %in% c("getFillColor","getRadius") ) )
	expect_true( lenght( res ) == 2)

	## text
	t <- mapdeck:::text_transitions()
	res <- mapdeck:::transitions_text( t )
	expect_true( all( names( res ) %in% c("getColor","getAngle","getSize") ) )
	expect_true( lenght( res ) == 3)


})
