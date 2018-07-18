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


#mapdeck_map(key = key) %>% add_geojson(googleway::geo_melbourne)

# ## GeoJSON colours
# library(data.table)
# sf <- geojsonsf::geojson_sf(googleway::geo_melbourne)
# setDT(sf)
# sf[, fillColor := paste0("[", paste0(col2rgb(fillColor), collapse = ","), "]"), by = 1:nrow(sf)]
# sf <- sf::st_as_sf(sf)
# geo <- geojsonsf::sf_geojson(sf)
# mapdeck_map(key = key) %>% add_geojson(geo)

# ## large geojson
# library(mongolite)
# key <- read.dcf("~/Documents/.googleAPI", fields= "MAPBOX")
# m <- symbolix.utils::connectToMongo(db = "ABS", collection = "SA2_2016", usr = "db_user")
#
# geo <- m$find(ndjson = T)
# sf <- geojsonsf::geojson_sf(geo)



# sf$fill_colour <- sf$AREASQKM16
#
# colourColumns <- googleway:::shapeAttributes(fill_colour = "fill_colour", stroke_colour =NULL)
# pal <- googleway:::createPalettes(sf, colourColumns)
#
# colour_palettes <- googleway:::createColourPalettes(sf, pal, colourColumns = "AREASQKM16", viridisLite::viridis)
#
# googleway:::constructPalette(sf$AREASQKM16, viridisLite::viridis)

#
# geo_mini <- geojsonsf::sf_geojson(sf[1:1000, ])
# attr(geo_mini, 'class') <- 'json'
#
# mapdeck_map(key = key) %>% mapdeck::add_geojson(geo_mini)


### SCATTER
# key <- read.dcf("~/Documents/.googleAPI", fields= "MAPBOX")

# mapdeck::mapdeck_map(key = key) %>% add_scatterplot()
# n <- 500000
# lon <- sample(c(-90:90), size = n, replace = T)
# lat <- sample(c(-90:90), size = n, replace = T)
# df <- data.frame(lon = lon, lat = lat)
# df$colour <- sample(letters, size = n, replace = T)
# df$radius <- sample(100:100000, size = n, replace = T)
#
# md_map(key = key) %>%
# 	add_scatterplot(data = df[1:50000, ], fill_colour = "colour", lat = "lat", lon = "lon",
# 									radius = "radius")




## DATA FORMAT CAN BE

# Data format:
# 	[
#   {name: 'Colma (COLM)', code:'CM', address: '365 D Street, Colma CA 94014', exits: 4214, coordinates: [-122.466233, 37.684638]},
#    ...
#  ]














