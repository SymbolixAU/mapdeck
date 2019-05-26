

library(shiny)
library(shinydashboard)
library(mapdeck)
library(googleway)

ui <- dashboardPage(
	dashboardHeader()
	, dashboardSidebar()
	, dashboardBody(
		mapdeck::mapdeck_dependencies()
		,googleway::google_mapOutput(
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
	#set_key( Sys.getenv("GOOGLE_MAP"))

	output$map <- renderMapdeck({
		#mapdeck( style = mapdeck_style("dark"), zoom = 1 )
		googleway::google_map(location = c(0,0), zoom = 1) %>%
			mapdeck::add_dependencies()
	})

	observeEvent({input$btn},{

		r <- sample( 1:nrow(capitals), size = nrow(capitals) )
		df <- capitals[ r,  ]
		df$r <- sample(100000:500000, nrow(df), replace = T)

		googleway::google_map_update(map_id = "map") %>%
			mapdeck::add_scatterplot(
				data = df
				, lon = "lon"
				, lat = "lat"
				, radius = "r"
				, fill_colour = "country"
				, transitions = list(
					position = 2000
					, fill_colour = 1000
					, radius = 1000
				)
				, update_view = FALSE   ## stops the map upadting the viewport
			)
	})
}
shinyApp(ui, server)
