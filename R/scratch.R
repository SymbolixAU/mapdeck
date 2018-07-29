

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




