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
