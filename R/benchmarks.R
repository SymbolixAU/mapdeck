#
# ## TODO
# # - mixture of geometries
# # - why some are faster or slower
# # - benefits of one over another
# # -- encodedlite don't use bounding box (or raw geojson )
# # -- geojson will convert to sf if specifying colours
# # -- geojson appears less performant in javascript side
#
#
# library(microbenchmark)
# library(mapdeck)
# library(sf)
# library(geojsonsf)
# library(googlePolylines)
#
# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
# set_token( key )
#
# ## scatterplot
# set.seed(20181209)
# n <- 1e5
# lons <- seq(-180,180, by = 0.001)
# lats <- seq(-90,90, by = 0.001)
# df <- data.frame(
# 	lon = sample(lons, size = n, replace = T)
# 	, lat = sample(lats, size = n, replace = T )
# )
# df$id <- 1:nrow(df)
# sf <- sf::st_as_sf( df, coords = c("lon","lat"))
# enc <- googlePolylines::encode( sf )
# encLite <- googlePolylines::encode( sf, strip = T )
# geo <- geojsonsf::sf_geojson( sf, simplify = FALSE )
#
# microbenchmark(
# 	df = {
# 		mapdeck() %>% add_scatterplot( data = df, lon = "lon", lat = "lat")
# 	},
# 	sf = {
# 		mapdeck() %>% add_scatterplot( data = sf )
# 	},
# 	enc = {
# 		mapdeck() %>% add_scatterplot( data = enc )
# 	},
# 	enclite = {
# 		mapdeck() %>% add_scatterplot( data = encLite )
# 	},
# 	geo_sf = {
# 		mapdeck() %>% add_geojson( data = sf )
# 	},
# 	geojson = {
# 		mapdeck() %>% add_geojson( data = geo )
# 	},
# 	times = 5
# )
#
# # Unit: milliseconds
# #    expr        min         lq       mean     median          uq       max neval
# # df      516.271960 523.000530 795.302312 761.863647  977.416711 1197.9587     5
# # sf      488.389303 503.285664 648.234416 525.515027  768.766163  955.2159     5
# # enc     689.293883 723.563765 792.195578 755.145747  802.333237  990.6413     5
# # enclite 637.179450 653.181946 834.961701 731.911925 1031.337623 1121.1976     5
# # geo_sf  710.927895 878.835851 986.497704 908.957911 1204.109449 1229.6574     5
# # geojson   1.225707   2.011702   4.848941   2.091597    5.315803   13.5999     5
#
# obj <- c("df","sf","enc","encLite","geo")
# res <- sort(vapply(mget(obj), function(x) format(object.size(x), units = "Kb"),"" ) )
# as.data.frame( res )
#
# ## TODO why is 'enc' bigger than 'sf' ?
#
#
#
# library(microbenchmark)
# library(mapdeck)
# library(sf)
# library(geojsonsf)
# library(googlePolylines)
#
# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
# set_token( key )
#
# ## scatterplot
# sf <- sf::st_read( system.file("shape/nc.shp",package="sf"))
# ## make a bit bigger
# sf <- rbind(sf, sf, sf, sf, sf, sf, sf, sf)
# sf <- rbind(sf, sf, sf, sf, sf)
# enc <- googlePolylines::encode( sf )
# encLite <- googlePolylines::encode( sf, strip = T )
# sf$fill_colour <- colourvalues::color_values( sf$AREA )
# geo <- geojsonsf::sf_geojson( sf, simplify = FALSE )
#
#
# microbenchmark(
# 	sf = {
# 		mapdeck() %>% add_polygon( data = sf, fill_colour = "AREA" )
# 	},
# 	enc = {
# 		mapdeck() %>% add_polygon( data = enc, fill_colour = "AREA" )
# 	},
# 	enclite = {
# 		mapdeck() %>% add_polygon( data = encLite, fill_colour = "AREA" )
# 	},
# 	geo_sf = {
# 		mapdeck() %>% add_geojson( data = sf, fill_colour = "AREA" )
# 	},
# 	geojson_raw = {
# 		## uses the fill_colour property
# 		mapdeck() %>% add_geojson( data = geo )
# 	},
# 	geojson = {
# 		## converts to sf internally
# 		mapdeck() %>% add_geojson( data = geo, fill_colour = "AREA" )
# 	},
# 	times = 5
# )
#
# # Unit: milliseconds
# # expr               min         lq       mean     median         uq        max neval
# # sf           83.684579  92.341509 103.123123  92.442575 106.142269 141.004682     5
# # enc          17.203230  17.334162  17.925281  17.353199  17.978978  19.756838     5
# # enclite      15.780515  17.205796  23.409552  19.847965  21.481832  42.731652     5
# # geo_sf       91.054227  92.663365 107.123839  93.328851 103.012873 155.559878     5
# # geojson_raw   1.167508   1.307513   1.376268   1.345209   1.492888   1.568223     5
# # geojson     477.168586 492.928279 560.850102 508.497863 565.509485 760.146295     5
#
#
# obj <- c("sf","enc","encLite","geo")
# res <- sort(vapply(mget(obj), function(x) format(object.size(x), units = "Kb"),"" ) )
# as.data.frame( res )
#
# #               res
# # encLite   1520 Kb
# # enc     2959.5 Kb
# # sf      4912.3 Kb
# # geo     5077.7 Kb
#
#
#
