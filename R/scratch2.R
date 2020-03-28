#
# library(sf)
# library(sfheaders)
#
# sf <- mapdeck::roads
#
# set_token( read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
#
# df <- sf_to_df(sf, fill = TRUE)
# library(data.table)
# setDT( df )
# df[, val := 1:.N, by = linestring_id]
# summary(df$val)
# #head( df )
# #df$val <- 1:nrow(df)
#
# df <- df[ df[ , .I[max(val) > 20], by = linestring_id ]$V1 ]
# setorder(df, linestring_id)
#
# sf <- sf_linestring(
# 	obj = df
# 	, x = "x"
# 	, y = "y"
# 	, linestring_id = "linestring_id"
# 	, keep = TRUE
# 	, list_columns = "val"
# )
#
# mapdeck(
# 	style = mapdeck_style("light")
# ) %>%
# 	add_path(
# 		data = sf
# 		, stroke_colour = "val"
# 	)
#
#
# df <- data.frame(
# 	x = c(0,0.2,0.25,-0.3,-0.2,0.0)
# 	, y = c(0,0.2,0.25,0.3,0.2,0.0)
# 	, val = c(1:6)
# 	, id = c(1,1,1,2,2,2)
# )
#
# sf_line <- sf_linestring(
# 	obj = df
# 	, x = "x"
# 	, y = "y"
# 	, linestring_id = "id"
# 	, keep = TRUE
# 	, list_columns = "val"
# )
#
#
# mapdeck() %>%
# 	add_path(
# 		data = sf_line
# 		, stroke_colour = "val"
# 	)
#
#
#
#
#
#
#
#
#
