# #
# test_scatterplot <- function(
# 	map,
# 	data = get_map_data(map),
# 	lon = NULL,
# 	lat = NULL,
# 	polyline = NULL,
# 	radius = NULL,
# 	fill_colour = NULL,
# 	fill_opacity = NULL,
# 	tooltip = NULL,
# 	auto_highlight = FALSE,
# 	layer_id = NULL,
# 	digits = 6,
# 	palette = viridisLite::viridis
# ) {
#
# 	objArgs <- match.call(expand.dots = F)
#
# 	data <- mapdeck:::normaliseSfData(data, "POINT")
# 	polyline <- mapdeck:::findEncodedColumn(data, polyline)
#
# 	if( !is.null(polyline) && !polyline %in% names(objArgs) ) {
# 		objArgs[['polyline']] <- polyline
# 		data <- mapdeck:::unlistMultiGeometry( data, polyline )
# 	}
#
# 	## parmater checks
# 	usePolyline <- mapdeck:::isUsingPolyline(polyline)
# 	mapdeck:::checkNumeric(digits)
# 	mapdeck:::checkPalette(palette)
# 	layer_id <- mapdeck:::layerId(layer_id, "scatterplot")
# 	## TODO(logical check auto_highlight)
#
# 	## end parameter checks
# 	if ( !usePolyline ) {
# 		## TODO(check only a data.frame)
# 		data[['polyline']] <- googlePolylines::encode(data, lon = lon, lat = lat, byrow = TRUE)
# 		polyline <- 'polyline'
# 		## TODO(check lon & lat exist / passed in as arguments )
# 		objArgs[['lon']] <- NULL
# 		objArgs[['lat']] <- NULL
# 		objArgs[['polyline']] <- polyline
# 	}
#
# 	allCols <- mapdeck:::scatterplotColumns()
# 	requiredCols <- mapdeck:::requiredScatterplotColumns()
#
# 	colourColumns <- mapdeck:::shapeAttributes(
# 		fill_colour = fill_colour
# 		, stroke_colour = NULL
# 		, stroke_from = NULL
# 		, stroke_to = NULL
# 	)
#
# 	shape <- mapdeck:::createMapObject(data, allCols, objArgs)
#
# 	pal <- mapdeck:::createPalettes(shape, colourColumns)
#
# 	colour_palettes <- mapdeck:::createColourPalettes(data, pal, colourColumns, palette)
# 	colours <- mapdeck:::createColours(shape, colour_palettes)
#
# 	if(length(colours) > 0){
# 		shape <- mapdeck:::replaceVariableColours(shape, colours)
# 	}
#
# 	requiredDefaults <- setdiff(requiredCols, names(shape))
#
# 	if(length(requiredDefaults) > 0){
# 		shape <- mapdeck:::addDefaults(shape, requiredDefaults, "scatterplot")
# 	}
# 	return( shape )
# }
#
#
#
# test_scatterplot2 <- function(
# 	map,
# 	data = get_map_data(map),
# 	lon = NULL,
# 	lat = NULL,
# 	polyline = NULL,
# 	radius = NULL,
# 	fill_colour = NULL,
# 	fill_opacity = NULL,
# 	tooltip = NULL,
# 	auto_highlight = FALSE,
# 	layer_id = NULL,
# 	digits = 6,
# 	palette = viridisLite::viridis
# ) {
#
# 	l <- as.list( match.call() )
# 	data$polyline <- googlePolylines::encode(data, lon = lon, lat = lat, byrow = T)
# 	shape <- mapdeck:::rcpp_scatterplot(data, l)
# 	return( shape )
# }
#
#
#
# lons <- seq(-180, 180, by = 0.0001)
# lats <- seq(-90, 90, by = 0.0001)
#
# n <- 1e5
# df <- data.frame(
# 	#	id = sample(letters[1:10], size = 26, replace = T)
# 	id = 1:n
# 	#	id = seq(as.Date("2018-01-01"), as.Date("2018-01-26"), by = 1)
# 	#	id = as.factor(1:26)
# 	, lon = sample(lons, size = n, replace = T)
# 	, lat = sample(lats, size = n, replace = T)
# 	#, polyline = sample(letters, size = n, replace = T)
# 	, r = 1:n
# 	, s = rnorm(n)
# 	, stringsAsFactors = F
# )
#
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# m <- mapdeck::mapdeck()
# library(microbenchmark)
#
# microbenchmark(
# 	old = {
# 		old <- add_scatterplot_old(
# 			map = m
# 			, data = df
# 			, lat = "lat"
# 			, lon = "lon"
# 			, radius = 1000
# 			, fill_colour = "id"
# 			, fill_opacity = "id"
# 			, tooltip = "id"
# 		)
#   },
#
#   new = {
#   	new <- add_scatterplot(
#   		map = m
#   		, data = df
#   		, lat = "lat"
#   		, lon = "lon"
#   		, radius = 1000
#   		, fill_colour = "id"
#   		#, fill_opacity = "id"
#   		, tooltip = "id"
#   	)
#   },
# 	times = 5
# )

