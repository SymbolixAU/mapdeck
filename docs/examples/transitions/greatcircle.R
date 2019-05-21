

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

	df_orig <- capitals
	df_orig$key <- 1L
	df_dest <- capitals
	df_dest$key <- 1L
	df <- merge( df_orig, df_dest, by = "key" )
	df$key <- NULL
	df <- setNames( df, c("orig_country", "orig_capital", "orig_lat", "orig_lon",
												"dest_country", "dest_capital", "dest_lat", "dest_lon"))
	df <- df[ df$orig_country != df$dest_country, ]
	df$width <- sample(1:5, size = nrow(df), replace = T )

	output$map <- renderMapdeck({
		mapdeck( style = mapdeck_style("dark"), pitch = 35 )
	})

	observeEvent({input$btn},{

		r <- sample(1:nrow(df), size = 25, replace = FALSE)
		greatcircles <- df[r, ]
		mapdeck_update(map_id = "map") %>%
			add_greatcircle(
				data = greatcircles
				, origin = c("orig_lon", "orig_lat")
				, destination = c("dest_lon", "dest_lat")
				, stroke_from = "orig_country"
				, stroke_to = "dest_country"
				, stroke_width = "width"
				, transitions = list(
					origin = 2000
					, destination = 1000
					, stroke_from = 100
					, stroke_to = 3000
					, stroke_width = 600
				)
				, update_view = FALSE   ## stops the map upadting the viewport
			)
	})
}
shinyApp(ui, server)
