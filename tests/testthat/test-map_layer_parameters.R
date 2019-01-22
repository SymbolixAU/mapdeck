context("parameters")


test_that("check hex works", {
  expect_false(mapdeck:::isHexColour('#a'))
	expect_false(mapdeck:::isHexColour("#ab"))
	expect_true(mapdeck:::isHexColour("#abc"))
	expect_true(mapdeck:::isHexColour('#abc1'))
	expect_false(mapdeck:::isHexColour('#abc12'))
	expect_true(mapdeck:::isHexColour('#abc123'))
})

test_that("check numeric works", {
	expect_error(mapdeck:::checkNumeric('a'))
	expect_silent(mapdeck:::checkNumeric(NULL))
	expect_error(mapdeck:::checkNumeric(1:2))
})

test_that("check palette works", {
	expect_error(mapdeck:::checkPalette('a'))
})



