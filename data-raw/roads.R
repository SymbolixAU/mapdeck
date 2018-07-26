
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
roads <- as.data.frame(roads)
usethis::use_data(roads, overwrite = T)




