# context("colours")
#
# test_that("generate palette methods are called", {
#
# 	dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
# 										val = letters[1:5],
# 										val2 = letters[11:15],
# 										cplx = complex(5),
# 										bool = c(rep(T, 3), rep(F, 2)),
# 										stringsAsFactors = F)
#
# 	## numeric
# 	expectedDf <- data.frame(variable = letters[1:5],
# 													 colour = mapdeck:::removeAlpha(viridisLite::viridis(5)),
# 													 stringsAsFactors = F)
#
# 	res <- mapdeck:::generatePalette(dat[, 'val'], viridisLite::viridis)
#
# 	expect_true(
# 		identical(
# 			expectedDf,
# 			res
# 		)
# 	)
#
# 	## logical
# 	tCols <- mapdeck:::removeAlpha(viridisLite::viridis(2))
# 	expectedDf <- data.frame(variable = c(T,F),
# 													 colour = tCols,
# 													 stringsAsFactors = F)
#
# 	res <- mapdeck:::generatePalette(dat[, 'bool'], viridisLite::viridis)
#
# 	expect_true(identical(expectedDf,res))
#
# 	## default called
# 	expect_true(
# 		mapdeck:::generatePalette(dat[, 'cplx'], viridisLite::viridis)$colour == "#440154"
# 	)
#
# })
#
# test_that("list of palettes correctly applied", {
#
# 	dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
# 										val = letters[1:5],
# 										val2 = letters[11:15],
# 										stringsAsFactors = F)
#
# 	lstPalette <- list(stroke_colour = viridisLite::viridis,
# 										 fill_colour = viridisLite::inferno)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = "val"))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")
#
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, lstPalette)
# 	createdColours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expect_true(nrow(createdColours[[1]]) == 5)
# 	expect_true(nrow(createdColours[[2]]) == 5)
#
# })
#
#
#
# test_that("columns of colours are correctly mapped to shape object", {
#
# 	## one-row data.frame
# 	dat <- data.frame(id = c(1),
# 										val = letters[1],
# 										val2 = letters[15],
# 										stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = NULL))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)
#
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expect_equal(lapply(colours, length),list(1))
#
# 	## one row data.frame, two colours
# 	dat <- data.frame(id = c(1),
# 										val = letters[1],
# 										val2 = letters[15],
# 										stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = "val"))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)
#
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expect_equal(lapply(colours, length),list(1, 1))
#
# 	dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
# 										val = letters[1:5],
# 										val2 = letters[11:15],
# 										stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = NULL))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)
#
# 	expectedColours <- mapdeck:::removeAlpha(viridisLite::viridis(2))
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expectedColours <- c(rep(expectedColours[1], 3), rep(expectedColours[2], 2))
#
# 	expect_true(sum(colours[[1]] == expectedColours) == 5)
#
# 	expect_equal(lapply(colours, length),list(5))
#
# 	## unordered data
# 	dat <- data.frame(id = c(rep(3,3), rep(2, 2)),
# 										val = letters[1:5],
# 										val2 = letters[11:15],
# 										stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = NULL))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)
#
# 	expectedColours <- mapdeck:::removeAlpha(viridisLite::viridis(2))
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expectedColours <- c(rep(expectedColours[2], 3), rep(expectedColours[1], 2))
#
# 	expect_true(sum(colours[[1]] == expectedColours) == 5)
#
# 	expect_equal(lapply(colours, length),list(5))
#
# 	dat <- data.frame(id = c(rep(3,3), rep(2, 2)),
# 										val = letters[1:5],
# 										val2 = letters[11:15],
# 										stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = "val"))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)
#
# 	expectedColours <- mapdeck:::removeAlpha(viridisLite::viridis(2))
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expectedColours <- c(rep(expectedColours[2], 3), rep(expectedColours[1], 2))
#
# 	expect_true(sum(colours[[1]] == expectedColours) == 5)
#
# 	expect_equal(lapply(colours, length),list(5, 5))
#
# })
#
#
#
# test_that("replace Variable colours extracts correct names", {
#
# 	## one variable used once
# 	dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
# 										val = letters[1:5],
# 										val2 = letters[11:15],
# 										stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = NULL))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = NULL)
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)
#
# 	expectedColours <- mapdeck:::removeAlpha(viridisLite::viridis(2))
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expect_true(sum(sapply(colours, colnames) == "stroke_colour") == 1)
#
# 	expectedDf <- data.frame(layer_id = dat$id,
# 													 stroke_colour = c(rep(expectedColours[1],3), rep(expectedColours[2], 2)),
# 													 stringsAsFactors = F)
#
# 	res <- mapdeck:::replaceVariableColours(shape, colours)
# 	expect_true(identical(res,expectedDf))
#
#
# 	## one variable used twice
# 	dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
# 										val = letters[1:5],
# 										val2 = letters[11:15],
# 										stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = "id"))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "id")
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)
#
# 	expectedColours <- mapdeck:::removeAlpha(viridisLite::viridis(2))
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expectedDf <- data.frame(layer_id = dat$id,
# 													 stroke_colour = c(rep(expectedColours[1],3), rep(expectedColours[2], 2)),
# 													 fill_colour = c(rep(expectedColours[1],3), rep(expectedColours[2], 2)),
# 													 stringsAsFactors = F)
#
# 	res <- mapdeck:::replaceVariableColours(shape, colours)
#
# 	expect_true(identical(expectedDf,res))
#
# 	## two variables used once each
# 	dat <- data.frame(id = c(rep(1,3), rep(2, 2)),
# 										val = letters[1:5],
# 										val2 = letters[11:15],
# 										stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "id", fill_colour = "val"))
# 	shape <- mapdeck:::createMapObject(dat, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'id', "fill_colour" = "val")
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(dat, pal, colourColumns, viridisLite::viridis)
#
# 	expectedIdColours <- mapdeck:::removeAlpha(viridisLite::viridis(2))
# 	expectedValColours <- mapdeck:::removeAlpha(viridisLite::viridis(5))
#
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	expectedDf <- data.frame(layer_id = dat$id,
# 													 stroke_colour = c(rep(expectedIdColours[1],3), rep(expectedIdColours[2], 2)),
# 													 fill_colour = expectedValColours,
# 													 stringsAsFactors = F)
#
# 	res <- mapdeck:::replaceVariableColours(shape, colours)
#
# 	expect_true(identical(expectedDf,res))
#
# })
#
#
# test_that("colour palette names created", {
#
# 	## don't create palettes if the column is a hex colour
# 	shape <- data.frame(id = 1:5,
# 											val = letters[1:5],
# 											val2 = letters[11:15],
# 											stringsAsFactors = F)
#
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "val", fill_colour = "val2"))
# 	shape <- mapdeck:::createMapObject(shape, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'val', "fill_colour" = NULL)
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
#
# 	expect_true(pal == c("stroke_colour" = "val"))
#
# 	colourColumns <- c("stroke_colour" = 'val', "fill_colour" = "val2")
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
#
# 	expect_true(sum(pal == c("stroke_colour" = "val", "fill_colour" = "val2")) == 2)
#
# })
#
#
# test_that("palettes generated", {
#
# 	data <- data.frame(id = 1:5,
# 										 val = letters[1:5],
# 										 val2 = letters[11:15],
# 										 stringsAsFactors = F)
#
# 	## one palette for one variable
# 	allCols <- c("id", "val", "val2")
# 	objArgs <- quote(add_polygon(layer_id = "id", stroke_colour = "val", fill_colour = "val2"))
# 	shape <- mapdeck:::createMapObject(data, allCols, objArgs)
#
# 	colourColumns <- c("stroke_colour" = 'val', "fill_colour" = NULL)
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(data, pal, colourColumns, viridisLite::viridis)
#
# 	expect_true(length(colour_palettes) == 1)
# 	expect_true(sum(colour_palettes[[1]]$variables == c("val")) == 1)
#
# 	## one palette for the same variable used twice
# 	colourColumns <- c("stroke_colour" = 'val', "fill_colour" = "val")
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(data, pal, colourColumns, viridisLite::viridis)
#
# 	expect_true(sum(colour_palettes[[1]]$variables == c("val", "val")) == 2)
# 	expect_true(length(colour_palettes) == 1)
#
# 	## two palettes for two variables
# 	colourColumns <- c("stroke_colour" = 'val', "fill_colour" = "val2")
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
# 	colour_palettes <- mapdeck:::createColourPalettes(data, pal, colourColumns, viridisLite::viridis)
#
# 	expect_true(length(colour_palettes) == 2)
#
# 	expect_true(colour_palettes[[1]]$variables == c("val"))
#
# 	expect_true(colour_palettes[[2]]$variables == c("val2"))
#
# })
#
# test_that("hexcolour validation", {
#
# 	expect_true(mapdeck:::isHexColour("#0") == FALSE)
# 	expect_true(mapdeck:::isHexColour("#00") == FALSE)
# 	expect_true(mapdeck:::isHexColour("#00000") == FALSE)
# 	expect_true(mapdeck:::isHexColour("#0000000") == FALSE)
# 	expect_true(mapdeck:::isHexColour("#000000000") == FALSE)
#
# 	expect_true(mapdeck:::isHexColour("#000") == TRUE)
# 	expect_true(mapdeck:::isHexColour("#0000") == TRUE)
# 	expect_true(mapdeck:::isHexColour("#000000") == TRUE)
# 	expect_true(mapdeck:::isHexColour("#00000000") == TRUE)
#
# })
#
#
# test_that("RGBA colours remove alpha", {
#
# 	expect_true(
# 		identical(
# 			mapdeck:::removeAlpha(c("#000000FF", "#FFFFFF00")),
# 			c("#000000", "#FFFFFF")
# 		)
# 	)
#
# 	## alpha not removed
# 	expect_true(
# 		identical(
# 			mapdeck:::removeAlpha(c("#FFFFFF", "#000000")),
# 			c("#FFFFFF", "#000000")
# 		)
# 	)
#
# })
#
#
# test_that("generate palette works on all data types", {
#
# 	## TODO:
# 	## - floats
# 	## - characters
#
# 	## LOGICAL
# 	vals <- c(T, T, F, F)
# 	colours <- viridisLite::viridis(2)
# 	df <- mapdeck:::generatePalette(vals, viridisLite::viridis)
#
# 	expect_true(
# 		identical(
# 			df[, 'colour'],
# 			mapdeck:::removeAlpha(colours)
# 		)
# 	)
#
# 	## INTEGER
# 	vals <- 1L:5L
# 	colours <- viridisLite::viridis(5)
# 	df <- mapdeck:::generatePalette(vals, viridisLite::viridis)
#
# 	expect_true(
# 		identical(
# 			df[, 'colour'],
# 			mapdeck:::removeAlpha(colours)
# 		)
# 	)
#
# 	## NUMERIC
# 	vals <- 1.1:5.1
# 	colours <- viridisLite::viridis(5)
# 	df <- mapdeck:::generatePalette(vals, viridisLite::viridis)
#
# 	expect_true(
# 		identical(
# 			df[, 'colour'],
# 			mapdeck:::removeAlpha(colours)
# 		)
# 	)
#
#
# 	## FACTORS
# 	vals <- as.factor(letters[1:5])
# 	colours <- viridisLite:::viridis(5)
# 	df <- mapdeck:::generatePalette(vals, viridisLite::viridis)
#
# 	expect_true(
# 		identical(
# 			df[, 'colour'],
# 			mapdeck:::removeAlpha(colours)
# 		)
# 	)
#
# })
#
# test_that("correct palette is determined", {
#
# 	pal <- list(fill_colour = viridisLite::inferno,
# 							stroke_colour = viridisLite::viridis)
#
# 	v <- mapdeck:::determinePalette(pal, 'fill_colour')
#
# 	expect_true(v(1) == "#000004FF")
#
# 	v <- mapdeck:::determinePalette(pal, 'stroke_colour')
# 	expect_true(v(1) == "#440154FF")
#
# })
#
#
# test_that("variables mapped to correct colour", {
#
# 	## FACTORS
# 	vals <- as.factor(letters[c(5,3,1,2,4)])
# 	colours <- viridisLite:::viridis(5)
#
# 	df <- mapdeck:::generatePalette(vals, viridisLite::viridis)
#
# 	expect_true(
# 		## element-wise matching of colours
# 		sum(df[, 'colour'] == mapdeck:::removeAlpha(colours)) == 5
# 	)
#
# 	## NUMERIC
# 	vals <- c(5, 3, 1, 2, 4)
# 	colours <- viridisLite::viridis(5)
#
# 	df <- mapdeck:::generatePalette(vals, viridisLite::viridis)
#
# 	expect_true(
# 		## element-wise matching of colours
# 		sum(df[, 'colour'] == mapdeck:::removeAlpha(colours)) == 0
# 	)
#
# 	expect_true(
# 		sum(df[ with(df, order(vals)) , 'colour'] == mapdeck:::removeAlpha(colours)) == 5
# 	)
#
# })
#
#
# test_that("data frame of colours is created",{
#
# 	df <- data.frame(variable = 1:5, colour = "#000000", stringsAsFactors = F)
# 	expect_true(
# 		identical(df, mapdeck:::constructPalette(1:5, "#000000"))
# 	)
# })
