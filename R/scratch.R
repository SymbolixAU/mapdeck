#
# library(shiny)
# library(shinydashboard)
# library(mapdeck)
# library(data.table)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar(
# 		uiOutput(
# 			outputId = "countries"
# 		)
# 		, radioButtons(
# 			inputId = "transition"
# 			, label = "transition"
# 			, choices = c("fly", "linear")
# 		)
# 	)
# 	, dashboardBody(
# 		box(
# 			width = 12
#   		, mapdeckOutput(
#   			outputId = "map"
#   			# , height = "600px"
#   		)
# 		)
# 	)
# )
#
# server <- function(input, output, session) {
#
# 	key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
# 	dt <- as.data.table(capitals)
#
# 	output$countries <- renderUI({
# 		selectInput(
# 			inputId = "countries"
# 			, label = "Countries"
# 			, choices = dt[, country]
# 			, selected = "United Kingdom of Great Britain and Northern Ireland"
# 		)
# 	})
#
# 	selected_country <- reactive({
# 		as.numeric( dt[country == input$countries, .(lon, lat)] )
# 	})
#
# 	output$map <- renderMapdeck({
#
# 		if(is.null(dt) || is.null(dt)) return()
#
# 		mapdeck(
# 			token = key
# 			, style = "mapbox://styles/mapbox/dark-v9"
# 			, pitch = 35
# 		) %>%
# 			add_scatterplot(
# 				data = dt
# 				, lat = "lat"
# 				, lon = "lon"
# 				, radius = 100000
# 				, fill_colour = "country"
# 				, layer_id = "scatter"
# 			)
# 	})
#
# 	observeEvent({
# 		c(input$countries)
# 	}, {
# 		if(is.null(input$transition) || is.null(selected_country())) return()
#
# 		mapdeck_update('map') %>%
# 			mapdeck_view(
# 				location = selected_country()
# 				, transition = input$transition
# 				, duration = 2000
# 				, zoom = 4
# 			)
# 	})
# }
# shinyApp(ui, server)
#

# mapdeck(
# 	token = key
# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	, pitch = 35
# ) %>%
# 	add_geojson(
# 		data = geojson
# 		, layer_id = "geojson"
# 	)
