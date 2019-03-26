#
# trips <- jsonlite::fromJSON( 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/trips/trips.json' )
#
# library(data.table)
# library(sf)
# library(mapdeck)
# set_token( read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
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
# 		, stroke_colour = ".id"
# 	)
#
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
# f <- fitdc::read_fit( paste0(fp, l[1] ) )
#
# devtools::install_github("grimbough/fitFileR")
# library(fitFileR)
#
# f <- fitFileR::readFitFile( paste0(fp, l[1] ) )
#
#
# fp <- "~/Documents/Data/Garmin/Activities/"
# l <- list.files(fp)
#
# # devtools::install_github('kuperov/fit')
# library(fit)
# library(data.table)
#
# lst <- lapply( 1:length(l), function( x ) {
# 	print(x)
# 	f <- l[x]
# 	f <- paste0(fp, f)
# 	f <- path.expand( f )
# 	data <- read.fit( f )
# 	data[["record"]]
# })
#
# dt <- rbindlist(lst, use.names = T, fill = T, idcol = T)
#
# dt <- dt[!is.na( position_lat ) ]
#
# dt[, seq := 1:.N, by = .id]
#
# # dt[, time := anytime::anytime( time, asUTC = TRUE ) ]
#
# dt[, timestamp := as.POSIXct( timestamp, origin = "1990-01-01")]
# dt[, m := data.table::minute( timestamp )]
# dt[, s := data.table::second( timestamp )]
# dt[, h := data.table::hour( timestamp )]
#
# dt[, seconds := ( h * 60 * 60 ) + ( m * 60 ) + s  ]
#
#
#
# dt[, diff_time := timestamp - shift(timestamp, type = "lag"), by = .(.id) ]
# dt <- dt[!is.na(diff_time)]
#
# dt[, diff_time := as.numeric( diff_time ) ]
#
# ## Remove stops greater than 1 minutes
# # dt <- dt[ diff_time < 60 ]
#
#
# #dt[, diff_time := as.numeric( diff( timestamp ) ),by = .(.id) ]
# dt[, t := cumsum( diff_time ), by = .(.id) ]
#
# library(sf)
#
# dt[
# 	dt[speed > 0, .(avg_speed = mean( speed ) * 1.609), by = .(.id)]
# 	, on = ".id"
# 	, avg_speed := i.avg_speed
# 	]
#
# sf <- dt[
# 	, {
# 		geometry = sf::st_linestring(x = matrix(c(position_long, position_lat, seconds), ncol = 3))
# 		geometry = sf::st_sf( geometry = sf::st_sfc( geometry ) )
# 	}
# 	, by= .(.id, avg_speed)
# ] %>% sf::st_as_sf()
#
# # garmin <- sf
# #
# # usethis::use_data( garmin )
#
# mapdeck(
# 	style = mapdeck_style("dark")
# 	, location = c(145., -37.8)
# 	, zoom = 10
# ) %>%
# 	add_trips(
# 		data = sf
# 		, stroke_colour = "avg_speed"
# 		, loop_length = 65000
# 		, animation_speed = 2500
# 		, trail_length = 1500
# 		, legend = F
# 	)
#
#
#
# fp <- "~/Documents/Data/Strava/Bethan/activities/"
# gpx <- plotKML::readGPX( gpx.file = paste0(, fp, "1007343724.gpx" ) )
#
#
# l <- list.files(path = fp, pattern = ".gpx$", recursive = T)
# l <- paste0(fp, l)
# lst <- lapply(l, function(x) {
# 	gpx <- plotKML::readGPX(x)
# 	data <- gpx$tracks[[1]][[1]]
# 	data
# })
#
# library(data.table)
#
# dt <- rbindlist(lst, idcol = T, use.names = T, fill = T)
#
# dt[, t := anytime::anytime(time, asUTC = TRUE )]
#
# dt[, m := data.table::minute( t )]
# dt[, s := data.table::second( t )]
# dt[, h := data.table::hour( t )]
#
# dt[, seconds := ( h * 60 * 60 ) + ( m * 60 ) + s  ]
#
# dt[, ele := as.numeric( ele )]
# dt[, avg_ele := mean( ele, na.rm = T), by = .id]
#
#
# # dt[, diff_time := as.numeric( diff( time ) ),by = .(.id) ]
# # dt[, t := cumsum( diff_time ), by = .(.id) ]
#
# library(sf)
# sf <- dt[
# 	, {
# 		geometry = sf::st_linestring(x = matrix(c(lon, lat, ele), ncol = 3))
# 		geometry = sf::st_sf( geometry = sf::st_sfc( geometry ) )
# 	}
# 	, by= .(.id, avg_ele)
# ] %>% sf::st_as_sf()
#
#
# mapdeck(
# 	style = mapdeck_style("dark")
# 	, location = c(145., -37.8)
# 	, zoom = 10
# ) %>%
# 	add_path(
# 		data = sf[1:20, ]
# 		, stroke_colour = "avg_ele"
# 		# , loop_length = 87000
# 		# , animation_speed = 2500
# 		# , trail_length = 1500
# 		, legend = T
# 	)
#
#
# fp <- path.expand("~/Documents/Data/Strava/Bethan/activities/")
# l <- list.files(fp, patter = "gpx$")
#
# gpx <- paste0(fp, l)
#
# library(sf)
#
# sf <- gpxsf::gpx_sf( gpx[1], time_return = "counter" )
#
#
# mapdeck(
# 	style = mapdeck_style("dark")
# 	, location = c(145, -37.8)
# 	, zoom = 10
# ) %>%
# 	add_trips(
# 		data = sf
# 		, loop_length = 1440
# 		, animation_speed = 200
# 	)















