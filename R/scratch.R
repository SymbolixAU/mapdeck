#
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
# 	)
# 	, dashboardBody(
# 		box(
# 			width = 12
#   		, mapdeckOutput(
#   			outputId = "map"
#   		)
# 		)
# 		, box(
# 			width = 12
#   		, sliderInput(
#   			inputId = "lons"
#   			, label = "longitudes"
#   			, min = -180
#   			, max = 180
#   			, value = c(-90, 90)
#   		)
# 		)
#
# # 		tags$script(HTML(
# # 			'function arc_width( d ) {
# #         var val = document.getElementById("lons").value;
# #         console.log( "val: " + val );
# # 			  return d.lon_to <= val ? 0 : 1 ;
# # 			}'
# # 		))
# #
# 	)
# )
#
# server <- function(input, output, session) {
#
# 	key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
# 	dt <- as.data.table(capitals)
# 	dt[, key := 1]
# 	dt[lat < 0, hemisphere := "south"]
# 	dt[lat >= 0, hemisphere := "north"]
#
# 	dt_countries <- dt[ country == "United Kingdom of Great Britain and Northern Ireland", .(country_from = country, capital_from = capital, lat_from = lat, lon_from = lon, key)][
# 		dt[country != "United Kingdom of Great Britain and Northern Ireland" ,  .(country_to = country, capital_to = capital, lat_to = lat, lon_to = lon, hemisphere, key) ]
# 		, on = "key"
# 		, allow.cartesian = T
# 		]
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
# 	dt_reactive_countries <- reactive({
#
# 		if(is.null(input$countries) || is.null(input$lons)) return()
#
# 		selected_country <- input$countries
# 		selected_lons <- input$lons
#
# 		dt_countries <- dt[ country == selected_country, .(country_from = country, capital_from = capital, lat_from = lat, lon_from = lon, key)][
# 			dt[country != selected_country,  .(country_to = country, capital_to = capital, lat_to = lat, lon_to = lon, hemisphere, key) ]
# 			, on = "key"
# 			, allow.cartesian = T
# 			][
# 				lon_to >= selected_lons[1] & lon_to <= selected_lons[2]
# 			]
#
# 		return(dt_countries)
# 	})
#
# 	output$map <- renderMapdeck({
#
# 		if(is.null(dt_countries) || is.null(dt)) return()
#
# 		mapdeck(
# 			token = key
# 			, style = "mapbox://styles/mapbox/dark-v9"
# 			, pitch = 35
# 		) %>%
# 			add_arc(
# 				data = dt_countries
# 				, layer_id = "arc_layer"
# 				, origin = c("lon_from", "lat_from")
# 				, destination = c("lon_to", "lat_to")
# 				, stroke_from = "country_from"
# 				, id = "country_to"
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
# 		c(input$lons, input$countries)
# 	}, {
# 		print("observing")
# 		if(is.null(dt_reactive_countries())) return()
#
# 		mapdeck_update('map') %>%
# 			add_arc(
# 				data = dt_reactive_countries()
# 				, layer_id = "arc_layer"
# 				, origin = c("lon_from", "lat_from")
# 				, destination = c("lon_to", "lat_to")
# 				, stroke_from = "country_from"
# 				, id = "country_to"
# 			)
# 	})
#
# 	# observeEvent({input$lons}, {
# 	#
# 	# 	session$sendCustomMessage("handler1", input$lons)
# 	#
# 	# 	# mapdeck(
# 	# 	# 	token = key
# 	# 	# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	# 	# 	, pitch = 35
# 	# 	# ) %>%
# 	# 	# 	add_arc(
# 	# 	# 		data = dt_plot
# 	# 	# 		, layer_id = "arc_layer"
# 	# 	# 		, origin = c("lon_from", "lat_from")
# 	# 	# 		, destination = c("lon_to", "lat_to")
# 	# 	# 		, stroke_from = "country_from"
# 	# 	# 		, id = "country_to"
# 	# 	# 	)
# 	# })
#
# }
# shinyApp(ui, server)
#
