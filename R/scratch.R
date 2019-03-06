# #
# # trips <- jsonlite::fromJSON( 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/trips/trips.json' )
# #
# # library(data.table)
# # library(sf)
# # library(mapdeck)
# # set_token( read.dcf("~/.googleAPI", fields = "MAPBOX"))
# #
# # l <- lapply(trips[[2]], as.data.table)
# # dt <- rbindlist(l, idcol = T)
# #
# # sf <- dt[
# # 	, {
# # 		geometry = sf::st_linestring(x = matrix(c(V1, V2, V3), ncol = 3))
# # 		geometry = sf::st_sf( geometry = sf::st_sfc( geometry ) )
# # 	}
# # 	, by = .id
# # ]
# #
# # dt[, summary(V3)]
# # dt[, .N, by = V3][order(N)]
# #
# # sf <- sf::st_as_sf( sf )
# #
# # mapdeck(
# # 	location = c(-73.9, 40.8)
# # 	, zoom = 10
# # 	, style = mapdeck_style("dark")
# # ) %>%
# # 	add_trips(
# # 		data = sf
# # 	)
# #
#
# library(data.table)
# library(sf)
#
# sf <- mapdeck::roads
# sf <- sf[, "PFI"]
#
# ## the PFI is a unique identifier
# length(unique( sf$PFI )) == nrow( sf )
# sf$r <- 1:nrow( sf )
#
# dt <- as.data.table( sf::st_coordinates( sf ) )
#
# ## L1 gives the row number (r) from sf
# setnames( dt, names(dt), c("lon","lat","r"))
#
# ## add a sequence value
# dt[, seq := 1:.N, by = r]
#
# ## randomly pick a start time for each road
# dt[, start_time := sample(0:100, size = 1), by = r]
#
# ## set a 'speed' between each sequential coordinate
# dt[, speed := sample(10:50, size = .N, replace = T)]
#
# dt[, time := cumsum(speed) + start_time, by = r]
#
# dt[, range(time)]
#
# sf <- dt[
# 	, {
# 		geometry = sf::st_linestring( x = matrix( c(lon, lat, time ), ncol = 3 ) )
# 		geometry = sf::st_sf( geometry = sf::st_sfc( geometry ) )
# 	}
# 	, by = r
# ] %>% sf::st_as_sf()
#
# ## the linestring now has a Z component, which we're usign as 'time' (not elevation)
#
# mapdeck(
# 	style = mapdeck_style("dark")
# 	, location = c(145., -37.8)
# 	, zoom = 10
# ) %>%
# 	add_trips(
# 		data = sf[1:100, ]
# 	)


