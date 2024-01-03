
sf <- gpx_sf( system.file("./gpx/city_trail.gpx", package = "gpx") )

city_trail <- sf

usethis::use_data(city_trail)

mapdeck(
	location = c(145, -37.8)
	, zoom = 10
	, style = mapdeck_style("dark")
) %>%
	add_trips(
		data = sf
		, animation_speed = 2000
		, trail_length = 1000
		, stroke_colour = "#FFFFFF"
	)

# mapdeck() %>%
# 	add_path( data = sf )

# library(sf)
# sf <- sf::st_read( system.file("./shape/storms_xyzm.shp", package = "sf"))
#
# df <- sfheaders::sf_to_df( sf )
# df$z <- 0
#
# sf <- sfheaders::sf_linestring(obj = df, x = "x", y = "y", z = "z", m = "m", linestring_id = "linestring_id")

