# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
# set_token( key )
#
# mapdeck() %>%
# 	add_geojson(
# 		data = roads[1:3, ]
# 	)

# library(sf)
# nc <- sf::st_read( system.file("shape/nc.shp", package = "sf"))
#
# library(shiny)
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		box(
# 			width = 8
# 			, mapdeckOutput(
# 				outputId = "map"
# 			)
# 		)
# 		, sliderInput(
# 			inputId = "airports"
# 			, label = "airports"
# 			, min = 1
# 			, max = 178
# 			, step = 1
# 			, value = 178
# 		)
# 	)
# )
#
# server <- function( input, output ) {
# 	output$map <- renderMapdeck({
# 		mapdeck()
# 	})
#
# 	observeEvent({input$airports},{
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_arc(
# 				data = sf_flights[1:input$airports, ]
# 				, origin = "geometry"
# 				, destination = "geometry.1"
# 				, stroke_from = "airport1"
# 				, stroke_to = "airport2"
# 			)
# 	})
# }
#
# shinyApp( ui, server )


#
# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
# flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#
# library(shiny)
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		box(
# 			width = 8
# 			, mapdeck::mapdeckOutput(
# 				outputId = "map"
# 			)
# 			, sliderInput(
# 				inputId = "width"
# 				, label = "stroke width"
# 				, min = 0
# 				, max = 10
# 				, value = 2
# 			)
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck(
# 			style = mapdeck::mapdeck_style("dark")
# 			, pitch = 45
# 		)
# 	})
#
# 	observeEvent({input$width},{
#
# 		flights$stroke <- input$width
#
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_arc(
# 				data = flights
# 				, layer_id = "arc_layer"
# 				, origin = c("start_lon", "start_lat")
# 				, destination = c("end_lon", "end_lat")
# 				, stroke_from = "airport1"
# 				, stroke_to = "airport2"
# 				, stroke_width = "stroke"
# 				, tooltip = "info"
# 				, auto_highlight = TRUE
# 			)
#
# 	})
#
# }
#



# library(shiny)
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		box(
# 			width = 12
# 			, mapdeck::mapdeckOutput(
# 				outputId = "map"
# 				, height = "600"
# 			)
# 		)
# 		, sliderInput(
# 			inputId = "radius"
# 			, label = "radius"
# 			, min = 0
# 			, max = 100000
# 			, value = 5000
# 			, animate = animationOptions(interval = 300, loop = T)
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck(
# 			style = mapdeck::mapdeck_style("dark")
# 		)
# 	})
#
# 	observeEvent({input$radius},{
#
# 		capitals$radius <- sample(1000:1000000, size = nrow(capitals))
#
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_scatterplot(
# 				data = capitals
# 				, lon = "lon"
# 				, lat = "lat"
# 				, fill_colour = "country"
# 				, radius = "radius"
# 			)
# 	})
# }
#
# shinyApp(ui, server)

#
# library(shiny)
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		box(
# 			width = 12
# 			, mapdeck::mapdeckOutput(
# 				outputId = "map"
# 				, height = "600"
# 			)
# 		)
# 		, sliderInput(
# 			inputId = "radius"
# 			, label = "radius"
# 			, min = 0
# 			, max = 3
# 			, value = 1
# 			, step = 0.05
# 			, animate = animationOptions(interval = 300, loop = T)
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck(
# 			style = mapdeck::mapdeck_style("dark")
# 		)
# 	})
#
# 	observeEvent({input$radius},{
#
# 		roads$width <- sample(sample(seq(0,3,by = 0.05)), size = nrow(roads), replace = T)
#
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_path(
# 				data = roads
# 				, stroke_colour = "RIGHT_LOC"
# 				, stroke_width = "width"
# 			)
# 	})
# }
#
# shinyApp(ui, server)

# library(shiny)
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		box(
# 			width = 12
# 			, mapdeck::mapdeckOutput(
# 				outputId = "map"
# 				, height = "600"
# 			)
# 		)
# 		, actionButton(
# 			inputId = "button"
# 			, label = "colour"
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck(
# 			style = mapdeck::mapdeck_style("dark")
# 		)
# 	})
#
# 	observeEvent({input$button},{
#
# 		vals <- sample(rnorm(n = nrow(roads)))
# 		roads$colour <- colourvalues::colour_values(vals)
#
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_path(
# 				data = roads
# 				, stroke_colour = "colour"
# 			)
# 	})
# }
#
# shinyApp(ui, server)



# library(shiny)
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		box(
# 			width = 12
# 			, mapdeck::mapdeckOutput(
# 				outputId = "map"
# 				, height = "600"
# 			)
# 		)
# 		, sliderInput(
# 			inputId = "row"
# 			, label = "row"
# 			, min = 1
# 			, max = 18286
# 			, value = 1
# 			, step = 1
# 			, animate = animationOptions(interval = 100, loop = T)
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck(
# 			style = mapdeck::mapdeck_style("dark")
# 		)
# 	})
#
# 	observeEvent({input$row},{
#
# 		#roads$width <- sample(sample(seq(0,3,by = 0.05)), size = nrow(roads), replace = T)
# 		r <- input$row
# 		max_r <- nrow(roads) + (r - 1)
# 		roads$colour <- r:max_r %% nrow(roads)
#
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_path(
# 				data = roads
# 				, stroke_colour = "colour"
# 			)
# 	})
# }
#
# shinyApp(ui, server)


# library(shiny)
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		box(
# 			width = 12
# 			, mapdeck::mapdeckOutput(
# 				outputId = "map"
# 				, height = "600"
# 			)
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck(
# 		 token = key
# 		 , location = c(145, -37.9)
# 		 , zoom = 8
# 		 , style = "mapbox://styles/mapbox/dark-v9"
# 		 , pitch = 35
# 		) %>%
# 		 add_geojson(
# 		   data = geojson
# 		   , layer_id = "geojson"
# 		   , auto_highlight = TRUE
# 		 )
# 	})
#
# 	observeEvent({input$map_geojson_click},{
#
# 		print( input$map_geojson_click )
#
# 	})
# }
#
# shinyApp(ui, server)



