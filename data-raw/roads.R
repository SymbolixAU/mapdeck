
library(mongolite)
library(geojsonsf)
library(sf)
library(googlePolylines)

m <- mongo(collection = "roads", db = "roads")
geo <- m$find(ndjson = T)

sf <- geojsonsf::geojson_sf( geo )

enc <- encode(sf)

roads <- enc[, c("RIGHT_LOC", "ROAD_NAME", "ROAD_TYPE", "geometry")]

r <- unlist(roads$geometry)
roads$geometry <- r

roads <- roads[1:10000, ]
usethis::use_data(roads)

# mapdeck(
# 	token = key
# 	, style = 'mapbox://styles/mapbox/dark-v9'
# 	, location = c(145.688269, -38.101062)
# 	, zoom = 8) %>%
# 	add_path(
# 		data = roads[1:10000, ]
# 		, polyline = "geometry"
# 		, stroke_colour = "RIGHT_LOC"
# 	)


