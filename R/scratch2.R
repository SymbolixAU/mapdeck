# #
# #
# # library(sf)
# #
# # set_token( secret::get_secret("MAPBOX") )
# #
# #
# # nc <- sf::st_read( system.file("./shape/nc.shp", package = "sf"))
# #
# # sf <- nc[1, ]
# #
# # df <- sfheaders::sf_to_df(
# # 	sf = nc#[1, ]
# # 	, fill = TRUE
# # )
# #
# # df$s <- sample( 1:nrow(df), replace = F )
# # df$z <- sample( 5:10000, nrow(df), replace = T)
# # # df$z <- ( df$y ^ 2 ) * 10
# # # df$z <- 1:nrow(df)
# # df$s <- df$z
# #
# # head( df )
# #
# # sf <- sfheaders::sf_multipolygon(
# # 	obj = df
# # 	, x = "x"
# # 	, y = "y"
# # 	, z = "z"
# # 	, list_columns = "s"
# # 	, multipolygon_id = "multipolygon_id"
# # 	, polygon_id = "polygon_id"
# # 	, linestring_id = "linestring_id"
# # 	, keep = T
# # )
# #
# # l <- list(
# # 	fill_colour = "sfg_id"
# # )
# #
# # sf_poly <- sfheaders::sf_cast( sf, "POLYGON", list_columns = "s" )
# #
# # res <- mapdeck:::rcpp_triangle_interleaved(
# # 	data = sf_poly[1:5, ]
# # 	, params = l
# # 	, list_columns = 16L
# # 	, digits = 6L
# # 	, layer_name = "triangle"
# # )
# #
# # # idx <- 5
# #
# # # idx <- 1:50
# # interleave:::rcpp_interleave_triangle(
# # 	obj = sf_poly$geometry, list( sf_poly$s )
# # )
# #
# #
# # mapdeck() %>%
# # 	add_triangle(
# # 		data = sf
# # 		, fill_colour = "s"
# # 		, tooltip = "multipolygon_id"
# # 		#, auto_highlight = TRUE
# # 	)
# #
# # res
# #
#
#
# library(mapdeck)
#
# set_token( secret::get_secret("MAPBOX"))
# library(sf)
# library(geojsonsf)
#
# sf <- geojsonsf::geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
#
# sf_poly <- sfheaders::sf_cast(sf, "POLYGON", close = TRUE)
#
# mapdeck(
#   style = mapdeck_style('dark')
# ) %>%
#   add_triangle(
#     data = sf_poly[10:17, ]
#     , layer = "polygon_layer"
#     , fill_colour = "SA2_NAME16"
# )
#
#
# library(data.table)
# dt <- sfheaders::sf_to_df(sf_poly[10:17, ])
# setDT(dt)
#
# interleaved <- interleave:::rcpp_interleave_triangle(sf_poly[10:17, ]$geometry, NULL)
#
#
# start_idx <- interleaved$start_indices
#
# interleaved$coordinates[ start_idx + 1]
#
#
#
#
#
#
#
