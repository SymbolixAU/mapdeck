#
# key <- read.dcf("~/Documents/.googleAPI", fields= "MAPBOX")
# library(magrittr)
#
# mapbox_map(key = key) %>% add_markers()
#
# str(geo)
# library(sf)
# geojsonsf::geojson_sf(geo)
#
# mapbox_map(key = key) %>% mapbox::add_markers(googleway::geo_melbourne)
#
# library(mongolite)
# library(sf)
# library(googlePolylines)
# library(geojsonsf)
# library(googleway)
# library(googlewayx)
#
# m <- mongo(db = "ABS", collection = "MB_2016")
# geo <- m$find(query = '{"geometry":{"$ne":null}}', ndjson = T)
# rm(m); gc()
#
# sf <- geojsonsf::geojson_sf(geo)
#
# enc <- googlePolylines::encode(sf)
#
# df <- data.frame(polyline = unlist(enc$geometry), stringsAsFactors = F)
# rm(sf, geo, valid, enc); gc()
#
# library(data.table)
# points <- decode(df[1:50, "polyline"])
# points <- data.table::rbindlist(points)
#
# sf_points <- points[
# 	, {
# 		geometry <- sf::st_point(c(lon, lat))
# 		geometry <- sf::st_sfc(geometry)
# 		geometry <- sf::st_sf(geometry = geometry)
# 	}
# 	, by = 1:nrow(points)
# ]
#
# sf_points <- sf::st_as_sf(sf_points)
# geo_points <- geojsonsf::sf_geojson(sf_points)
#
# mapbox_map(key = key) %>% mapbox::add_markers(data = geo_points )
#
# key <- read.dcf("~/Documents/.googleAPI", fields= "MAPBOX")
# library(magrittr)
# mapdeck_map(key = key) %>% add_geojson()


