#
#
# library(shiny)
# library(shinydashboard)
# library(mapdeck)
# library(data.table)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		mapdeckOutput(
# 			outputId = "map"
# 		)
# 		# , sliderInput(
# 		# 	inputId = "lons"
# 		# 	, label = "longitudes"
# 		# 	, min = -180
# 		# 	, max = 180
# 		# 	, value = 75
# 		# 	, step = 1
# 		# )
#
# # 		tags$script(HTML(
# # 			'function arc_width( d ) {
# #         var val = document.getElementById("lons").value;
# #         console.log( "val: " + val );
# # 			  return d.lon_to <= val ? 0 : 1 ;
# # 			}'
# # 		))
#
# 	)
# )
# server <- function(input, output, session) {
#
# 	key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
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
# 	dt_plot <- dt[ country == "United Kingdom of Great Britain and Northern Ireland", .(country_from = country, capital_from = capital, lat_from = lat, lon_from = lon, key)][
# 		dt[country != "United Kingdom of Great Britain and Northern Ireland" ,  .(country_to = country, capital_to = capital, lat_to = lat, lon_to = lon, hemisphere, key) ]
# 		, on = "key"
# 		, allow.cartesian = T
# 		]
#
# 	output$map <- renderMapdeck({
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

