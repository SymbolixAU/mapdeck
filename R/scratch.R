# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
# flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#
# origins <- flights[, c("start_lon", "start_lat")]
# destinations <- flights[, c("end_lon", "end_lat")]
#
# library(shiny)
# library(shinydashboard)
# library(dashboardthemes)
# library(mapdeck)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		shinyDashboardThemes(
# 			theme = "grey_dark"
# 		)
# 		, box(
# 			width = 12
# 			, mapdeck::mapdeckOutput(
# 				outputId = "map"
# 				, height = "600"
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
# 	set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck(
# 			style = mapdeck::mapdeck_style("dark")
# 			, pitch = 45
# 		)
# 	})
#
# 	observeEvent({input$width},{
#
# 		flights$stroke <- sample(0:5, size = nrow(flights), replace = TRUE)
# 		flights$rand <- sample(0:3, size = nrow(flights), replace = TRUE)
# 		flights$start_lat <- sample(origins$start_lat, size = nrow(flights), replace = FALSE)
# 		flights$start_lon <- sample(origins$start_lon, size = nrow(flights), replace = FALSE)
# 		flights$start_lat <- sample(destinations$end_lat, size = nrow(flights), replace = FALSE)
# 		flights$end_lon <- sample(destinations$end_lon, size = nrow(flights), replace = FALSE)
#
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_arc(
# 				data = flights
# 				, layer_id = "arc_layer"
# 				, origin = c("start_lon", "start_lat")
# 				, destination = c("end_lon", "end_lat")
# 				, stroke_from = "rand"
# 				, stroke_to = "airport2"
# 				, stroke_width = "stroke"
# 				, tooltip = "info"
# 				, auto_highlight = TRUE
# 				, update_view = FALSE
# 			)
#
# 	})
#
# }
#
# shinyApp(ui, server)
#
