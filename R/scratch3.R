#
# library(sf)
# library(mapdeck)
#
# r <- c(1:10221)
# sf <- rbind(roads[r, ], roads[r,])
#
# mapdeck(
# 	style = mapdeck_style("dark")
# ) %>%
# 	add_path(
# 		data = sf
# 		, stroke_colour = "ROAD_NAME"
# 		, tooltip = "linestring_id"
# 	)
#
# df <- sfheaders::sf_to_df( sf, fill = TRUE )
#
# df[ df$linestring_id == 6657, ]
#
#
# sf <- rbind( roads, roads, roads, roads, roads, roads, roads, roads )
# # sf <- rbind( sf, sf, sf, sf)
# nrow( sf )
# ## 146,288
#
# system.time({
# 	mapdeck(
# 		style = mapdeck_style("dark")
# 	) %>%
# 		add_path(
# 			data = sf
# 			, stroke_colour = "ROAD_NAME"
# 		)
# })
#
#
#
# ## dashed vs non-dashed
#
#
# system.time({
# 	mapdeck(
# 		style = mapdeck_style("dark")
# 	) %>%
# 		add_path(
# 			data = sf
# 			, stroke_colour = "ROAD_NAME"
# 			 , dash_size = 5
# 			 , dash_gap = 5
# 		)
# })
#
#
# n <- 65536
# df <- data.frame(
# 	x = c(rnorm(n-1), 0)
# 	, y = c(rnorm(n-1), 10)
# 	, colour = c(rep(1,(n-1)), 2)
# )
#
# nrow( df )
#
# sf <- sfheaders::sf_point(
# 	obj = df
# 	, x = "x"
# 	, y = "y"
# 	, keep = T
# )
#
# mapdeck() %>%
# 	add_scatterplot(
# 		data = sf
# 		, fill_colour = "colour"
# 		, radius = 100000
# 	)
#
#
