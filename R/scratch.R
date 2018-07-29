

# ## ON CLICK
# library(shiny)
# library(data.table)
#
# ui <- fluidPage(
# 	mapdeckOutput(outputId = "map")
# )
#
# server <- function(input, output) {
#
# 	dt <- as.data.table(capitals)
# 	key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
#
# 	dt[, key := 1]
# 	dt[lat < 0, hemisphere := "south"]
# 	dt[lat >= 0, hemisphere := "north"]
#
# 	dt <- dt[ country == "United Kingdom of Great Britain and Northern Ireland", .(country_from = country, capital_from = capital, lat_from = lat, lon_from = lon, key)][
# 		dt[,  .(country_to = country, capital_to = capital, lat_to = lat, lon_to = lon, hemisphere, key) ]
# 		, on = "key"
# 		, allow.cartesian = T
# 		]
#
# 	output$map <- renderMapdeck({
#
# 		mapdeck(
# 			token = access_token
# 			, style = "mapbox://styles/mapbox/dark-v9"
# 			, pitch = 35
# 		) %>%
# 			add_arc(
# 				data = dt
# 				, lat_from = "lat_from"
# 				, lat_to = "lat_to"
# 				, lon_from = "lon_from"
# 				, lon_to = "lon_to"
# 				, stroke_from = "country_from"
# 				, id = "country_to"
# 				#, stroke_to = "hemisphere"
# 			)
# 	})
#
# 	observeEvent({input$map_arc_click}, {
# 		print(input$map_arc_click)
# 	})
# }
#
# shinyApp(ui, server)



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
# server <- function(input, output) {
#
# 	dt <- as.data.table(capitals)
# 	dt[, key := 1]
# 	dt[lat < 0, hemisphere := "south"]
# 	dt[lat >= 0, hemisphere := "north"]
#
# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
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
# 		print(dt_plot)
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
# 		print("reinitialising map")
# 		print(dt_plot)
#
		# mapdeck(
		# 	token = access_token
		# 	, style = "mapbox://styles/mapbox/dark-v9"
		# 	, pitch = 35
		# ) %>%
		# 	add_arc(
		# 		data = dt_plot
		# 		, layer_id = "arc_layer"
		# 		, origin = c("lon_from", "lat_from")
		# 		, destination = c("lon_to", "lat_to")
		# 		, stroke_from = "country_from"
		# 		, id = "country_to"
		# 		#, stroke_to = "hemisphere"
		# 	) %>%
# 			add_scatterplot(
# 				data = dt
# 				, lat = "lat"
# 				, lon = "lon"
# 				, radius = 100000
# 				, fill_colour = "country"
# 			)
# 	})
#
# 	observeEvent({
# 		input$countries
# 	}, {
# 		mapdeck_update('map') %>%
# 			update_arc(
# 				, data = dt_countries()
# 				, layer_id = "arc_layer"
# 				, lat_from = "lat_from"
# 				, lat_to = "lat_to"
# 				, lon_from = "lon_from"
# 				, lon_to = "lon_to"
# 				, stroke_from = "country_from"
# 				, id = "country_to"
# 				#, stroke_to = "hemisphere"
# 			)
# 	})
# }
#
# shinyApp(ui, server)


# library(data.table)
#
# dt <- as.data.table(df)
# dt[, idx := rep(1:(.N/2),  each = 2)]
# dt <- dt[
# 	, {
# 		geometry <- sf::st_sfc(sf::st_multipoint(x = matrix(c(lng, lat), ncol = 2)))
# 		geometry <- sf::st_sf(geometry = geometry)
# 	}
# 	, by = idx
# ]
#
#
# dt
#
# sf <- sf::st_as_sf(dt)




