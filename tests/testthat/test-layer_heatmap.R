context("heatmap")


test_that("empty data doesn't crash",{
	## issue 252
	m <- mapdeck()
	res <- mapdeck::add_heatmap(map = m, data = data.frame())
	expect_true( res$x$calls[[1]]$functions == "md_layer_clear" )
})
