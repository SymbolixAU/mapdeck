
### SCATTER
# key <- read.dcf("~/Documents/.googleAPI", fields= "MAPBOX")

# library(mongolite)
# library(sf)
# library(geojsonsf)
# m <- symbolix.utils::connectToMongo(db = "ABS", collection = "SA2_2016", usr = "db_user")
# m <- mongo(db = "ABS", collection = "SA2_2016")
# geo <- m$find(query = '{"geometry":{"$ne":null}}', ndjson = T)
# sf <- geojsonsf::geojson_sf(geo)
#
# sf$fillColor <- sample(letters, size = nrow(sf), replace = T)
#
# df <- as.data.frame(sf::st_coordinates(sf[sf$STE_NAME16 == "Victoria", ]))
# head(df)
# nrow(df)
# df$colour <- sample(letters, size = nrow(df), replace = T)
#
# mapdeck(
# 	token = key
# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	) %>%
# 	add_scatterplot(
# 		data = df[, ]
# 		, lat = "Y"
# 		, lon = "X"
# 		, fill_colour = "colour"
# 	)
#
# mapdeck(token = key) %>%
# 	add_scatterplot(data = df[1:50000, ], fill_colour = "colour", lat = "lat", lon = "lon",
# 									radius = "radius")



## Geojson
# library(mongolite)
# library(sf)
# library(geojsonsf)
# m <- symbolix.utils::connectToMongo(db = "ABS", collection = "SA2_2016", usr = "db_user")
# m <- mongo(db = "ABS", collection = "SA2_2016")
# geo <- m$find(query = '{"geometry":{"$ne":null}}', ndjson = T)
# sf <- geojsonsf::geojson_sf(geo)
#
#s f$fillColor <- viridisLite::viridis(n = nrow(sf))
#
# geo <- sf_geojson(sf[sf$STE_NAME16 == "Victoria",])
# geo <- sf_geojson(sf[sf$SA3_NAME16 == "Perth City", ])
# geo <- sf_geojson(sf[1:100, ])
# attr(geo, 'class') <- 'json'
#
# mapdeck(token = key, style = 'mapbox://styles/mapbox/dark-v9') %>%
# 	add_geojson(data = geo)

## using encoded polyline and various colour / fill options
# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
#
# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
# 	add_arc(
# 		data = flights
# 		, lat_from = "start_lat"
# 		, lon_from = "start_lon"
# 		, lat_to = "end_lat"
# 		, lon_to = "end_lon"
# 		, stroke_from = "airport1"
# 		, stroke_to = "airport2"
# 		, stroke_width = "stroke"
# 	)

### PATH

# df <- googleway::tram_route
# head(df)
# df$id <- 1
#
# df <- data.frame( polyline = googlePolylines:::encodeCoordinates(lon = df$shape_pt_lon, lat = df$shape_pt_lat) )
#
# key <- read.dcf("~/Documents/.googleAPI", fields= "MAPBOX")
#
#
# df$col <- "a"
# df$width <- 3
# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9' ) %>%
# 	add_path(
# 		data = df
# 		, polyline = "polyline"
# 		, stroke_colour = "col"
# 		, stroke_width = "width"
# 		)

## TODO: multiple layers
## scatter + path

# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9' ) %>%
# 	add_path(
# 		data = df
# 		, polyline = "polyline"
# 		, stroke_colour = "col"
# 		, stroke_width = "width"
# 	) %>%
# 		add_scatterplot(
# 			data = googleway::tram_stops
# 			, lat = "stop_lat"
# 			, lon = "stop_lon"
# 			, fill_colour = "stop_id"
# 			, radius = 30
# 			, fill_opacity = 0.2
# 		)







