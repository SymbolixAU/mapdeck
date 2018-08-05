

library(sf)

sf <- geojsonsf::geojson_sf(googleway::geo_melbourne)
sf <- sf[, c( 'geometry')]
sf$id <- 1:nrow(sf)

#geojson <- geojsonsf::sf_geojson(sf)
geojson <- geojsonsf::sf_geojson(sf)

attr(geojson, 'class') <- 'json'
usethis::use_data(geojson, overwrite = T)

library(data.table)

dt_shapes <- fread("~/Downloads/gtfs (3)/shapes.txt")
dt_trips <- fread("~/Downloads/gtfs (3)/trips.txt")
dt_routes <- fread("~/Downloads/gtfs (3)/routes.txt")

## select one route_long_name
dt_routes <- dt_routes[ dt_routes[, .I[1], by = .(route_long_name) ]$V1 ]

dt <- unique(dt_trips[, .(route_id, trip_id, shape_id, trip_headsign, direction_id)])[
	unique(dt_routes[route_type %in% c(0), .(route_id, route_long_name, route_type)])
	, on = "route_id"
	, nomatch = 0
]

## pick just one trip
dt <- dt[ dt[, .I[1], by = .(route_id)]$V1 ]

dt <- dt[
	unique(dt_shapes[, .(shape_id, lon = shape_pt_lon, lat = shape_pt_lat, sequence = shape_pt_sequence)])
	, on = "shape_id"
	, nomatch =0
	, allow.cartesian = T
]

rm(dt_shapes, dt_trips, dt_routes)

setorder(dt, trip_id, route_id, shape_id, direction_id, sequence)

sf <- dt[
	, {
		geometry <- sf::st_linestring(x = matrix(c(lon, lat), ncol = 2))
		geometry <- sf::st_sfc(geometry)
		geometry <- sf::st_sf(geometry = geometry)
	}
	, by = .(route_id, trip_id, shape_id, direction_id)
]

sf <- sf::st_as_sf(sf[, 'geometry'])
sf$id <- 1:nrow(sf)

sf_geo <- geojsonsf::geojson_sf(geojson)
sf::st_crs(sf) <- sf::st_crs(sf_geo)

sf_bind <- rbind(sf, sf_geo)
geojson <- geojsonsf::sf_geojson(sf_bind)
attr(geojson, 'class') <- 'json'

mapdeck(
	token = key
	, style = "mapbox://styles/mapbox/dark-v9"
	, pitch = 35
) %>%
	mapdeck::add_geojson(
		data = geo
		, layer_id = "geojson"
	)

usethis::use_data(geojson, overwrite = T)


# library(googleway)
# set_key(read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY"))
#
# google_map() %>%
# 	add_polylines(data = sf[24, ])
#
# google_map() %>%
# 	add_markers(data = dt[trip_id == '1334.T0.4-388-mjp-1.1.H'])
#
#
# dt_shapes[shape_id == '4-388-mjp-1.1.H']

## Points?

# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
# geo <- '{"type":"Feature","properties":{"fillColor":"#00FF00"},"geometry":{"type":"Point","coordinates":[144.5, -37]}}'
# geo <- '{"type":"Point","coordinates":[144.5, -37]}'
#
# jsonlite::validate(geo)
# attr(geo, 'class') <- 'json'
#
# mapdeck(
# 	token = key
# 	, location = c(144.5, -37)
# 	, zoom = 12
# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	, pitch = 35
# ) %>%
# 	add_geojson(
# 		data = geo
# 		, layer_id = "geojson"
# 	)




# sf <- geojsonsf::geojson_sf(geo)
# sf$radius <- 1000
#
# mapdeck(
# 	token = key
# 	, location = c(144.5, -37)
# 	, zoom = 12
# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	, pitch = 35
# ) %>%
# 	add_scatterplot(
# 		data = sf
# 		, layer_id = "geojson"
# 		, radius = 'radius'
# 	)
