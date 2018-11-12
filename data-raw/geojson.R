

library(sf)

# sf <- geojsonsf::geojson_sf(googleway::geo_melbourne)
# sf <- sf[, c( 'geometry')]
# sf$id <- 1:nrow(sf)
#
# #geojson <- geojsonsf::sf_geojson(sf)
# geojson <- geojsonsf::sf_geojson(sf)
#
# attr(geojson, 'class') <- 'json'
# usethis::use_data(geojson, overwrite = T)

library(data.table)

dt_shapes <- fread("~/Downloads/gtfs (3)/shapes.txt")
dt_trips <- fread("~/Downloads/gtfs (3)/trips.txt")
dt_routes <- fread("~/Downloads/gtfs (3)/routes.txt")

dt_stops <- fread("~/Downloads/gtfs (3)/stops.txt")
dt_stoptimes <- fread("~/Downloads/gtfs (3)/stop_times.txt")



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

## grab stops
dt_stops <- unique(dt[, .(trip_id)])[
	dt_stoptimes[, .(stop_id, trip_id)]
	, on = "trip_id"
	, nomatch = 0
][
	dt_stops
	, on = "stop_id"
	, nomatch = 0
]

dt_stops <- dt_stops[ dt_stops[, .I[1], by = stop_id]$V1 ]
sf_stops <- dt_stops[
	, {
		geometry <- sf::st_point(x = c(stop_lon, stop_lat))
		geometry <- sf::st_sfc(geometry)
		geometry <- sf::st_sf(geometry = geometry)
	}
	, by = stop_id
]

sf_stops <- sf_stops[, 'geometry']
sf_stops <- sf::st_sf(sf_stops)

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
sf_stops$id <- 1:nrow(sf_stops)
sf_geo <- geojsonsf::geojson_sf(geojson)
sf::st_crs(sf) <- sf::st_crs(sf_geo)
sf::st_crs(sf_stops) <- sf::st_crs(sf_geo)

sf_bind <- rbind(sf, sf_geo, sf_stops)
geojson <- geojsonsf::sf_geojson(sf_bind)
attr(geojson, 'class') <- 'json'

mapdeck(
	token = key
	, style = "mapbox://styles/mapbox/dark-v9"
	, pitch = 35
) %>%
	mapdeck::add_geojson(
		data = geojson
		, layer_id = "geojson"
	)

usethis::use_data(geojson, overwrite = T)

sf <- geojsonsf::geojson_sf(geojson)
sf$fillColor <- sample(colourvalues::colour_values(1:5, palette = "viridis"), size = nrow(sf), replace = T)
geojson <- geojsonsf::sf_geojson(sf)
attr(geojson, 'class') <- 'json'

usethis::use_data(geojson, overwrite = T)


