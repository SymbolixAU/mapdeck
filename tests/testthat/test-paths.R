context("paths")


test_that("multilinestrings parsed", {

	polylines <- list(c("abc","cde","fgh"),c("xyz","zyx"),c("pqr"))
	df <- data.frame(id = 1:3, val = letters[1:3])
	df$polyline <- polylines

	df_res <- mapdeck:::unlistMultiGeometry( df, 'polyline' )

	expect_true(all(df_res$polyline == unlist(polylines)))
	expect_true(all(df_res$val == c("a","a","a","b","b","c")))

})
