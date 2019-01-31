

library(shiny)
library(shinydashboard)
library(mapdeck)

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

		sf <- geojsonsf::geojson_sf( geojson )
		sf$random <- rnorm(n = nrow(sf))
		sf$width <- sample(1:100, size = nrow(sf), replace = TRUE)
		sf$elevation <- sample(100:1000, size = nrow(sf), replace = T)

		mapdeck_update(map_id = "map") %>%
			add_geojson(
				data = sf
				, fill_colour = "random"
				, stroke_colour = "random"
				, elevation = "elevation"
				, stroke_width = "width"
				, transitions = list(
					fill_colour = 1000
					, stroke_colour = 1000
					, stroke_width = 1000
					, elevation = 1000
					, radius = 600
				)
				, update_view = FALSE   ## stops the map upadting the viewport
			)
	})
}
shinyApp(ui, server)
