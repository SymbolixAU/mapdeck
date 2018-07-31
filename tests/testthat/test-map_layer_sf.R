context("sf")

test_that("multi-column sf objects read correctly", {

	# library(sf)
	# pt1 <- sf::st_sf(geometry = sf::st_sfc(sf::st_point(c(1,2))))
	# pt2 <- sf::st_sf(geometry = sf::st_sfc(sf::st_point(c(3,4))))
	# sf <- rbind(pt1, pt2)
	# sf2 <- rbind(pt2, pt1)
	# sf <- cbind(sf, sf2)

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





