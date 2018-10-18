#
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
#
# df <- melbourne
# df$elevation <- sample(100:5000, size = nrow(df))
# df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
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
# 		, stroke_colour = "strokeWeight"
# 		, elevation = "elevation"
# 		, stroke_width = 0
# 		, tooltip = 'info'
# 		, legend = T
# 	) %>%
# 	add_polygon(
# 		data = df
# 		, polyline = "geometry"
# 		, layer = "another_layer"
# 		, fill_colour = "elevation",
# 		, elevation = "elevation"
# 		, stroke_width = 0
# 		, tooltip = 'info'
# 		, legend = T
# 	) %>%
# 	clear_legend( "polygon_layer" )


# library(shiny)
# library(shinydashboard)
# library(mapdeck)
# set_token(read.dcf("~/.googleAPI", fields = "MAPBOX"))
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar(
# 		selectInput(
# 			inputId = "elevation"
# 			, label = "elevation"
# 			, choices = c(seq(100,5000, by = 500))
# 		)
# 		, actionButton(
# 			inputId = "clear"
# 			, label = "clear"
# 		)
# 	)
# 	, dashboardBody(
# 		mapdeckOutput(
# 			outputId = "map"
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	df <- melbourne
# 	df$elevation <- sample(200:5000, size = nrow(df))
# 	df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
# 	output$map <- renderMapdeck({
# 		mapdeck(
# 			style = mapdeck_style('dark')
# 			, location = c(145, -38)
# 			, zoom = 8
# 		)
# 	})
#
# 	observeEvent({input$elevation},{
# 		if(is.null(input$elevation)) return()
# 		df_plot <- df[df$elevation <= as.numeric(input$elevation), ]
# 		if(nrow(df_plot) == 0) return()
#
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_polygon(
# 				data = df_plot
# 				, polyline = "geometry"
# 				, layer = "polygon_layer"
# 				, fill_colour = "SA2_NAME"
# 				, elevation = "elevation"
# 				, stroke_width = 0
# 				, tooltip = 'info'
# 				, legend = T
# 			)
# 	})
#
# 	observeEvent({input$clear},{
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			clear_polygon(
# 				layer_id = "polygon_layer"
# 			)
# 	})
#
# }
# shinyApp(ui, server)

# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
# flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#

# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, location = c(145, -37.8)
# 	, zoom = 10) %>%
# 	add_path(
# 		data = roads
# 		, stroke_colour = "RIGHT_LOC"
# 		, layer_id = "path_layer"
# 		, tooltip = "ROAD_NAME"
# 		, auto_highlight = TRUE
# 		, legend = T
# 	)

# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, pitch = 45
# 	) %>%
# 	add_scatterplot_old(
# 		data = capitals
# 		, lat = "lat"
# 		, lon = "lon"
# 		, radius = 100000
# 		, fill_colour = "country"
# 		, layer_id = "scatter_layer"
# 		, tooltip = "capital"
# 		, legend = T
# 	)

# df <- capitals
# df$z <- sample(10000:10000000, size = nrow(df))
#
# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	) %>%
# 	add_pointcloud(
# 		data = df
# 		, lon = 'lon'
# 		, lat = 'lat'
# 		, elevation = 'z'
# 		, layer_id = 'point'
# 		, fill_colour = "country"
# 		, tooltip = "country"
# 		, legend = T
# 	)

# key <- 'abc'
#
# df <- read.csv(paste0(
# 	'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
# 	'examples/3d-heatmap/heatmap-data.csv'
# ))
#
# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, pitch = 45
# 	) %>%
# 	add_grid(
# 		data = df
# 		, lat = "lat"
# 		, lon = "lng"
# 		, cell_size = 5000
# 		, elevation_scale = 50
# 		, layer_id = "grid_layer"
# 		, auto_highlight = TRUE
# 	)


# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
#
# mapdeck( style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
# 	add_line(
# 		data = flights
# 		, layer_id = "line_layer"
# 		, origin = c("start_lon", "start_lat")
# 		, destination = c("end_lon", "end_lat")
# 		, stroke_colour = "airport1"
# 		, stroke_width = "stroke"
# 		, auto_highlight = TRUE
# 		, legend = TRUE
# 	)

