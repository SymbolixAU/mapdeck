context("clearlayers")

test_that("layers are cleared", {

	key <- 'abc'
	m <- mapdeck(token = key)
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
	lx <- function(layer) paste0(layer, "-defaultLayerId")

	layer <- add_arc(m, data = df, origin = c('lon_from', 'lat_from'), destination = c('lon_to', 'lat_to'), layer_id = layer_id)
	layer <- clear_arc( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('arc') )

	layer <- add_geojson(m, data = geojson, layer_id = layer_id)
	layer <- clear_geojson( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('geojson') )

	layer <- add_grid(m, data = df, lon = 'lon_from', lat = 'lat_from', layer_id = layer_id)
	layer <- clear_grid( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('grid') )

	layer <- add_line(m, data = df, origin = c('lon_from', 'lat_from'), destination = c('lon_to', 'lat_to'), layer_id = layer_id)
	layer <- clear_line( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('line') )

	layer <- add_path(m, data = df, polyline = 'polyline', layer_id = layer_id)
	layer <- clear_path( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('path') )

	layer <- add_pointcloud(m, data = df, lon = 'lon_from', lat = 'lat_from', layer_id = layer_id)
	layer <- clear_pointcloud( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('pointcloud') )

	layer <- add_polygon(m, data = df, polyline = 'polyline', layer_id = layer_id)
	layer <- clear_polygon( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('polygon') )

	layer <- add_scatterplot(m, data = df, lon = 'lon_from', lat = 'lat_from', layer_id = layer_id)
	layer <- clear_scatterplot( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('scatterplot') )

	layer <- add_screengrid(m, data = df, lon = 'lon_from', lat = 'lat_from', layer_id = layer_id)
	layer <- clear_screengrid( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('screengrid') )

	layer <- add_text(m, data = df, text = 'polyline', polyline = 'polyline', layer_id = layer_id)
	layer <- clear_text( layer )
	expect_true( layer$x$calls[[2]]$functions[[1]] == "md_layer_clear" )
	expect_true( layer$x$calls[[2]]$args[[1]] == lx('text') )


})
