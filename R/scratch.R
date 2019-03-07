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
# dt[, time_to_next_point := sample(10:50, size = .N, replace = T)]
#
# dt[, time := cumsum(time_to_next_point) + start_time, by = r]
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
# 		data = sf[1:5000, ], stroke_colour = "#FFFFFF"
# 	)

# install.packages("plotKML")
# library(plotKML)
#
# gpx <- plotKML::readGPX( gpx.file = "~/Downloads/activity_3412595453.gpx")
# gpx2 <- plotKML::readGPX( gpx.file = "~/Downloads/activity_3389432092.gpx")
# str( gpx )
#

# l <- list.files(path = "~/Downloads/", pattern = ".gpx")
# p <- paste0("~/Downloads/", l)
# lst <- lapply( p, plotKML::readGPX )
#
# lst <- lapply( lst, function( x ) {
# 	as.data.table( x[["tracks"]][[1]][["Melbourne Cycling"]] )
# })
#
# dt <- rbindlist( lst, idcol = T)
#
# dt[, time := anytime::anytime( time, asUTC = TRUE ) ]
# dt[, diff_time := as.numeric( diff( time ) ),by = .(.id) ]
# dt[, t := cumsum( diff_time ), by = .(.id) ]
#
# sf <- dt[
# 	, {
# 		geometry = sf::st_linestring(x = matrix(c(lon, lat, t), ncol = 3))
# 		geometry = sf::st_sf( geometry = sf::st_sfc( geometry ) )
# 	}
# 	, by= .(.id)
# ] %>% sf::st_as_sf()
#
#
# mapdeck(
# 	style = mapdeck_style("dark")
# 	, location = c(145., -37.8)
# 	, zoom = 10
# ) %>%
# 	add_trips(
# 		data = sf, stroke_colour = colourvalues::colour_values(1:2)[2]
# 	)
#
#
#
#
# as.POSIXct( df$time, format = "%Y-%m-%dT%H:%m:%s", tz = "UTC", origin = "1970-01-01")
#
# df$time <- anytime::anytime( df$time, tz = "Australia/Melbourne" )
#
#
#
#
# devtools::install_github('fawda123/rStrava')
# library(rStrava)
#
#
# me <- '3088903'
#
# app_name <- 'mapdeck' # chosen by user
# app_client_id  <- ''  # an integer, assigned by Strava
# app_secret <- '' # an alphanumeric secret, assigned by Strava
#
# stoken <- httr::config(token = strava_oauth(app_name, app_client_id, app_secret, cache = TRUE))
#
# myinfo <- get_athlete(stoken, id = me)
#
# head( myinfo )
#
# my_acts <- get_activity_list( stoken )
#
# str( my_acts )
#
# lapply( my_acts, function(x) {
# 	if( x[["type"]] == "Ride" ) {
# 		data.table(
# 			polyline = x[["map"]][["summary_polyline"]]
#
# 		)
# 	}
# })
#
#

