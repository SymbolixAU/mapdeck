
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


center <- sf::st_sf(geometry = sf::st_sfc(
	sf::st_point(c(144.9607, -37.8149))
))

## create a 1km circle around the point
radius <- 5665.317 / 100000
thisCircle <- sf::st_buffer(x = center, dist = radius)

## coordinates of the circle
coords <- sf::st_coordinates(thisCircle)

## MongoDB GeoIntersects query
wkt <- paste0("[[", paste0("[", paste0(coords[, 1], ", ", coords[, 2], collapse = "], ["), "]"), "]]")

qry <- paste0('{
							"geometry": {
							"$geoIntersects" : {
							"$geometry" : {"type" : "Polygon", "coordinates" : ', wkt, '}
							}
							}
							}')

m <- symbolix.utils::connectToMongo(db = "DATA_VIC", collection = "VICTORIA_ROADS", usr = "db_user")
res <- m$find( query = qry, ndjson = T )

roads <- geojson_sf( res )

roads <- roads[, c("EZI_RDNAME", "FQID", "FROM_UFI", "FTYPE_CODE", "LEFT_LOC", "PFI", "RD_NAME1", "RD_NAME2","RD_TYPE1","RD_TYPE2","RIGHT_LOC","ROAD_NAME","ROAD_TYPE","TO_UFI","UFI")]

usethis::use_data(roads, overwrite = T)

# roads <- mapdeck::roads
#
# roads[ !sf::st_is_empty( roads ), ]



