#
# library(sf)
# library(interleave)
#
# ## Non-MULTI objects only
#
# roads <- mapdeck::roads[1:20, ]
#
# dims <- geometries:::gm_dimensions( roads$geometry )[["dimensions"]]
#
# stroke_colour <- interleave::interleave(
# 	colourvalues::colour_values_rgb(
# 		x = rep(roads$ROAD_NAME, (dims[, 2] - dims[, 1]) + 1 )
# 	) / 255.0
# )
#
#
# coordinates <- interleave::interleave( roads$geometry )
# stride <- 2
# n_coordinates <- length( coordinates ) / stride
# start_indices <- dims[, 1]
#
# stroke_width <- rep(10, n_coordinates)
#
# set_token( secret::get_secret("MAPBOX"))
#
# mapdeck(
# 	style = mapdeck_style("light")
# ) %>%
# 	mapdeck:::binary_path(
# 		coordinates = coordinates
# 		, start_indices = start_indices
# 		, stride = stride
# 		, stroke_colour = stroke_colour
# 		, stroke_width = stroke_width
# 	)
#
# ## 'mapdeck_binary' object
# ## - needes to be indexable
# ## - so probably want a data.frame structure, right?
# ## - and then do the interleaving on groups of columns (coords, RGBA)
#
#
# roads <- mapdeck::roads[1:20, ]
# coordinates <- interleave::interleave( roads$geometry )
#
# dims <- geometries:::gm_dimensions( roads$geometry )[["dimensions"]]
#
# df_data <- roads
# sf::st_geometry( df_data ) <- NULL
#
# df_data[, c("start_index", "end_index") ] <- dims[, 1:2] + 1  ## +1 because we're in R.
#
#
# df_binary <- data.frame(
# 	x = coordinates[ seq(1, length(coordinates), by = stride) ]
# 	, y = coordinates[ seq(2, length(coordinates), by = stride) ]
# 	# , stroke_red = stroke_colour[ seq(1, length(stroke_colour), by = 4)]
# 	# , stroke_green = stroke_colour[ seq(2, length(stroke_colour), by = 4)]
# 	# , stroke_blue = stroke_colour[ seq(3, length(stroke_colour), by = 4)]
# 	# , stroke_alpha = stroke_colour[ seq(4, length(stroke_colour), by = 4)]
# 	# , stroke_width = stroke_width
# )
#
#
# ## If we want to filter our df_binary by ROAD_NAME == "YARRA"
# ## we get the coordinate indexes
# df_filtered <- df_data[ df_data$ROAD_NAME == "YARRA", ]
#
# idx <- unlist(lapply(seq_along(df_filtered$start_index), \(x) {df_filtered$start_index[x]:df_filtered$end_index[x]} ))
#
# ## The cordinates for these roads
# coordinates <- interleave::interleave( as.matrix( df_binary[ idx, ] ) )
#
#
# ## All other attributes
# stroke_colour <- interleave::interleave(
# 	colourvalues::colour_values_rgb(
# 		x = rep(df_filtered$ROAD_NAME, (df_filtered$end_index - df_filtered$start_index) )
# 	) / 255.0
# )
#
#
# #coordinates <- interleave::interleave( as.matrix( df_binary ) )
# stride <- ncol( df_binary )
#
# n_coordinates <- length( coordinates ) / stride
#
#
# ## we have filtered the data, so need to re-build the start_indices
# df_filtered$n_coords <- df_filtered$end_index - df_filtered$start_index
# start_indices <- cumsum(c(0, df_filtered$n_coords))
# start_indices <- start_indices[1:length(start_indices)-1]
#
# stroke_width <- rep(10, n_coordinates)
#
# mapdeck(
# 	style = mapdeck_style("light")
# ) %>%
# 	mapdeck:::binary_path(
# 		coordinates = coordinates
# 		, start_indices = start_indices
# 		, stride = stride
# 		, stroke_colour = stroke_colour
# 		, stroke_width = stroke_width
# 	)
#
#
#
