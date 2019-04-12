#
#
# set_token( read.dcf("~/.googleAPI", fields = "MAPBOX"))
#
# df <- melbourne  ## data.frame with encoded polylnies
# df$elevation <- sample(100:5000, size = nrow(df))
# df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
# l1 <- legend_element(
# 	colours = colourvalues::colour_values(1:5)
# 	, variables = letters[1:5]
# 	, colour_type = "fill"
# 	, variable_type = "category"
# 	, title = "new legend"
# 	)
#
# l2 <- legend_element(
# 	colours = colourvalues::colour_values(1:5, palette = "inferno")
# 	, variables = letters[1:5]
# 	, colour_type = "stroke"
# 	, variable_type = "category"
# 	, title = "new legend"
# )
#
# js <- mapdeck_legend(c(l1, l2))
#
# mapdeck(
#   style = mapdeck_style('dark')
#   , location = c(145, -38)
#   , zoom = 8
#   ) %>%
#   add_polygon(
#     data = df
#     , polyline = "geometry"
#     , layer = "polygon_layer"
#     , fill_colour = "SA2_NAME"
#     , stroke_colour = "SA3_NAME"
#     , elevation = "elevation"
#     , tooltip = 'info'
#     , legend = js
#   )


# sf <- spatialwidget::widget_melbourne
# sf$my_colour <- ifelse( substr(sf$SA2_NAME, 1, 1) == "A", "#00FF00FF", "#FF0000FF")
#
# l1 <- legend_element(
# 	variables = c("begins with A", "Doesn't begin with A")
# 	, colours = c("#00FF00FF", "#FF0000FF")
# 	, colour_type = "fill"
# 	, variable_type = "category"
# )
# js <- mapdeck_legend(l1)
# js
# # {"fill_colour":{"colour":["#00FF00FF","#FF0000FF"],"variable":["begins with A","Doesn't begin with A"],"colourType":["fill_colour"],"type":["category"],"title":[""],"css":[""]}}
# mapdeck( ) %>%
# 	add_polygon(
# 		data = sf
# 		, fill_colour = "my_colour"
# 		, legend = js
# 	)

# library(googleway)
# library(mapdeck)
# library(sf)
#
# set_key( read.dcf("~/Documents/.googleAPI" ,fields = "GOOGLE_MAP_KEY"))
#
#
# sf <- spatialwidget::widget_melbourne
#
# sf$elev <- sf$AREASQKM * 1000
#
# google_map() %>%
# 	mapdeck_dependencies() %>%
# 	add_polygon(
# 		data = sf
# 		, fill_colour = "SA3_NAME"
# 	)
#
# #
# #
# mapdeck() %>%
# 	add_polygon(
# 		data = sf
# 		, elevation = "elev"
# 	)
