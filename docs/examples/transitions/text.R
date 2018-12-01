

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
		mapdeck( style = mapdeck_style("dark"), zoom = 1 )
	})

	observeEvent({input$btn},{

		r <- sample( 1:nrow(capitals), size = nrow(capitals) )
		df <- capitals[ r,  ]
		df$size <- sample( 20:40, size = nrow(df), replace = T )

		mapdeck_update(map_id = "map") %>%
			add_text(
				data = df
				, lon = "lon"
				, lat = "lat"
				, text = "capital"
				, fill_colour = "country"
				, size = "size"
				, transitions = list(
					position = 2000
					, fill_colour = 1000
					, size = 1000
					, angle = 1000
				)
				, update_view = FALSE   ## stops the map upadting the viewport
			)
	})
}
shinyApp(ui, server)
