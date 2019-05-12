

library(shiny)
library(shinydashboard)
library(mapdeck)
library(googleway)
library(sf)
library(geojsonsf)

ui <- dashboardPage(
	dashboardHeader()
	, dashboardSidebar()
	, dashboardBody(
		mapdeck::mapdeck_dependencies()
		, googleway::google_mapOutput(
			outputId = "map"
			, height = "600"
		)
		, actionButton(
			inputId = "btn"
			, label = "button"
		)
	)
)

server <- function( input, output ) {

	#set_token( Sys.getenv("MAPBOX") )


	output$map <- googleway::renderGoogle_map({
		googleway::google_map()
	})

	observeEvent({input$btn},{

		df <- mapdeck::melbourne
		df$z <- sample(100:5000, size = nrow(df))
		df$col <- rnorm( n = nrow( df ) )

		google_map_update(map_id = "map") %>%
			mapdeck::add_polygon(
				data = df
				, fill_colour = "col"
				, elevation = "z"
				, transitions = list(
					polygon = 2000
					, fill_colour = 1000
					, stroke_width = 1000
					, elevation = 1000
				)
				, update_view = FALSE   ## stops the map upadting the viewport
			)
	})
}
shinyApp(ui, server)
