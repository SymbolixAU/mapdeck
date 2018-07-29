

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


### SF

# library(sf)
#
# sf <- sf::st_read("http://eric.clst.org/assets/wiki/uploads/Stuff/gz_2010_us_050_00_500k.json")
# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
#
# mapdeck(
#   token = access_token
#   , style = 'mapbox://styles/mapbox/dark-v9'
#   ) %>%
#   add_polygon(
#   	data = sf[!sf$STATE %in% c("02","15","72"), ]
#     , layer = "polygon_layer"
#   	, fill_colour = "CENSUSAREA"
#   	)

#
# enc <- googlePolylines::encode(sf, strip = T)
# str(enc)
#
# enc[['geometry']] <- unlist(enc[['geometry']])


## sf scatter

# library(googlePolylines)
# library(mapdeck)
# df <- capitals
# df$polyline <- googlePolylines::encode(df, byrow = T)
#
# head(df)
#
# library(data.table)
# library(sf)
#
# dt <- as.data.table( capitals )
# dt <- dt[
# 	, {
# 		geometry <- sf::st_point(x = c(lon, lat))
# 		geometry <- sf::st_sfc(geometry)
# 		geometry <- sf::st_sf(geometry = geometry)
# 	}
# 	, by = 1:nrow(dt)
# ]
#
# sf <- sf::st_as_sf(dt)
#
# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
#
# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
# add_scatterplot(
#   data = sf
#   , radius = 100000
#   , layer_id = "scatter_layer"
# )

### ARC
#
# library(googlePolylines)
# library(mapdeck)
#
# df <- capitals
# df$polyline <- googlePolylines::encode(df, byrow = T)
#
# head(df)
#
# library(data.table)
# library(sf)
#
# dt <- as.data.table( capitals )
#
# dt <- dt[
# 	, {
# 		geometry <- sf::st_point(x = c(lon, lat))
# 		geometry <- sf::st_sfc(geometry)
# 		geometry <- sf::st_sf(geometry = geometry)
# 	}
# 	, by = .(country, capital)
# ]
#
# dt[, key := 1]
# dt <- dt[ country == "Australia" ][
# 	dt
# 	, on = "key"
# 	, nomatch = 0
# ][country != i.country]
#
# setnames(dt, c("i.country", "i.capital", "i.geometry"), c("destination_country", "destination_capital", "destination_geometry"))
# setnames(dt, c("country", "capital", "geometry"), c("origin_country", "origin_capital", "origin_geometry"))
#
#
# sf <- sf::st_as_sf( dt )
#
# sf::st_geometry( sf ) <- "destination_geometry"
# sf
# sf::st_geometry( sf ) <- "origin_geometry"
# sf
#
# data <- sf
# toEncode <- names( which( sapply( data, function(x) inherits(x, "sfc") ) ) )

# enc <- googlePolylines::encode( sf )
# googlePolylines::encode( sf[, toEncode[1] ] )

## encode both columns
# sapply(toEncode, function(x) {
# 	attr(sf, "sf_column") <- x
# 	googlePolylines::encode( sf[, x ] )
# })
#
# encodeTwoColumns <- function(data, origin, destination ) {
# 	attr(data, 'sf_column') <- origin
# 	enc_origin <- googlePolylines::encode( data[, origin ] )
#
# 	attr(data, 'sf_column') <- destination
# 	# destination <- googlePolylines::encode( data[, destination ] )
# 	enc <- googlePolylines::encode( data )
# 	enc[, origin ] <- enc_origin
#
# 	attr(enc, 'encoded_column') <- origin
# 	one <- googlePolylines::geometryRow( enc, "POINT" )
#
# 	attr(enc, 'encoded_column') <- destination
# 	two <- googlePolylines::geometryRow( enc, "POINT" )
#
# 	point_rows <- intersect(one, two)
# 	attr(enc, 'class') <- c("sfencoded", "data.frame")
# 	return(enc[ point_rows, ])
# }
#
# data <- encodeTwoColumns( sf, "origin_geometry", "destination_geometry")
#
# head(data)


# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
#
# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
# add_arc(
#   data = sf
#   , origin = "origin_geometry"
#   , destination = "destination_geometry"
#   , layer_id = "arc_layer"
# )















