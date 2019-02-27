
# js <- '{"id": "terrain-data",
# 	"type": "line",
# 	"source": {
# 		"type": "vector",
# 		"url": "mapbox://mapbox.mapbox-terrain-v2"
# 	},
# 	"source-layer": "contour",
# 	"layout": {
# 		"line-join": "round",
# 		"line-cap": "round"
# 	},
# 	"paint": {
# 		"line-color": "#000000",
# 		"line-width": 1
# 	}}'
#
# mapbox(
# 	style = mapdeck_style("light")
# 	, location = c(-122.44, 37.753)
# 	, zoom = 10
# 	) %>%
# 	add_vector_source( js )
