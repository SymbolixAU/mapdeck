library(shiny)
library(shinydashboard)
library(mapdeck)
library(googleway)
library(sf)

url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
flights <- read.csv(url)
flights$id <- seq_len(nrow(flights))
flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")

ui <- dashboardPage(
	dashboardHeader()
	, dashboardSidebar(
		actionButton(inputId = "arc", label = "arc")
		, actionButton(inputId = "path", label = "path")
		, actionButton(inputId = "scatterplot", label = "scatterplot")
		, actionButton(inputId = "polygon", label = "polygon")
	)
	, dashboardBody(
		mapdeck::mapdeck_dependencies()  ## add JS dependencies
		, googleway::google_mapOutput(
			outputId = "map"
			, height = "600"
		)
	)
)

server <- function( input, output ) {

	#set_token( Sys.getenv("MAPBOX") )

	output$map <- googleway::renderGoogle_map({
		googleway::google_map() %>%
			mapdeck::add_dependencies()  ## specific mapdeck map dependencies
	})

	observeEvent({input$arc},{
		res <- input$arc %% 2
		if( res == 1 ) {
			googleway::google_map_update(map_id = "map") %>%
				mapdeck::add_arc(
					data = flights
					, origin = c("start_lon", "start_lat")
					, destination = c("end_lon", "end_lat")
					, stroke_from = "airport1"
					, stroke_to = "airport2"
					, legend = TRUE
				)
		} else {
			googleway::google_map_update(map_id = "map") %>%
				mapdeck::clear_arc()
		}
	})


	observeEvent({input$path},{
		res <- input$path %% 2
		if( res == 1 ) {
			googleway::google_map_update(map_id = "map") %>%
				mapdeck::add_path(
					data = roads[1:200, ]
					, stroke_colour = "RIGHT_LOC"
					, legend = TRUE
				)
		} else {
			googleway::google_map_update(map_id = "map") %>%
				mapdeck::clear_path()
		}
	})

	observeEvent({input$scatterplot},{
		res <- input$scatterplot %% 2
		if( res == 1 ) {
			googleway::google_map_update(map_id = "map") %>%
				mapdeck::add_scatterplot(
					data = capitals
					, lon = "lon"
					, lat = "lat"
					, fill_colour = "country"
					, legend = TRUE
				)
		} else {
			googleway::google_map_update(map_id = "map") %>%
				mapdeck::clear_scatterplot()
		}
	})

	observeEvent({input$polygon},{
		res <- input$polygon %% 2
		if( res == 1 ) {
			googleway::google_map_update(map_id = "map") %>%
				mapdeck::add_polygon(
					data = mapdeck::melbourne
					, fill_colour = "SA2_NAME"
					, legend = TRUE
				)
		} else {
			googleway::google_map_update(map_id = "map") %>%
				mapdeck::clear_polygon()
		}
	})

}

shinyApp(ui, server)
