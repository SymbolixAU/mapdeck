context("mapdeck_base")

test_that("mapdeck implentations of base functions work", {

	set.seed(12345)
	x <- sample(1:5, size = 10, replace = T)
	expect_equal(diff(x), mapdeck:::rcpp_diff(x))
	expect_equal(range(x), mapdeck:::rcpp_range(x))
	expect_equal(sort(scales::rescale(x)), sort(mapdeck:::rcpp_rescale(x)))
	expect_equal(sort(unique(x)), sort(mapdeck:::rcpp_unique(x)))
	expect_equal(seq(1,10,length.out = 50), mapdeck:::rcpp_seq(1,10,50))

})
