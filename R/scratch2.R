#
# library(sf)
# library(geojsonsf)
#
# sf_earth <- geojsonsf::geojson_sf('https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_admin_0_scale_rank.geojson')
# geo_earth <- geojsonsf::sf_geojson( sf_earth )
# # sf_arcs <- geojsonsf::geojson_sf('https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_10m_airports.geojson')
# # geo_arcs <- geojsonsf::sf_geojson( sf_arcs )
#
#
# df <- mapdeck::capitals
#
# head( df )
#
# df_aus <- df[ df$country == "Australia", ]
# df_all <- df[ df$country != "Australia", ]
#
# df_aus$key <- 1L
# df_all$key <- 1L
#
# df <- merge(
# 	x = df_aus
# 	, y = df_all
# 	, by = "key"
# )
#
#
#
#
# globedeck() %>%
# 	add_geojson(
# 		data = geo_earth
# 		, layer_id = "earth"
# 		, fill_colour = "sr_subunit"
# 	) %>%
# 	add_animated_arc(
# 		data = df
# 		, origin = c("lon.x", "lat.x")
# 		, destination = c("lon.y", "lat.y")
# 		, stroke_from = "country.x"
# 		, stroke_to = "country.y"
# 	)
#
#
# df_background <- data.frame(
# 	x = c(-180, 0, 180, 180, 0, -180)
# 	, y = c(90, 90, 90, -90, -90, -90)
# )
#
# sf_poly <- sfheaders::sf_polygon(obj = df_background)
#
# globedeck(cull = T) %>%
# 	add_polygon(
# 		data = sf_poly
# 		, fill_colour = "#0000FF80"
# 	) %>%
# 	add_geojson(
# 		data = geo_earth
# 		, layer_id = "earth"
# 		, fill_colour = "sr_subunit"
# 	) %>%
# 	add_arc(
# 		data = df
# 		, origin = c("lon.x", "lat.x")
# 		, destination = c("lon.y", "lat.y")
# 		, stroke_from = "country.x"
# 		, stroke_to = "country.y"
# 	)
#
