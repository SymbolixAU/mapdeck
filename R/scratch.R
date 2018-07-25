

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
# 	access_token <- "pk.eyJ1Ijoic3ltYm9saXgiLCJhIjoiY2pqbm45Zmo1MGl1aTNxbmxwamFqb3Z6MSJ9.yIkj0tGNNh4u61DliOXV6g"
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

## TRIGGERS

# library(shiny)
# library(shinydashboard)
# library(data.table)
# library(mapdeck)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar(
# 		shiny::uiOutput(outputId = "countries")
# 		, actionButton(inputId = "button", label = "update map")
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
# 	access_token <- "pk.eyJ1Ijoic3ltYm9saXgiLCJhIjoiY2pqbm45Zmo1MGl1aTNxbmxwamFqb3Z6MSJ9.yIkj0tGNNh4u61DliOXV6g"
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
# 		mapdeck(
# 			token = access_token
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
# 		input$button
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


### Polygon

## polygons need to be an array of polylines

# sf <- geojsonsf::geojson_sf( googleway::geo_melbourne )
# enc <- googlePolylines::encode(sf)
#
# mapdeck(
#   token = key
#   , style = 'mapbox://styles/mapbox/dark-v9'
#   , location = c(145.688269, -38.101062)
#   , zoom = 8
#   ) %>%
#   add_polygon(
#   	data = enc
#     , polyline = "geometry"
#     , layer = "polygon_layer"
#   	, fill_colour = "fillColor"
#   	)



