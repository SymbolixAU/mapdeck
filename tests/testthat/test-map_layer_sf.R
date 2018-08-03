context("sf")

test_that("sf POINT objects are plotted", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	library(sf)
	library(geojsonsf)

	pt1 <- sf::st_sf(geometry = sf::st_sfc(sf::st_point(x = c(1, 2))))
	pt2 <- sf::st_sf(geometry = sf::st_sfc(sf::st_point(x = c(3, 4))))
	sf <- rbind(pt1, pt2)

	## SCATTER
	key <- 'abc'
	m <- mapdeck(token = key) %>%
		add_scatterplot(data = sf, layer = "scatter")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

	## POINTCLOUD
	m <- mapdeck(token = key) %>%
		add_pointcloud(data = sf, layer = "cloud")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

	## GRID
	m <- mapdeck(token = key) %>%
		add_grid(data = sf, layer = "grid")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

	## SCREENGRID
	m <- mapdeck(token = key) %>%
		add_screengrid(data = sf, layer = "screen")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))


	### LINE (2 cols)
	sf <- cbind(sf, sf[2:1, ])

	m <- mapdeck(token = key) %>%
		add_line(
			data = sf
			, origin = 'geometry'
			, destination = 'geometry.1'
			, layer_id = "line"
			)

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('origin' %in% names(df))
	expect_true('destination' %in% names(df))

	### ARC (2 cols)
	m <- mapdeck(token = key) %>%
		add_arc(
			data = sf
			, origin = 'geometry'
			, destination = 'geometry.1'
			, layer_id = "line"
		)

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('origin' %in% names(df))
	expect_true('destination' %in% names(df))
})


test_that("sf MULTIPOINT objects are plotted", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	library(sf)
	library(geojsonsf)
	sf <- sf::st_sf(geometry = sf::st_sfc(sf::st_multipoint(x = matrix(1:4, ncol = 2))))

	## SCATTER
	key <- 'abc'
	m <- mapdeck(token = key) %>%
		add_scatterplot(data = sf, layer = "scatter")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

	## POINTCLOUD
	m <- mapdeck(token = key) %>%
		add_pointcloud(data = sf, layer = "cloud")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

	## GRID
	m <- mapdeck(token = key) %>%
		add_grid(data = sf, layer = "grid")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

	## SCREENGRID
	m <- mapdeck(token = key) %>%
		add_screengrid(data = sf, layer = "screen")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

})

test_that("sf LINESTRING objects are plotted", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	library(sf)
	library(geojsonsf)

	ls1 <- sf::st_sf(geometry = sf::st_sfc(sf::st_linestring(x = matrix(c(1:4), ncol = 2))))
	ls2 <- sf::st_sf(geometry = sf::st_sfc(sf::st_linestring(x = matrix(c(4:1), ncol = 2))))
	sf <- rbind(ls1, ls2)

	key <- 'abc'
	m <- mapdeck(token = key) %>%
		add_path(data = sf, layer = "path")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

})

test_that("sf MULTILINESTRING objects are plotted", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	library(sf)
	library(geojsonsf)

	ls1 <- sf::st_linestring(x = matrix(c(1:4), ncol = 2))
	ls2 <- sf::st_linestring(x = matrix(c(4:1), ncol = 2))
	sf <- sf::st_sf(geometry = sf::st_sfc(sf::st_multilinestring(x = list(ls1, ls2))))

	key <- 'abc'
	m <- mapdeck(token = key) %>%
		add_path(data = sf, layer = "path")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )

	expect_true(nrow(df) == 2)
	expect_true('polyline' %in% names(df))

})

test_that("sf POLYGON objects are plotted", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	library(sf)
	library(geojsonsf)

	sf <- sf::st_sf(geometry = sf::st_sfc(sf::st_polygon(x = list(matrix(c(-1,-1,1,-1,1,1,-1,1,-1,-1), byrow = T, ncol = 2)))))

	m <- mapdeck(token = 'abc') %>%
		add_polygon(data = sf, layer_id = "poly")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )
	expect_true(nrow(df) == 1)
	expect_true("polyline" %in% names(df))

})


test_that("sf MULTIPOLYGON objects are plotted", {

	testthat::skip_on_cran()
	testthat::skip_on_travis()

	library(sf)
	library(geojsonsf)

	pl1 <-sf::st_polygon(x = list(matrix(c(-1,-1,1,-1,1,1,-1,1,-1,-1), byrow = T, ncol = 2)))
	pl2 <- sf::st_polygon(x = list(matrix(c(-2,-2,2,-2,2,2,-2,2,-2,-2), byrow = T, ncol = 2)))

	sf <- sf::st_sf(geometry = sf::st_sfc(sf::st_multipolygon(x = list(pl1, pl2))))

	m <- mapdeck(token = 'abc') %>%
		add_polygon(data = sf, layer_id = "poly")

	df <- jsonlite::fromJSON( m$x$calls[[1]]$args[[1]] )
	expect_true(nrow(df) == 2)
	expect_true("polyline" %in% names(df))

})



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



