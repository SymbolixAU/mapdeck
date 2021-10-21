#
# library(geojsonsf)
# library(sf)
# library(mapdeck)
# library(mapboxapi)
#
# # set_token(secret::get_secret("MAPBOX"))
# #
# # sf <- geojsonsf::geojson_sf(geojsonsf::geo_melbourne)
# # sf::st_write(sf, dsn = "~/Desktop/melbourne.mvt", driver = "MVT")
# #
# # ?mapboxapi::upload_tiles
# #
# #
# # mapboxapi::upload_tiles(
# # 	input = sf
# # 	, username = "dcooley@symbolix.com.au"
# # 	, access_token = secret::get_secret("MAPBOX")
# # 	, tileset_id = "melbourne"
# # 	, tileset_name = "melbourne"
# # )
#
#
# mapdeck() %>%
# 	add_mvt(
# 		url = paste0("https://a.tiles.mapbox.com/v4/mapbox.mapbox-streets-v7/{z}/{x}/{y}.vector.pbf?access_token=", secret::get_secret("MAPBOX"))
# 	)
#
# "mapbox.mapbox-terrain-v2"
# "mapbox.mapbox-streets-v8"
#
# url <- paste0("https://a.tiles.mapbox.com/v4/mapbox.mapbox-streets-v7/{z}/{x}/{y}.vector.pbf?access_token=", secret::get_secret("MAPBOX"))
#
# url <- paste0("https://a.tiles.mapbox.com/v4/mapbox.mapbox-terrain-v2/{z}/{x}/{y}.vector.pbf?access_token=", secret::get_secret("MAPBOX"))
#
# url <- paste0("https://a.tiles.mapbox.com/v4/mapbox.mapbox-terrain-v2/{z}/{x}/{y}")
#
# mapdeck() %>%
# 	add_mvt(
# 		url = url
# 	)
#
# url <- "https://d25uarhxywzl1j.cloudfront.net/v0.1/{z}/{x}/{y}.mvt"
#
#
#
#
