

library(shiny)
library(shinydashboard)
library(mapdeck)
library(sf)
library(geojsonsf)

ui <- dashboardPage(
	dashboardHeader()
	, dashboardSidebar()
	, dashboardBody(
		mapdeckOutput(
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

	set_token( Sys.getenv("MAPBOX") )


	output$map <- renderMapdeck({
		mapdeck( style = mapdeck_style("dark"), pitch = 65, location = c(145, -37.8), zoom = 10 )
	})

	observeEvent({input$btn},{

		df <- mapdeck::melbourne
		df$z <- sample(100:5000, size = nrow(df))
		df$col <- rnorm( n = nrow( df ) )

		mapdeck_update(map_id = "map") %>%
			add_polygon(
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
