context("sf")

test_that("multi-column sf objects read correctly", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	library(sf)

	sf <- structure(list(geometry = structure(list(structure(c(1, 2), class = c("XY",
	"POINT", "sfg")), structure(c(3, 4), class = c("XY", "POINT",
	"sfg"))), precision = 0, bbox = structure(c(xmin = 1, ymin = 2,
	xmax = 3, ymax = 4), class = "bbox"), crs = structure(list(epsg = NA_integer_,
	proj4string = NA_character_), class = "crs"), n_empty = 0L, class = c("sfc_POINT",
	"sfc")), geometry.1 = structure(list(structure(c(3, 4), class = c("XY",
	"POINT", "sfg")), structure(c(1, 2), class = c("XY", "POINT",
	"sfg"))), precision = 0, bbox = structure(c(xmin = 1, ymin = 2,
	xmax = 3, ymax = 4), class = "bbox"), crs = structure(list(epsg = NA_integer_,
	proj4string = NA_character_), class = "crs"), n_empty = 0L, class = c("sfc_POINT",
  "sfc"))), row.names = 1:2, class = c("sf", "data.frame"), sf_column = "geometry", agr = structure(c(geometry.1 = NA_integer_), class = "factor", .Label = c("constant",
	"aggregate", "identity")))

	ept1 <- googlePolylines::encodeCoordinates(1, 2)
	ept2 <- googlePolylines::encodeCoordinates(3, 4)

	enc <- mapdeck:::normaliseMultiSfData( data = sf , origin = 'geometry', destination = 'geometry.1')

	expect_true(attr(enc, 'encoded_column') == "geometry.1")
	expect_true(all(names(enc) == c("geometry","geometry.1")) )
	expect_true(enc[1, 'geometry'][[1]] == enc[2, 'geometry.1'][[1]] )
	expect_true(enc[2, 'geometry'][[1]] == enc[1, 'geometry.1'][[1]] )
	expect_true(enc[1, 'geometry'][[1]] == ept1)
	expect_true(enc[2, 'geometry'][[1]] == ept2)

})


test_that("multipoints unlisted", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()


	sf <- structure(list(geometry = structure(list(structure(c(1, 2, 3,
	4), .Dim = c(2L, 2L), class = c("XY", "MULTIPOINT", "sfg"))), class = c("sfc_MULTIPOINT",
	"sfc"), precision = 0, bbox = structure(c(xmin = 1, ymin = 3,
	xmax = 2, ymax = 4), class = "bbox"), crs = structure(list(epsg = NA_integer_,
	proj4string = NA_character_), class = "crs"), n_empty = 0L),
	id = 1), row.names = 1L, sf_column = "geometry", agr = structure(c(id = NA_integer_), class = "factor", .Label = c("constant",
	"aggregate", "identity")), class = c("sf", "data.frame"))

  ## as per scatterplot
	data <- mapdeck:::normaliseSfData(sf, "POINT")
	polyline <- mapdeck:::findEncodedColumn(data, NULL)
  data <- mapdeck:::unlistMultiGeometry( data, polyline )

  expect_true(nrow(data) == 2)
  expect_true(unique(data$id) == 1)
  expect_true(data[1, 'geometry'] == googlePolylines::encodeCoordinates(1, 3))
  expect_true(data[2, 'geometry'] == googlePolylines::encodeCoordinates(2, 4))
})

test_that("multilinestring unlisted", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()


  sf <- structure(list(geometry = structure(list(structure(list(structure(c(1,
  3), .Dim = 1:2), structure(c(2, 4), .Dim = 1:2)), class = c("XY",
  "MULTILINESTRING", "sfg"))), class = c("sfc_MULTILINESTRING",
  "sfc"), precision = 0, bbox = structure(c(xmin = 1, ymin = 3,
  xmax = 2, ymax = 4), class = "bbox"), crs = structure(list(epsg = NA_integer_,
  proj4string = NA_character_), class = "crs"), n_empty = 0L),
  id = 1), row.names = 1L, sf_column = "geometry", agr = structure(c(id = NA_integer_), class = "factor", .Label = c("constant",
  "aggregate", "identity")), class = c("sf", "data.frame"))

  ## as per path
  data <- mapdeck:::normaliseSfData(sf, "LINESTRING")
  polyline <- mapdeck:::findEncodedColumn(data, NULL)
  data <- mapdeck:::unlistMultiGeometry( data, polyline )

  expect_true(nrow(data) == 2)
  expect_true(unique(data$id) == 1)
  expect_true(data[1, 'geometry'] == googlePolylines::encodeCoordinates(1, 3))
  expect_true(data[2, 'geometry'] == googlePolylines::encodeCoordinates(2, 4))

})



