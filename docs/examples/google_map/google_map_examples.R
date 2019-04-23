
library(googleway)
library(mapdeck)

set_key( read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY") )

## Arc

url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
flights <- read.csv(url)
flights$id <- seq_len(nrow(flights))
flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")

google_map() %>%
	add_dependencies() %>%
	add_arc(
		data = flights
		, origin = c("start_lon", "start_lat")
		, destination = c("end_lon", "end_lat")
		, stroke_from = "airport1"
		, stroke_to = "airport2"
		, stroke_width = "stroke"
		, tooltip = "info"
		, auto_highlight = TRUE
		, legend = T
		, legend_options = list(
			stroke_from = list( title = "Origin airport" ),
			css = "max-height: 100px;")
	)


## Geojson

google_map() %>%
	add_dependencies() %>%
	mapdeck::add_geojson(
		data = mapdeck::geojson
	)

## great circles

google_map() %>%
	add_dependencies() %>%
	mapdeck::add_greatcircle(
		data = flights
		, origin = c("start_lon", "start_lat")
		, destination = c("end_lon", "end_lat")
		, stroke_from = "airport1"
		, stroke_to = "airport2"
		, stroke_width = "stroke"
	)

## grid

df <- read.csv(paste0(
	'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
	'examples/3d-heatmap/heatmap-data.csv'
))

df <- df[ !is.na( df$lng ), ]

google_map(location = c(52, 0), zoom = 6) %>%
	add_dependencies() %>%
	add_grid(
		data = df[1:50000, ]
		, lat = "lat"
		, lon = "lng"
		, cell_size = 1000
		, elevation_scale = 50
	)

## Lines

google_map() %>%
	add_dependencies() %>%
	add_line(
		data = flights
		, origin = c("start_lon", "start_lat")
		, destination = c("end_lon", "end_lat")
		, stroke_colour = "airport1"
		, stroke_width = "stroke"
	)


## Path
library(sf)
google_map() %>%
	add_dependencies() %>%
	add_path(
		data = mapdeck::roads[1:1000, ]
		, stroke_colour = "RIGHT_LOC"
	)


## Pointcloud
capitals$z <- sample(10000:10000000, size = nrow(capitals))

google_map() %>%
	add_dependencies() %>%
	add_pointcloud(
		data = capitals
		, lon = 'lon'
		, lat = 'lat'
		, elevation = 'z'
		, fill_colour = "country"
	)


## Polygons

library(sf)
library(geojsonsf)

sf <- geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
sf$e <- sf$AREASQKM16 * 10

google_map() %>%
	add_dependencies() %>%
	mapdeck::add_polygon(
		data = sf[ data.table::`%like%`(sf$SA4_NAME16, "Melbourne"), ]
		, fill_colour = "SA2_NAME16"
		, elevation = "e"
	)

## Scatter

google_map() %>%
	add_dependencies() %>%
	add_scatterplot(
		data = capitals
		, lat = "lat"
		, lon = "lon"
		, radius = 500000
		, fill_colour = "country"
		, palette = "plasma"
	)

## Screengrid

df <- df[ !is.na(df$lng), ]

df$weight <- sample(1:10, size = nrow(df), replace = T)

google_map(location = c(52, 0), zoom = 4) %>%
	add_dependencies() %>%
	add_screengrid(
		data = df
		, lat = "lat"
		, lon = "lng"
		, weight = "weight"
		, cell_size = 10
		, opacity = 0.3
		, colour_range = colourvalues::colour_values(1:6, palette = "plasma")
	)


## Text

google_map() %>%
	add_dependencies() %>%
	add_text(
		data = capitals
		, lon = 'lon'
		, lat = 'lat'
		, fill_colour = 'country'
		, text = 'capital'
		, layer_id = 'text'
		, size = 16
	)


## Multiple layers

df1 <- capitals[ capitals$country == "Australia", ]
df2 <- capitals[ capitals$country != "Australia", ]
df1$key <- 1L
df2$key <- 1L

df <- merge(df1, df2, by = 'key')

google_map() %>%
	add_dependencies() %>%
	add_arc(
		data = df
		, origin = c("lon.x", "lat.x")
		, destination = c("lon.y", "lat.y")
		, layer_id = "arc_layer"
		, stroke_from = "country.x"
		, stroke_to = "country.y"
		, stroke_width = 2
	) %>%
	add_scatterplot(
		data = df2
		, lon = "lon"
		, lat = "lat"
		, radius = 100000
		, fill_colour = "country"
		, layer_id = "scatter"
	)
