library(shiny)
library(shinydashboard)
library(mapdeck)

url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
flights <- read.csv(url)
flights$id <- seq_len(nrow(flights))
flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")

ui <- dashboardPage(
	dashboardHeader()
	, dashboardSidebar(
		actionButton(inputId = "arc", label = "arc")
		, actionButton(inputId = "geojson", label = "geojson")
		, actionButton(inputId = "grid", label = "grid")
		, actionButton(inputId = "hexagon", label = "hexagon")
		, actionButton(inputId = "line", label = "line")
		, actionButton(inputId = "path", label = "path")
		, actionButton(inputId = "pointcloud", label = "pointcloud")
		, actionButton(inputId = "polygon", label = "polygon")
		, actionButton(inputId = "scatterplot", label = "scatterplot")
		, actionButton(inputId = "screengrid", label = "screengrid")
		, actionButton(inputId = "text", label = "text")
	)
	, dashboardBody(
		mapdeckOutput(
			outputId = "map"
		)
	)
)

server <- function( input, output ) {

	set_token( Sys.getenv("MAPBOX") )

	output$map <- renderMapdeck({
		mapdeck()
	})

	observeEvent({input$arc},{
		res <- input$arc %% 2
		if( res == 1 ) {
			mapdeck_update(map_id = "map") %>%
				add_arc(
					data = flights
				  , origin = c("start_lon", "start_lat")
				  , destination = c("end_lon", "end_lat")
				  , stroke_from = "airport1"
				  , stroke_to = "airport2"
					, legend = TRUE
				)
		} else {
			mapdeck_update(map_id = "map") %>%
				clear_arc()
		}
	})


	observeEvent({input$path},{
		res <- input$path %% 2
		if( res == 1 ) {
			mapdeck_update(map_id = "map") %>%
				add_path(
					data = roads
					, stroke_colour = "RIGHT_LOC"
					, legend = TRUE
				)
		} else {
			mapdeck_update(map_id = "map") %>%
				clear_path()
		}
	})

}

shinyApp(ui, server)
