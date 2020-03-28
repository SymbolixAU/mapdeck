context("colours")

test_that("check hex works", {
	expect_false(mapdeck:::isHexColour('#a'))
	expect_false(mapdeck:::isHexColour("#ab"))
	expect_true(mapdeck:::isHexColour("#abc"))
	expect_true(mapdeck:::isHexColour('#abc1'))
	expect_false(mapdeck:::isHexColour('#abc12'))
	expect_true(mapdeck:::isHexColour('#abc123'))

	expect_equal(mapdeck:::appendAlpha("#a"), "#a" ) ## not valid
	expect_equal(mapdeck:::appendAlpha("#ab"), "#ab")
	expect_equal(mapdeck:::appendAlpha("#abc"), "#abcF")
	expect_equal(mapdeck:::appendAlpha('#abc1'), "#abc1")
	expect_equal(mapdeck:::appendAlpha('#abc12'), "#abc12")
	expect_equal(mapdeck:::appendAlpha('#abc123'), "#abc123FF")

})
