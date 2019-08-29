library(shiny)
library(shinydashboard)

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
		mapdeck() %>%
			add_scatterplot(
				data = capitals
			)
	})


	observeEvent(input$btn,{
		mapdeck:::call_js()
	})


}

shinyApp(ui, server)
