context("transitions")

test_that("transition names replaced", {

	## arc
	t <- mapdeck:::arc_transitions()
	res <- mapdeck:::transitions_arc( t )
	expect_true( all( names( res ) %in% c("getSourcePosition", "getTargetPosition", "getSourceColor", "getTargetColor","getStrokeWidth") ) )
	expect_true( length( res ) == 5 )

	## geojson
	t <- mapdeck:::geojson_transitions()
	res <- mapdeck:::transitions_geojson( t )
	expect_true( all( names( res ) %in% c("getFillColor", "getLineColor", "getLineWidth", "getElevation","getRadius") ) )
	expect_true( length( res ) == 5 )

	## line
	t <- mapdeck:::line_transitions()
	res <- mapdeck:::transitions_line( t )
	expect_true( all( names( res ) %in% c("getSourcePosition", "getTargetPosition", "getColor", "getStrokeWidth") ) )
	expect_true( length( res ) == 4 )

	## path
	t <- mapdeck:::path_transitions()
	res <- mapdeck:::transitions_path( t )
	expect_true( all( names( res ) %in% c("getPath","getColor", "getWidth") ) )
	expect_true( length( res ) == 3 )

	## pointcloud
	t <- mapdeck:::pointcloud_transitions()
	res <- mapdeck:::transitions_pointcloud( t )
	expect_true( all( names( res ) %in% c("getPosition", "getColor") ) )
	expect_true( length( res ) == 2)

	## polygon
	t <- mapdeck:::polygon_transitions()
	res <- mapdeck:::transitions_polygon( t )
	expect_true( all( names( res ) %in% c("getPolygon", "getFillColor","getLineColor","getLineWidth","getElevation") ) )
	expect_true( length( res ) == 5)

	## scatterplot
	t <- mapdeck:::scatterplot_transitions()
	res <- mapdeck:::transitions_scatterplot( t )
	expect_true( all( names( res ) %in% c("getPosition", "getColor","getRadius") ) )
	expect_true( length( res ) == 3)

	## text
	t <- mapdeck:::text_transitions()
	res <- mapdeck:::transitions_text( t )
	expect_true( all( names( res ) %in% c("getPosition", "getColor","getAngle","getSize") ) )
	expect_true( length( res ) == 4)

})
