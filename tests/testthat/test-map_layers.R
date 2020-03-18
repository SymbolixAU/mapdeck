context("map_layers")

test_that("layerId includes all layers", {

	# testthat::skip_on_travis()
	# testthat::skip_on_cran()
	# testthat::skip()
	#
	# layers <- c(
	# 	"arc"
	# 	, "bitmap"
	# 	, "column"
	# 	, "geojson"
	# 	, "greatcircle"
	# 	, "grid"
	# 	, "heatmap"
	# 	, "hexagon"
	# 	, "line"
	# 	, "mesh"
	# 	, "path"
	# 	, "pointcloud"
	# 	, "polygon"
	# 	, "scatterplot"
	# 	, "screengrid"
	# 	, "text"
	# 	, "title"
	# 	, "trips"
	# )
	#
	# # expect_equal( layers, mapdeck:::mapdeck_layers() )
	#
	# f <- list.files(path = system.file("./R", package = "mapdeck") )
	# f <- f[ grepl("map_layer_*", f) ]
	# f <- gsub("map_layer_", "", f)
	# f <- gsub("\\.R","",f)
	# f <- sort( f )
	# f <- setdiff(f, c("parameter_checks","sf"))
	#
	# expect_equal( f, sort( layers ) )
	#
	# res <- sapply( layers, function(x) { mapdeck:::layerId( layer_id = "test", layer = x) })
	# expect_equal( layers, names( res ) )

})


# test_that("layer_ids required", {
#
# 	df <- data.frame(
# 		origin = 1
# 		, destination = 2
# 		, lat_from = 1
# 		, lon_from = 1
# 		, lat_to = 2
# 		, lon_to = 2
# 		, polyline = 'a'
# 	)
# 	m <- mapdeck(token = 'abc')
# 	layer_error <- 'argument "layer_id" is missing, with no default'
#
# 	expect_error(
# 		add_arc(m, data = df, origin = c('lon_from', 'lat_from'), destination = c('lon_to', 'lat_to'))
# 		, layer_error
# 	)
# 	expect_error(
# 		add_geojson(m, data = df)
# 		, layer_error
# 	)
# 	expect_error(
# 		add_grid(m, data = df, lon = 'lon_from', lat = 'lat_from')
# 		, layer_error
# 	)
# 	expect_error(
# 		add_line(m, data = df, origin = c('lon_from', 'lat_from'), destination = c('lon_to', 'lat_to'))
# 		, layer_error
# 	)
# 	expect_error(
# 		add_path(m, data = df, polyline = 'polyline')
# 		, layer_error
# 	)
# 	expect_error(
# 		add_pointcloud(m, data = df, lon = 'lon_from', lat = 'lat_from')
# 		, layer_error
# 	)
# 	expect_error(
# 		add_polygon(m, data = df, polyline = 'polyline')
# 		, layer_error
# 	)
# 	expect_error(
# 		add_scatterplot(m, data = df, lon = 'lon_from', lat = 'lat_from')
# 		, layer_error
# 	)
# 	expect_error(
# 		add_screengrid(m, data = df, lon = 'lon_from', lat = 'lat_from')
# 		, layer_error
# 	)
# 	expect_error(
# 		add_text(m, data = df, text = 'polylne', polyline = 'polyline')
# 		, layer_error
# 	)
# })

test_that("layers are plotted", {

	df <- data.frame(
		origin = 1
		, destination = 2
		, lat_from = 1
		, lon_from = 1
		, lat_to = 2
		, lon_to = 2
		, polyline = 'a'
	)
	m <- mapdeck(token = 'abc')
	layer_id <- 'layer'

  layer <- add_arc(m, data = df, origin = c('lon_from', 'lat_from'), destination = c('lon_to', 'lat_to'), layer_id = layer_id)
  expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_geojson(m, data = geojson, layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_grid(m, data = df, lon = 'lon_from', lat = 'lat_from', layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_line(m, data = df, origin = c('lon_from', 'lat_from'), destination = c('lon_to', 'lat_to'), layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_path(m, data = df, polyline = 'polyline', layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_pointcloud(m, data = df, lon = 'lon_from', lat = 'lat_from', layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_polygon(m, data = df, polyline = 'polyline', layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_scatterplot(m, data = df, lon = 'lon_from', lat = 'lat_from', layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_screengrid(m, data = df, lon = 'lon_from', lat = 'lat_from', layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

	layer <- add_text(m, data = df, text = 'polyline', polyline = 'polyline', layer_id = layer_id)
	expect_true(all(attr(layer, 'class') == c("mapdeck","htmlwidget")))

})
