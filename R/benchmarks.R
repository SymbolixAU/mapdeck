### SCATTERPLOT
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
#   		, fill_opacity = "id"
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
# 		p2 <- add_path(
# 			map = m
# 		  , data = sf
# 		  , stroke_colour = "RIGHT_LOC"
# 		  , layer_id = "path_layer"
# 		  , tooltip = "RIGHT_LOC"
# 		  #, auto_highlight = TRUE
# 		 )
# 	},
# 	times = 3
# )

### POINTCLOUD
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
# 	, l = sample(letters, size = n, replace = T)
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
# 	},
#
# 	new = {
# 		new <- add_pointcloud(
# 			map = m
# 			, data = df
# 			, lat = "lat"
# 			, lon = "lon"
# 			, radius = 1000
# 			, fill_colour = "id"
# 			#, fill_opacity = "id"
# 			, tooltip = "id"
# 		)
# 	},
# 	times = 5
# )
#
# # n <- 1e5
# # fill_colour = 'id'
# # Unit: milliseconds
# # expr       min        lq      mean    median        uq       max neval
# # old 7485.5636 7686.8731 7859.4077 7946.2620 8040.5643 8137.7754     5
# # new  251.0061  268.0089  381.0152  393.0107  493.9947  499.0555     5
#
# # fill_colour = 'l'
# # Unit: milliseconds
# # expr      min       lq     mean   median       uq      max neval
# # old 258.9929 320.5041 386.6248 358.1111 448.0709 547.4450     5
# # new 173.4745 183.2885 202.0799 188.7792 225.8983 238.9591     5

### POLYGON
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
# #sf <- rbind(sf, sf, sf, sf, sf)
# #sf <- rbind(sf, sf, sf)
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
# 	p <- add_polygon(
# 		map = m
# 		, data = sf
# 		, layer = "polygon_layer"
# 		, fill_colour = "n"
# 	)
# 	},
# 	times = 3
# )

# nrow(sf)
# 554400

# fill_colour == 'n'
# Unit: seconds
# expr       min        lq      mean    median        uq       max neval
#  old 11.393775 11.477723 11.784519 11.561671 11.979890 12.398110     3
#  new  6.250752  6.369782  6.427707  6.488813  6.516184  6.543555     3

# fill_colour = "SA2_NAME16"
# Unit: seconds
# expr      min       lq     mean   median       uq      max neval
# old 7.850554 7.933001 8.099077 8.015448 8.223339 8.431231     3
# new 6.226209 6.281467 6.315807 6.336725 6.360606 6.384487     3
#
# enc <- googlePolylines::encode( sf )
# head( enc )
#
# microbenchmark(
#   jsonlite = { js1 <- jsonlite::toJSON( enc ) },
#   jsonify = { js2 <- jsonify::to_json( enc ) },
#   times = 5
# )

# n <- 1e6
# df <- data.frame(
# 	numbers = rep(1:26,n)
# 	, letters = rep(letters, n)
# )
# library(microbenchmark)
# microbenchmark(
# 	numbers = { colourvalues::colour_values(df$numbers) },
# 	letters = { colourvalues::colour_values(df$letters) },
# 	times = 5
# )
# Unit: seconds
# expr      min       lq     mean   median       uq      max neval
# numbers 4.460924 4.466449 4.542446 4.480527 4.488406 4.815922     5
# letters 4.465812 4.467152 4.490861 4.479849 4.508244 4.533247     5

### LINE
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# m <- mapdeck::mapdeck()
# library(microbenchmark)
#
# microbenchmark(
# 	old = {
# 		old <- add_line_old(
# 			map = m
# 			,	data = flights
# 			, layer_id = "line_layer"
# 			, origin = c("start_lon", "start_lat")
# 			, destination = c("end_lon", "end_lat")
# 			, stroke_colour = "cnt"
# 			, stroke_width = "stroke"
# 			, auto_highlight = TRUE
# 			, legend = TRUE
# 		)
#   },
#
#   new = {
#   	new <- add_line(
#   		map = m
#   		, data = flights
#   		, layer_id = "line_layer"
#   		, origin = c("start_lon", "start_lat")
#   		, destination = c("end_lon", "end_lat")
#   		, stroke_colour = "cnt"
#   		, stroke_width = "stroke"
#   		, auto_highlight = TRUE
#   		, legend = TRUE
#   	)
#   },
# 	times = 5
# )
#
# # Unit: milliseconds
# # expr       min        lq      mean    median        uq        max neval
# # old 17.486042 17.636939 64.697349 19.485457 57.684504 211.193804     5
# # new  1.070719  1.106256  1.127582  1.127063  1.146071   1.187801     5




# library(microbenchmark)
# library(colourvalues)
# library(sf)
# library(geojsonsf)
#
# sf <- geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
# sf <- sf::st_cast(sf, "POLYGON")
#
# sf <- rbind(sf, sf, sf, sf, sf, sf)
# sf <- rbind(sf, sf, sf, sf, sf)
# sf$n <- 1:nrow(sf)
#
# microbenchmark(
#   numeric = { colourvalues::color_values(sf$n, n_summaries = 5)},
#   category = { colourvalues::colour_values(sf$SA2_NAME16, summary = T)},
#   times = 5
# )


## ARC
# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
# flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#
# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#   add_arc(
#   data = flights
#   , layer_id = "arc_layer"
#   , origin = c("start_lon", "start_lat")
#   , destination = c("end_lon", "end_lat")
#   , stroke_from = "airport1"
#   , stroke_to = "airport2"
#   , stroke_width = "stroke"
#   , tooltip = "info"
#   , auto_highlight = TRUE
#  )
