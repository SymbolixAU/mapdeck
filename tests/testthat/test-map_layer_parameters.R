context("parameters")

test_that("check numeric works", {
	expect_error(mapdeck:::checkNumeric('a'))
	expect_silent(mapdeck:::checkNumeric(NULL))
	expect_error(mapdeck:::checkNumeric(1:2))
})

test_that("check palette works", {
	expect_error(mapdeck:::checkPalette('a'))
})



