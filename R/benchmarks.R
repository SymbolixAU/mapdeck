#
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
# n <- 1e6
# df <- data.frame(
# 	#	id = sample(letters[1:10], size = 26, replace = T)
# 	id = 1:n
# 	#	id = seq(as.Date("2018-01-01"), as.Date("2018-01-26"), by = 1)
# 	#	id = as.factor(1:26)
# 	, lon = sample(-180:180, size = n, replace = T)
# 	, lat = sample(-90:90, size = n, replace = T)
# 	, polyline = sample(letters, size = n, replace = T)
# 	, r = 1:n
# 	, s = rnorm(n)
# 	, stringsAsFactors = F
# )
#
# library(microbenchmark)
#
# microbenchmark(
# 	one = {
# 		res <- test_scatterplot(
# 			data = df
# 			, lat = "lat"
# 			, lon = "lon"
# 			#, polyline = "polyline"     ## force through
# 			, radius = 100000
# 			, fill_colour = "id"
# 			, tooltip = "id"
# 		)
#   },
#
#   two = {
#   	res2 <- test_scatterplot2(
# 			data = df
# 			, lat = "lat"
# 			, lon = "lon"
# 			, polyline = "polyline"     ## force through
# 			, radius = 100000
# 			, fill_colour = "id"
# 			, tooltip = "id"
# 		)
#   },
# 	times = 5
# )
#
# # Unit: seconds
# # expr        min         lq       mean     median         uq        max neval
# # one 215.594935 217.604062 222.888764 219.810418 223.967136 237.467271     5
# # two   1.575554   1.614204   1.731736   1.654544   1.773606   2.040773     5
#
