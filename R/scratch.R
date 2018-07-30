#
#
# library(shiny)
# library(shinydashboard)
# library(data.table)
# library(mapdeck)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar(
# 		shiny::uiOutput(outputId = "countries")
# 	)
# 	, dashboardBody(
# 		mapdeckOutput(outputId = "map")
# 	)
# )
#
# server <- function(input, output, session) {
#
# 	rv <- reactiveValues()
# 	rv$button_counter = 0
#
# 	observeEvent(input$button, {
# 		rv$button_counter <- rv$button_counter + 1
# 		session$sendCustomMessage("handler", rv$button_counter)
# 	})
#
# 	dt <- as.data.table(capitals)
# 	dt[, key := 1]
# 	dt[lat < 0, hemisphere := "south"]
# 	dt[lat >= 0, hemisphere := "north"]
#
#   key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
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
# 	dt_countries <- reactive({
#
# 		if(is.null(input$countries)) return()
#
# 		selected_country <- input$countries
#
# 		dt_plot <- dt[ country == selected_country, .(country_from = country, capital_from = capital, lat_from = lat, lon_from = lon, key)][
# 			dt[country != selected_country,  .(country_to = country, capital_to = capital, lat_to = lat, lon_to = lon, hemisphere, key) ]
# 			, on = "key"
# 			, allow.cartesian = T
# 			]
#
# 		return(dt_plot)
# 	})
#
# 	output$map <- renderMapdeck({
#
# 		dt_plot <- dt[ country == "United Kingdom of Great Britain and Northern Ireland", .(country_from = country, capital_from = capital, lat_from = lat, lon_from = lon, key)][
# 			dt[country != "United Kingdom of Great Britain and Northern Ireland" ,  .(country_to = country, capital_to = capital, lat_to = lat, lon_to = lon, hemisphere, key) ]
# 			, on = "key"
# 			, allow.cartesian = T
# 			]
#
# 		mapdeck(
# 			token = key
# 			, style = "mapbox://styles/mapbox/dark-v9"
# 			, pitch = 35
# 		) %>%
# 			add_arc(
# 				data = dt_plot
# 				, layer_id = "arc_layer"
# 				, origin = c("lon_from", "lat_from")
# 				, destination = c("lon_to", "lat_to")
# 				, stroke_from = "country_from"
# 				, id = "country_to"
# 				#, stroke_to = "hemisphere"
# 			) %>%
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
# 		input$countries
# 	}, {
# 		mapdeck_update('map') %>%
# 			add_arc(
# 				data = dt_countries()
# 				, layer_id = "arc_layer"
# 				, origin = c("lon_from", "lat_from")
# 				, destination = c("lon_to", "lat_to")
# 				, stroke_from = "country_from"
# 				, id = "country_to"
# 				#, stroke_to = "hemisphere"
# 			)
# 	})
# }
#
# shinyApp(ui, server)
#
