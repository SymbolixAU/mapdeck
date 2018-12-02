

library(shiny)
library(shinydashboard)
library(mapdeck)
library(sf)      ## for printing & subsetting {roads}

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
		mapdeck( style = mapdeck_style("dark"), location = c(145, -37.8), zoom = 12 )
	})

	observeEvent({input$btn},{

		r <- sample(1:nrow(roads), size = nrow(roads))
	  df <- roads[r, ]
		df$rand_colour <- rnorm(n = nrow(df))
		df$rand_width <- sample(1:2, size = nrow(df), replace = T)

		mapdeck_update(map_id = "map") %>%
			add_path(
				data = df
				, stroke_colour = "rand_colour"
				, stroke_width = "rand_width"
				, transitions = list(
					path = 2000
					, stroke_colour = 1000
					, stroke_width = 1000
				)
				, update_view = FALSE   ## stops the map upadting the viewport
			)
	})
}
shinyApp(ui, server)
