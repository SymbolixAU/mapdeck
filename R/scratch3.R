#
# library(sf)
# library(geojsonsf)
#
#
# sf <- geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
# #sf <- sf[1:16, ]
#
#
# library(mapdeck)
# set_token(read.dcf("~/.mapbox", fields = "MAPBOX"))
#
# mapdeck(style = mapdeck_style("light")) %>%
# 	add_triangle(
# 		data = sf[1:16, ]
# 		, fill_colour = "SA2_NAME16"
# 		, tooltip = "SA2_NAME16"
# 		, legend = TRUE
# 	)
# print( length( res$start_indices ) )
# print( length( res$input_index ) )
# print( length( res$geometry_coordinates ) )
#
#
# sf_poly <- sfheaders::sf_cast(sf = sf, to = "POLYGON", list_columns = NULL)
#
# i <- mapdeck:::rcpp_interleave_primitive_triangle(
# 	data = sf_poly
# 	, list_columns = integer(0)
# )
#
# p <- sf_poly[1, ]$geometry
#
# unclass( p[[1]] )
#
# mapdeck:::rcpp_interleave_primitive_triangle(
# 	data = sf_poly[5:15, ]
# 	, list_columns = integer(0)
# )
#
# lst_ear <- lapply( sf_poly$geometry, function(x) {
# 	interleave:::rcpp_earcut( x )
# })
#
# interleave:::rcpp_earcut( sf_poly[1, ]$geometry[[1]] )
#
# sa2 <- "Maryborough (Vic.)"
#
# mapdeck(style = mapdeck_style("light")) %>%
# 	add_triangle(
# 		data = sf[ sf$SA2_NAME16 == sa2, ]
# 		, fill_colour = "SA2_NAME16"
# 		, tooltip = "SA2_NAME16"
# 		, legend = TRUE
# 	)
#
#
#
