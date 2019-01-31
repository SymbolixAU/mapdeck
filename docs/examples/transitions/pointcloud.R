

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
		mapdeck( style = mapdeck_style("dark"), pitch = 65, zoom = 1 )
	})

	observeEvent({input$btn},{

		r <- sample( 1:nrow(capitals), size = nrow(capitals) )
		df <- capitals[ r,  ]
		df$z <- sample(10000:10000000, size = nrow(df))

		mapdeck_update(map_id = "map") %>%
			add_pointcloud(
				data = df
				, lon = "lon"
				, lat = "lat"
				, elevation = "z"
				, fill_colour = "country"
				, transitions = list(
					position = 2000
					, fill_colour = 1000
				)
				, update_view = FALSE   ## stops the map upadting the viewport
			)
	})
}
shinyApp(ui, server)
