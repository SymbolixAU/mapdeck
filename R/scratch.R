
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
#
# df <- melbourne
# df$elevation <- sample(100:5000, size = nrow(df))
# df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)

# mapdeck(
# 	style = mapdeck_style('dark')
# 	, location = c(145, -38)
# 	, zoom = 8
# ) %>%
# 	add_polygon(
# 		data = df
# 		, polyline = "geometry"
# 		, layer = "polygon_layer"
# 		, fill_colour = "SA2_NAME",
# 		, elevation = "elevation"
# 		, stroke_width = 0
# 		, tooltip = 'info'
# 		, legend = T
# 	)
