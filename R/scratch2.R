#
#
# library(sf)
#
# set_token( secret::get_secret("MAPBOX") )
#
#
# nc <- sf::st_read( system.file("./shape/nc.shp", package = "sf"))
#
# sf <- nc[1, ]
#
# df <- sfheaders::sf_to_df(
# 	sf = nc#[1, ]
# 	, fill = TRUE
# )
#
# df$s <- sample( 1:nrow(df), replace = F )
# df$z <- sample( 5:10000, nrow(df), replace = T)
# # df$z <- ( df$y ^ 2 ) * 10
# # df$z <- 1:nrow(df)
# df$s <- df$z
#
# head( df )
#
# sf <- sfheaders::sf_multipolygon(
# 	obj = df
# 	, x = "x"
# 	, y = "y"
# 	, z = "z"
# 	, list_columns = "s"
# 	, multipolygon_id = "multipolygon_id"
# 	, polygon_id = "polygon_id"
# 	, linestring_id = "linestring_id"
# 	, keep = T
# )
#
# # l <- list(
# # 	fill_colour = "sfg_id"
# # )
#
# sf_poly <- sfheaders::sf_cast( sf, "POLYGON", list_columns = "s" )
#
# # res <- mapdeck:::rcpp_triangle_interleaved(
# # 	data = sf_poly
# # 	, params = l
# # 	, list_columns = 17L
# # 	, digits = 6L
# # 	, layer_name = "triangle"
# # )
# #
# #
# # interleave:::rcpp_interleave_triangle(
# # 	obj = sf_poly[4, ]$geometry, list( sf_poly[5, ]$s )
# # )
#
#
# mapdeck() %>%
# 	add_triangle(
# 		data = sf
# 		, fill_colour = "s"
# 		, tooltip = "multipolygon_id"
# 		#, auto_highlight = TRUE
# 	)
#
# res
#
