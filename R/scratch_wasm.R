library(shiny)
library(shinydashboard)
library(jsonify)

ui <- dashboardPage(
	dashboardHeader()
	, dashboardSidebar()
	, dashboardBody(
		mapdeckOutput(
			outputId = 'myMap'
		),
		actionButton(
			inputId = "btn"
			, label = "wasm"
		)
	)
)
server <- function(input, output) {

	output$myMap <- renderMapdeck({
		m <- mapdeck()
		print( str( m ) )
		m
	})


	observeEvent(input$btn,{
		mapdeck:::call_js()
	})


}

shinyApp(ui, server)
