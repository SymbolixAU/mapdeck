#
#
#
# df <- melbourne  ## data.frame with encoded polylnies
# df$elevation <- sample(100:5000, size = nrow(df))
# df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
# js <- mapdeck_legend(colours = colourvalues::colour_values(1:5), variables = letters[1:5], colour_type = "fill", variable_type = "category", title = "new legend")
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
#     , elevation = "elevation"
#     , tooltip = 'info'
#     , legend = js
#   )
