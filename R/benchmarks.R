#
# ## TODO
# # - these benchmarks only show R, not browser rendering time
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
# df$val <- rnorm(n=n)
# sf <- sf::st_as_sf( df, coords = c("lon","lat"))
# enc <- googlePolylines::encode( sf )
# encLite <- googlePolylines::encode( sf, strip = T )
#
# sf$fill_colour <- colourvalues::colour_values(sf$val)
# geo <- geojsonsf::sf_geojson( sf, simplify = FALSE )
#
# microbenchmark(
# 	df = {
# 		mapdeck() %>% add_scatterplot( data = df, lon = "lon", lat = "lat", fill_colour = "val")
# 	},
# 	sf = {
# 		mapdeck() %>% add_scatterplot( data = sf, fill_colour = "val" )
# 	},
# 	enc = {
# 		mapdeck() %>% add_scatterplot( data = enc, fill_colour = "val" )
# 	},
# 	enclite = {
# 		mapdeck() %>% add_scatterplot( data = encLite, fill_colour = "val" )
# 	},
# 	geo_sf = {
# 		mapdeck() %>% add_geojson( data = sf, fill_colour = "val" )
# 	},
# 	geojson = {
# 		mapdeck() %>% add_geojson( data = geo )
# 	},
# 	times = 5
# )
#
# # Unit: milliseconds
# #    expr        min         lq       mean     median          uq         max neval
# # df      456.205270 466.227301 505.972537 521.141831  535.952496  550.335787     5
# # sf      424.461500 426.184777 546.094275 433.743690  466.887704  979.193704     5
# # enc     783.477064 806.466145 933.792187 885.506362  903.656713 1289.854652     5
# # enclite 681.644942 730.634827 769.643424 740.264817  750.807022  944.865514     5
# # geo_sf  636.163284 781.685261 975.163050 885.819292 1022.844405 1549.303007     5
# # geojson   1.267405   1.348774   1.387614   1.401142    1.440508    1.480242     5
#
# obj <- c("df","sf","enc","encLite","geo")
# res <- vapply( mget( obj ), function(x) object.size(x), 1.0 )
# res <- sort( res )
# as.data.frame( res )
#
# #              res
# # df       2801088
# # encLite 14001376
# # geo     16785296
# # sf      45237912
# # enc     50003384
#
# ## TODO why is 'enc' bigger than 'sf' ?
# ## - because "POINT' are small anyway (NumericVector(2))
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
# ## polygon
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
# res <- vapply( mget( obj ), function(x) object.size(x), 1.0 )
# res <- sort( res )
# as.data.frame( res )
#
# #             res
# # encLite 1556432
# # enc     3030544
# # sf      5030176
# # geo     5199600
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
# ## path
#
# sf <- roads
# enc <- googlePolylines::encode( sf )
# encLite <- googlePolylines::encode( sf, strip = T )
# sf$stroke_colour <- colourvalues::color_values( sf$RIGHT_LOC )
# geo <- geojsonsf::sf_geojson( sf, simplify = FALSE )
#
#
# microbenchmark(
# 	sf = {
# 		mapdeck() %>% add_path( data = sf, stroke_colour = "RIGHT_LOC" )
# 	},
# 	enc = {
# 		mapdeck() %>% add_path( data = enc, stroke_colour = "RIGHT_LOC" )
# 	},
# 	enclite = {
# 		mapdeck() %>% add_path( data = encLite, stroke_colour = "RIGHT_LOC" )
# 	},
# 	geo_sf = {
# 		mapdeck() %>% add_geojson( data = sf, stroke_colour = "RIGHT_LOC" )
# 	},
# 	geojson_raw = {
# 		## uses the fill_colour property
# 		mapdeck() %>% add_geojson( data = geo )
# 	},
# 	geojson = {
# 		## converts to sf internally
# 		mapdeck() %>% add_geojson( data = geo, stroke_colour = "RIGHT_LOC" )
# 	},
# 	times = 5
# )
#
# # Unit: milliseconds
# #        expr         min          lq        mean      median          uq         max neval
# # sf           115.869173  127.285125  130.419934  127.974642  132.759235  148.211496     5
# # enc          131.021713  133.304998  137.932747  134.803647  139.380252  151.153124     5
# # enclite      125.009099  133.982827  163.172389  139.418675  147.436373  270.014970     5
# # geo_sf       157.998692  168.252376  176.258981  172.229096  173.356248  209.458494     5
# # geojson_raw    1.367818    1.403125    1.877565    1.504032    1.608655    3.504197     5
# # geojson     1303.502648 1326.171179 1359.787277 1360.266253 1389.298148 1419.698157     5
#
#
# obj <- c("sf","enc","encLite","geo")
# res <- vapply( mget( obj ), function(x) object.size(x), 1.0 )
# res <- sort( res )
# as.data.frame( res )
#
# #              res
# # encLite  5008024
# # geo      8771736
# # enc     11739384
# # sf      14516848