# Unit: seconds
# expr       min        lq      mean    median        uq       max neval
#  one 71.439725 71.945582 74.644004 73.121869 76.494151 80.218691     5
#  two  4.018393  4.277548  4.302488  4.295433  4.350198  4.570869     5

## with jsonify
# Unit: seconds
# expr       min        lq     mean    median        uq       max neval
# old 77.033577 77.695166 77.88357 77.887395 77.968052 78.833664     5
# new  3.581377  3.682539  3.94304  4.018411  4.170176  4.262699     5


# system.time({
# 	p <- add_scatterplot2(
# 		map = m
# 		, data = df
# 		, lat = "lat"
# 		, lon = "lon"
# 		, polyline = "polyline"
# 		, radius = 1000
# 		, fill_colour = "id"
# 		#, fill_opacity = "id"
# 		, tooltip = "id"
# 	)
# })
# p
#
# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
#
# sf <- rbind(roads, roads, roads)
#
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# m <- mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, location = c(145, -37.8)
# 	, zoom = 10)
#
# library(microbenchmark)
#
# sf$n <- 1:nrow(sf)
# roads$n <- 1:nrow(roads)
#
# microbenchmark(
# 	old = {
# 		p1 <- add_path_old(
# 			map = m
# 			, data = sf
# 		  , stroke_colour = "RIGHT_LOC"
# 		  , layer_id = "path_layer"
# 		  , tooltip = "RIGHT_LOC"
# 		  #, auto_highlight = TRUE
# 		)
# 	},
#
# 	new = {
		# p2 <- add_path(
		# 	map = m
		#   , data = sf
		#   , stroke_colour = "n"
		#   , layer_id = "path_layer"
		#   , tooltip = "RIGHT_LOC"
		#   #, auto_highlight = TRUE
		#  )
# 	},
# 	times = 3
# )


# lons <- seq(-180, 180, by = 0.0001)
# lats <- seq(-90, 90, by = 0.0001)
#
# n <- 1e4
# df <- data.frame(
# 	#	id = sample(letters[1:10], size = 26, replace = T)
# 	id = 1:n
# 	#	id = seq(as.Date("2018-01-01"), as.Date("2018-01-26"), by = 1)
# 	#	id = as.factor(1:26)
# 	, lon = sample(lons, size = n, replace = T)
# 	, lat = sample(lats, size = n, replace = T)
# 	#, polyline = sample(letters, size = n, replace = T)
# 	, r = 1:n
# 	, s = rnorm(n)
# 	, stringsAsFactors = F
# )
#
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# m <- mapdeck::mapdeck()
# library(microbenchmark)
#
# microbenchmark(
# 	old = {
# 		old <- add_pointcloud_old(
# 			map = m
# 			, data = df
# 			, lat = "lat"
# 			, lon = "lon"
# 			, radius = 1000
# 			, fill_colour = "id"
# 			#, fill_opacity = "id"
# 			, tooltip = "id"
# 		)
#   },
#
#   new = {
#   	new <- add_pointcloud(
#   		map = m
#   		, data = df
#   		, lat = "lat"
#   		, lon = "lon"
#   		, radius = 1000
#   		, fill_colour = "id"
#   		#, fill_opacity = "id"
#   		, tooltip = "id"
#   	)
#   },
# 	times = 5
# )



# library(sf)
# library(geojsonsf)
#
# sf <- geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
# sf <- sf::st_cast(sf, "POLYGON")
#
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# m <- mapdeck::mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, location = c(144.5, -37)
# 	, zoom = 5)
#
# library(microbenchmark)
#
# sf <- rbind(sf, sf, sf, sf, sf, sf)
# sf <- rbind(sf, sf, sf, sf, sf)
# sf <- rbind(sf, sf, sf)
# # sf <- rbind(sf, sf, sf, sf, sf)
#
# sf$n <- 1:nrow(sf)
#
# microbenchmark(
# 	old = {
# 		p <- add_polygon_old(
# 			map = m
# 			, data = sf
# 			, layer = "polygon_layer"
# 			, fill_colour = "n"
# 		)
# 	},
# 	new = {
# 		p <- add_polygon(
# 			map = m
# 			, data = sf
# 			, layer = "polygon_layer"
# 			, fill_colour = "n"
# 		)
# 	},
# 	times = 3
# )
#
#
# enc <- googlePolylines::encode( sf )
# head( enc )
#
# microbenchmark(
#   jsonlite = { js1 <- jsonlite::toJSON( enc ) },
#   jsonify = { js2 <- jsonify::to_json( enc ) },
#   times = 5
# )

