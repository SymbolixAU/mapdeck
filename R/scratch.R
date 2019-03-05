#
# trips <- jsonlite::fromJSON( 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/trips/trips.json' )
#
# library(data.table)
# library(sf)
#
# l <- lapply(trips[[2]], as.data.table)
# dt <- rbindlist(l, idcol = T)
#
# sf <- dt[
# 	, {
# 		geometry = sf::st_linestring(x = matrix(c(V1, V2, V3), ncol = 3))
# 		geometry = sf::st_sf( geometry = sf::st_sfc( geometry ) )
# 	}
# 	, by = .id
# ]
#
# dt[, summary(V3)]
# dt[, .N, by = V3][order(N)]
#
# sf <- sf::st_as_sf( sf )
#
# mapdeck(
# 	location = c(-73.9, 40.8)
# 	, zoom = 10
# 	, style = mapdeck_style("dark")
# ) %>%
# 	add_trips(
# 		data = sf
# 	)
