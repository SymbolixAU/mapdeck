
### SCATTER
# key <- "pk.eyJ1Ijoic3ltYm9saXgiLCJhIjoiY2pqbm45Zmo1MGl1aTNxbmxwamFqb3Z6MSJ9.yIkj0tGNNh4u61DliOXV6g"
# access_token <- key

# library(mongolite)
# library(sf)
# library(geojsonsf)
# m <- symbolix.utils::connectToMongo(db = "ABS", collection = "SA2_2016", usr = "db_user")
# m <- mongo(db = "ABS", collection = "SA2_2016")
# geo <- m$find(query = '{"geometry":{"$ne":null}}', ndjson = T)
# sf <- geojsonsf::geojson_sf(geo)
#
# sf$fillColor <- sample(letters, size = nrow(sf), replace = T)
#
# df <- as.data.frame(sf::st_coordinates(sf[sf$STE_NAME16 == "Victoria", ]))
# head(df)
# nrow(df)
# df$colour <- sample(letters, size = nrow(df), replace = T)
#
# mapdeck(
# 	token = key
# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	) %>%
# 	add_scatterplot(
# 		data = df[, ]
# 		, lat = "Y"
# 		, lon = "X"
# 		, fill_colour = "colour"
# 	)
#
# mapdeck(token = key) %>%
# 	add_scatterplot(data = df[1:50000, ], fill_colour = "colour", lat = "lat", lon = "lon",
# 									radius = "radius")



## Geojson
# library(mongolite)
# library(sf)
# library(geojsonsf)
# m <- symbolix.utils::connectToMongo(db = "ABS", collection = "SA2_2016", usr = "db_user")
# m <- mongo(db = "ABS", collection = "SA2_2016")
# geo <- m$find(query = '{"geometry":{"$ne":null}}', ndjson = T)
# sf <- geojsonsf::geojson_sf(geo)
#
#s f$fillColor <- viridisLite::viridis(n = nrow(sf))
#
# geo <- sf_geojson(sf[sf$STE_NAME16 == "Victoria",])
# geo <- sf_geojson(sf[sf$SA3_NAME16 == "Perth City", ])
# geo <- sf_geojson(sf[1:100, ])
# attr(geo, 'class') <- 'json'
#
# mapdeck(token = key, style = 'mapbox://styles/mapbox/dark-v9') %>%
# 	add_geojson(data = geo)



## TODO: multiple layers
## scatter + path

# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9' ) %>%
# 	add_path(
# 		data = df
# 		, polyline = "polyline"
# 		, stroke_colour = "col"
# 		, stroke_width = "width"
# 	) %>%
# 		add_scatterplot(
# 			data = googleway::tram_stops
# 			, lat = "stop_lat"
# 			, lon = "stop_lon"
# 			, fill_colour = "stop_id"
# 			, radius = 30
# 			, fill_opacity = 0.2
# 		)

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


### Updating layers
# library(mapdeck)
# library(data.table)
# dt <- as.data.table(capitals)
# access_token <- "pk.eyJ1Ijoic3ltYm9saXgiLCJhIjoiY2pqbm45Zmo1MGl1aTNxbmxwamFqb3Z6MSJ9.yIkj0tGNNh4u61DliOXV6g"
#
# dt[, key := 1]
# dt[lat < 0, hemisphere := "south"]
# dt[lat >= 0, hemisphere := "north"]
#
# dt1 <- dt[ country == "United Kingdom of Great Britain and Northern Ireland", .(country_from = country, capital_from = capital, lat_from = lat, lon_from = lon, key)][
# 	dt[,  .(country_to = country, capital_to = capital, lat_to = lat, lon_to = lon, hemisphere, key) ]
# 	, on = "key"
# 	, allow.cartesian = T
# 	]
#
# dt2 <- dt[ country == "Australia", .(country_from = country, capital_from = capital, lat_from = lat, lon_from = lon, key)][
# 	dt[,  .(country_to = country, capital_to = capital, lat_to = lat, lon_to = lon, hemisphere, key) ]
# 	, on = "key"
# 	, allow.cartesian = T
# 	]
#
# mapdeck(
# 	token = access_token
# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	, pitch = 35
# ) %>%
# 	add_arc(
# 		data = dt1
# 		, layer_id = "arc"
# 		, lat_from = "lat_from"
# 		, lat_to = "lat_to"
# 		, lon_from = "lon_from"
# 		, lon_to = "lon_to"
# 		, stroke_from = "country_from"
# 		, id = "country_to"
# 		#, stroke_to = "hemisphere"
# 	) %>%
# 	update_arc(
# 		data = dt2
# 	)




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







