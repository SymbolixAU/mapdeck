
### SCATTER
# key <- read.dcf("~/Documents/.googleAPI", fields= "MAPBOX")

# library(mongolite)
# library(sf)
# library(geojsonsf)
# m <- symbolix.utils::connectToMongo(db = "ABS", collection = "SA2_2016", usr = "db_user")
# geo <- m$find(query = '{"geometry":{"$ne":null}}', ndjson = T)
# sf <- geojsonsf::geojson_sf(geo)
#
# df <- as.data.frame(sf::st_coordinates(sf[sf$STE_NAME16 == "Victoria", ]))
# head(df)
# nrow(df)
# df$colour <- sample(letters, size = nrow(df), replace = T)
#
# md_map(
# 	key = key
# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	) %>%
# 	add_scatterplot(
# 		data = df[, ]
# 		, lat = "Y"
# 		, lon = "X"
# 		, fill_colour = "colour"
# 	)

# mapdeck(token = key) %>%
# 	add_scatterplot(data = df[1:50000, ], fill_colour = "colour", lat = "lat", lon = "lon",
# 									radius = "radius")



## Geojson

geo <- sf_geojson(sf[sf$STE_NAME16 == "Victoria",])
attr(geo, 'class') <- 'json'

mapdeck(token = key, style = 'mapbox://styles/mapbox/dark-v9') %>%
	add_geojson(data = geo)


## DATA FORMAT CAN BE

# Data format:
# 	[
#   {name: 'Colma (COLM)', code:'CM', address: '365 D Street, Colma CA 94014', exits: 4214, coordinates: [-122.466233, 37.684638]},
#    ...
#  ]














