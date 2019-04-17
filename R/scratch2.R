# library(shiny)
# library(shinydashboard)
# library(mapdeck)
# library(googleway)
#
# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
# flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar(
# 		actionButton(inputId = "scatterplot", label = "scatterplot")
# 	)
# 	, dashboardBody(
# 		mapdeck::mapdeck_dependencies()
# 		, googleway::google_mapOutput(
# 		#, mapdeck::mapdeckOutput(
# 			outputId = "map"
# 		)
# 	)
# )
#
# server <- function( input, output ) {
#
# 	set_token( read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# 	set_key( read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY"))
#
# 	output$map <- googleway::renderGoogle_map({
# 		googleway::google_map() %>%
# 		  mapdeck::add_dependencies()
# 		#mapdeck()
# 	})
#
# 	observeEvent({input$scatterplot},{
#
# 		mapdeck_update(map_id = "map") %>%
# 			add_scatterplot(
# 				data = capitals
# 				, lon = "lon"
# 				, lat = "lat"
# 				, fill_colour = "country"
# 				, legend = TRUE
# 			)
# 	})
#
# }
#
# shinyApp(ui, server)
