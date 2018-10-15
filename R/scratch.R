#
#
# library(shiny)
# library(shinydashboard)
#
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
