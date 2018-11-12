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
# shinyApp(ui, server)
