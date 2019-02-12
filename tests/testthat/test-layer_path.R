context("path")

test_that("add_path accepts multiple objects", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	geo <- '[{"type":"Feature","properties":{"stroke_colour":"#440154FF","stroke_width":1.0},"geometry":{"geometry":{"type":"LineString","coordinates":[[145.014291,-37.830458],[145.014345,-37.830574],[145.01449,-37.830703],[145.01599,-37.831484],[145.016479,-37.831699],[145.016813,-37.83175],[145.01712,-37.831742],[145.0175,-37.831667],[145.017843,-37.831559],[145.018349,-37.83138],[145.018603,-37.83133],[145.018901,-37.831301],[145.019136,-37.831301],[145.01943,-37.831333],[145.019733,-37.831377],[145.020195,-37.831462],[145.020546,-37.831544],[145.020641,-37.83159],[145.020748,-37.83159],[145.020993,-37.831664]]}}},{"type":"Feature","properties":{"stroke_colour":"#440154FF","stroke_width":1.0},"geometry":{"geometry":{"type":"LineString","coordinates":[[145.015016,-37.830832],[145.015561,-37.831125],[145.016285,-37.831463],[145.016368,-37.8315],[145.016499,-37.831547],[145.016588,-37.831572],[145.01668,-37.831593],[145.01675,-37.831604],[145.016892,-37.83162],[145.016963,-37.831623],[145.017059,-37.831623],[145.017154,-37.831617],[145.017295,-37.831599],[145.017388,-37.831581],[145.017523,-37.831544],[145.018165,-37.831324],[145.018339,-37.831275],[145.018482,-37.831245],[145.018627,-37.831223],[145.01881,-37.831206],[145.018958,-37.831202],[145.019142,-37.831209],[145.019325,-37.831227],[145.019505,-37.831259],[145.020901,-37.831554],[145.020956,-37.83157]]}}}]'
	poly <- '[{"stroke_colour":"#440154FF","stroke_width":1.0,"polyline":"hw{eFibbtZVIX]zCiHh@aBJcAA}@OkAUcAa@cBIs@E{@?m@D{@F{@P{ANeAHS?SLq@"},{"stroke_colour":"#440154FF","stroke_width":1.0,"polyline":"ty{eFyfbtZx@mBbAoCFOFYDQBS@MB[?M?QASC[AQG[k@_CIa@E]C[Ce@?[?e@Bc@Dc@z@wGBI"}]'

	## sf
	set_token("abc")
	m <- mapdeck()

	sf <- roads[1:2, ]
	p <- add_path(map = m, data = sf)
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), geo )

	## sfencoded
	enc <- googlePolylines::encode( sf )
	p <- add_path( map = m, data = enc )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## sfencodedLite
	enc <- googlePolylines::encode( sf, strip = T )
	p <- add_path( map = m, data = enc )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## data.frame with polyline
	df <- as.data.frame( enc )
	df$geometry <- unlist( df$geometry )

	p <- add_path( map = m, data = df, polyline = "geometry" )
	expect_equal( as.character( p$x$calls[[1]]$args[[1]] ), poly )

	## data.frame - not supported for LINESTRINGS
})
