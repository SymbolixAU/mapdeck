#
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
#
# df <- melbourne
# df$elevation <- sample(100:5000, size = nrow(df))
# df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
# mapdeck(
# 	style = mapdeck_style('dark')
# 	, location = c(145, -38)
# 	, zoom = 8
# ) %>%
# 	add_polygon(
# 		data = df
# 		, polyline = "geometry"
# 		, layer = "polygon_layer"
# 		, fill_colour = "SA2_NAME",
# 		, stroke_colour = "strokeWeight"
# 		, elevation = "elevation"
# 		, stroke_width = 0
# 		, tooltip = 'info'
# 		, legend = T
# 	) %>%
# 	add_polygon(
# 		data = df
# 		, polyline = "geometry"
# 		, layer = "another_layer"
# 		, fill_colour = "elevation",
# 		, elevation = "elevation"
# 		, stroke_width = 0
# 		, tooltip = 'info'
# 		, legend = T
# 	) %>%
# 	clear_legend( "polygon_layer" )
#

# library(shiny)
# library(shinydashboard)
# library(mapdeck)
# set_token(read.dcf("~/.googleAPI", fields = "MAPBOX"))
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar(
# 		selectInput(
# 			inputId = "elevation"
# 			, label = "elevation"
# 			, choices = c(seq(100,5000, by = 500))
# 		)
# 		, actionButton(
# 			inputId = "clear"
# 			, label = "clear"
# 		)
# 	)
# 	, dashboardBody(
# 		mapdeckOutput(
# 			outputId = "map"
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	df <- melbourne
# 	df$elevation <- sample(200:5000, size = nrow(df))
# 	df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
# 	output$map <- renderMapdeck({
# 		mapdeck(
# 			style = mapdeck_style('dark')
# 			, location = c(145, -38)
# 			, zoom = 8
# 		)
# 	})
#
# 	observeEvent({input$elevation},{
# 		if(is.null(input$elevation)) return()
# 		df_plot <- df[df$elevation <= as.numeric(input$elevation), ]
# 		if(nrow(df_plot) == 0) return()
#
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			add_polygon(
# 				data = df_plot
# 				, polyline = "geometry"
# 				, layer = "polygon_layer"
# 				, fill_colour = "SA2_NAME"
# 				, elevation = "elevation"
# 				, stroke_width = 0
# 				, tooltip = 'info'
# 				, legend = F
# 			)
# 	})
#
# 	observeEvent({input$clear},{
# 		mapdeck_update(
# 			map_id = "map"
# 		) %>%
# 			clear_polygon(
# 				layer_id = "polygon_layer"
# 			)
# 	})
#
# }
# shinyApp(ui, server)

# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
# flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#
#
# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, location = c(145, -37.8)
# 	, zoom = 10) %>%
# 	add_path(
# 		data = roads
# 		, stroke_colour = "RIGHT_LOC"
# 		, layer_id = "path_layer"
# 		, tooltip = "ROAD_NAME"
# 		, auto_highlight = TRUE
# 		, legend = T
# 	)

#%>%
# 	clear_path(layer_id = "path_layer")

# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, pitch = 45
# 	) %>%
# 	add_scatterplot_old(
# 		data = capitals
# 		, lat = "lat"
# 		, lon = "lon"
# 		, radius = 100000
# 		, fill_colour = "country"
# 		, layer_id = "scatter_layer"
# 		, tooltip = "capital"
# 		, legend = T
# 	) %>% clear_scatterplot(layer_id = "scatter_layer")

# df <- capitals
# df$z <- sample(10000:10000000, size = nrow(df))
#
# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	) %>%
# 	add_pointcloud(
# 		data = df
# 		, lon = 'lon'
# 		, lat = 'lat'
# 		, elevation = 'z'
# 		, layer_id = 'point'
# 		, fill_colour = "country"
# 		, tooltip = "country"
# 		, legend = T
# 	)

# key <- 'abc'
#
# df <- read.csv(paste0(
# 	'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
# 	'examples/3d-heatmap/heatmap-data.csv'
# ))
#
# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, pitch = 45
# 	) %>%
# 	add_grid(
# 		data = df
# 		, lat = "lat"
# 		, lon = "lng"
# 		, cell_size = 5000
# 		, elevation_scale = 50
# 		, layer_id = "grid_layer"
# 		, auto_highlight = TRUE
# 	)


# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
#
# flights$airport1 <- as.character(flights$airport1)
#
# mapdeck( style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
# 	add_line(
# 		data = flights
# 		, layer_id = "line_layer"
# 		, origin = c("start_lon", "start_lat")
# 		, destination = c("end_lon", "end_lat")
# 		, stroke_colour = "cnt"
# 		, stroke_width = "stroke"
# 		, auto_highlight = TRUE
# 		, legend = TRUE
# 	)


# df <- capitals
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
#
# mapdeck(
# 	style = mapdeck_style("dark")
# ) %>%
# 	add_scatterplot(
# 		data = df[1:10, ]
# 		, lon = "lon"
# 		, lat = "lat"
# 		, radius = 1000
# 		, fill_colour = "country"
# 		, legend = F
# 	)


# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, pitch = 45 ) %>%
#   add_arc(
#   data = flights
#   , layer_id = "arc_layer"
#   , origin = c("start_lon", "start_lat")
#   , destination = c("end_lon", "end_lat")
#   , stroke_from = "airport1"
#   , stroke_to = "airport2"
#   , stroke_width = "stroke"
#   , tooltip = "info"
#   , auto_highlight = TRUE
#   , legend = T
#  )
#
# df <- read.csv(paste0(
# 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
# 'examples/3d-heatmap/heatmap-data.csv'
# ))
#
#
# mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, pitch = 45 ) %>%
# add_grid(
#   data = df
#   , lat = "lat"
#   , lon = "lng"
#   , cell_size = 500
#   , elevation_scale = 50
#   , colour_range = viridisLite::viridis(50)
#   , layer_id = "grid_layer"
#   , auto_highlight = TRUE
# )
#
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# df <- melbourne
# df$elevation <- sample(100:5000, size = nrow(df))
# df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
# mapdeck(
# 	, style = mapdeck_style('dark')
# 	, location = c(145, -38)
# 	, zoom = 8
# ) %>%
# 	add_polygon(
# 		data = df
# 		, polyline = "geometry"
# 		, layer = "polygon_layer"
# 		, fill_colour = "SA2_NAME",
#
# 		, stroke_colour = "fillColor",
# 		, elevation = "elevation"
# 		, stroke_width = 0
# 		, tooltip = 'info'
# 		, legend = F
# 	)


# library(shiny)
# library(shinydashboard)
# library(mapdeck)
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		mapdeckOutput(
# 			outputId = "map1"
# 		)
# 		, mapdeckOutput(
# 			outputId = "map2"
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	df <- melbourne
# 	df$elevation <- sample(200:5000, size = nrow(df))
# 	df$info <- paste0("<b>SA2 - </b><br>",df$SA2_NAME)
#
# 	output$map1 <- renderMapdeck({
# 		mapdeck(
# 			style = mapdeck_style('dark')
# 			, location = c(145, -38)
# 			, zoom = 8
# 		) %>%
# 			add_polygon(
# 				data = df
# 				, polyline = "geometry"
# 				, layer = "polygon_layer"
# 				, fill_colour = "SA2_NAME"
# 				, elevation = "elevation"
# 				, stroke_width = 0
# 				, tooltip = 'info'
# 				, legend = T
# 			)
# 	})
#
# 	output$map2 <- renderMapdeck({
# 		mapdeck(
# 			style = mapdeck_style('dark')
# 			, location = c(145, -38)
# 			, zoom = 8
# 		) %>%
# 			add_polygon(
# 				data = df
# 				, polyline = "geometry"
# 				, layer = "polygon_layer"
# 				, fill_colour = "SA3_NAME"
# 				, elevation = "elevation"
# 				, stroke_width = 0
# 				, tooltip = 'info'
# 				, legend = T
# 			)
#   })
# }
# shinyApp(ui, server)


# key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
# sf_line <- mapdeck::roads
# names(sf_line) <- gsub("geometry", "path", names(sf_line))
# sf::st_geometry( sf_line ) <- "path"
# # sf_line <- rbind(sf_line, sf_line, sf_line, sf_line, sf_line, sf_line)
# sf_line$dte <- sample( seq( as.Date("2018-01-01"), as.Date("2018-12-30"), length.out = 300), size = nrow( sf_line ), replace = T )
# sf_line$psx <- sample( seq( as.POSIXct("2018-01-01 00:00:00"), as.POSIXct("2018-12-30 00:00:00"), length.out = 300), size = nrow(sf_line), replace = T )
#
# mapdeck(
# 	token = key
# 	, style = 'mapbox://styles/mapbox/dark-v9'
# 	, location = c(145, -37.8)
# 	, zoom = 10) %>%
# 	add_path(
# 		data = sf_line[1:500, ]
# 		, stroke_colour = "dte"
# 		, layer_id = "path_layer"
# 		, tooltip = "ROAD_NAME"
# 		, auto_highlight = TRUE
# 		, legend = T
# 		, legend_options = list( title = "my date yo")
# 	)


# ### POLYGON
# library(sf)
# library(geojsonsf)
#
# sf <- geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
# sf <- sf::st_cast(sf, "POLYGON")
#
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
#
# mapdeck::mapdeck(
# 	style = 'mapbox://styles/mapbox/dark-v9'
# 	, location = c(144.5, -37)
# 	, zoom = 5
# 	) %>%
# add_polygon(
# 		data = sf
# 		, layer = "polygon_layer"
# 		, fill_colour = "SA2_NAME16"
# 		#, stroke_colour = "SA2_NAME16"
# 	)

## Scatterplot
# sf <- sf::st_as_sf( capitals, coords = c("lon","lat"))
# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
# add_scatterplot_geo(
#   data = sf
#   , radius = 100000
#   , fill_colour = "country"
#   , layer_id = "scatter_layer"
#   , tooltip = "capital"
# )

## TEXT
# sf <- sf::st_as_sf( capitals, coords = c("lon","lat"))
# mapdeck(
#   token = key,
#   style = mapdeck_style('dark')
# ) %>%
#   add_text(
#     data = sf
#     , fill_colour = 'country'
#     , text = 'capital'
#     , layer_id = 'text'
#   )

## pointcloud
# df <- capitals
# df$z <- sample(10000:10000000, size = nrow(df))
# sf <- sf::st_as_sf( df, coords = c("lon","lat","z"))
#
# mapdeck(token = key, style = 'mapbox://styles/mapbox/dark-v9') %>%
# add_pointcloud(
# 	data = sf
#   # , elevation = 'z'
#   , layer_id = 'point'
#   , fill_colour = "country"
#   , tooltip = "country"
# )

## SCREENGRID
# df <- read.csv(paste0(
# 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
# 'examples/3d-heatmap/heatmap-data.csv'
# ))
#
# df$weight <- sample(1:10, size = nrow(df), replace = T)
# df <- df[!is.na(df$lng), ]
# sf <- sf::st_as_sf( df, coords = c("lng","lat"))
#
# mapdeck( token = key, style = mapdeck_style('dark'), pitch = 45 ) %>%
# add_screengrid(
#   data = sf[1:1000, ]
#   , weight = "weight"
#   , layer_id = "screengrid_layer"
#   , cell_size = 10
#   , opacity = 0.3
# )

## ARC
# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
# flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#
# sf_o <- sf::st_as_sf( flights[, c("start_lat", "start_lon")], coords = c("start_lon","start_lat"))
# sf_d <- sf::st_as_sf( flights[, c("end_lat", "end_lon")], coords = c("end_lon", "end_lat"))
#
# sf <- cbind(sf_o, sf_d)
# sf <- setNames(sf, c("origin", "destination"))
# sf::st_geometry( sf ) <- "origin"
#
# sf$airline <- flights$airline
# sf$airport1 <- flights$airport1
# sf$airport2 <- flights$airport2
# sf$cnt <- flights$cnt
# sf$id <- flights$id
# sf$stroke <- flights$stroke
# sf$info <- flights$info
#
#
# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#   add_arc(
#   data = sf
#   , layer_id = "arc_layer"
#   , origin = "origin"
#   , destination = "destination"
#   , stroke_from = "airport1"
#   , stroke_to = "airport2"
#   , stroke_width = "stroke"
#   , tooltip = "info"
#   , auto_highlight = TRUE
#   , legend = T
#   , legend_options = list(stroke_from = list( title = "Origin airport" ), css = "max-height: 100px;")
#  )

## LINE
# url <- 'https://raw.githubusercontent.com/plotly/datasets/master/2011_february_aa_flight_paths.csv'
# flights <- read.csv(url)
# flights$id <- seq_len(nrow(flights))
# flights$stroke <- sample(1:3, size = nrow(flights), replace = T)
# flights$info <- paste0("<b>",flights$airport1, " - ", flights$airport2, "</b>")
#
# sf_o <- sf::st_as_sf( flights[, c("start_lat", "start_lon")], coords = c("start_lon","start_lat"))
# sf_d <- sf::st_as_sf( flights[, c("end_lat", "end_lon")], coords = c("end_lon", "end_lat"))
#
# sf <- cbind(sf_o, sf_d)
# sf <- setNames(sf, c("origin", "destination"))
# sf::st_geometry( sf ) <- "origin"
#
# sf$airline <- flights$airline
# sf$airport1 <- flights$airport1
# sf$airport2 <- flights$airport2
# sf$cnt <- flights$cnt
# sf$id <- flights$id
# sf$stroke <- flights$stroke
# sf$info <- flights$info
#
#
# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
#   add_line(
#   data = sf
#   , layer_id = "arc_layer"
#   , origin = "origin"
#   , destination = "destination"
#   , stroke_colour = "airport1"
#   , stroke_width = "stroke"
#   , tooltip = "info"
#   , auto_highlight = TRUE
#   , legend = T
#   , legend_options = list(stroke_from = list( title = "Origin airport" ), css = "max-height: 100px;")
#  )

# ## HEXAGON
# df <- read.csv(paste0(
# 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/3d-heatmap/heatmap-data.csv'
# ))
#
# df <- df[!is.na(df$lng), ]
# sf <- sf::st_as_sf( df, coords = c("lng","lat"))
#
# mapdeck( token = key, style = 'mapbox://styles/mapbox/dark-v9', pitch = 45 ) %>%
# add_hexagon(
#   data = sf
#   , layer_id = "hex_layer"
#   , elevation_scale = 100
# )


## SCREENGRID
# df <- read.csv(paste0(
# 'https://raw.githubusercontent.com/uber-common/deck.gl-data/master/',
# 'examples/3d-heatmap/heatmap-data.csv'
# ))
#
# df$weight <- sample(1:10, size = nrow(df), replace = T)
# df <- df[!is.na(df$lng), ]
# sf <- sf::st_as_sf( df, coords = c("lng","lat"))
#
# mapdeck( token = key, style = mapdeck_style('dark'), pitch = 45 ) %>%
# add_grid(
#   data = sf[1:1000, ]
#   , cell_size = 10
# )

# x <- "lat"
# lat <- capitals
# mapdeck (
# 					 style = 'mapbox://styles/mapbox/dark-v9',
# 					 pitch = 45) %>%
# 	add_scatterplot (
# 		data = lat,
# 		lat = x,
# 		lon = "lon",
# 		radius = 1000000,
# 		fill_colour = "country",
# 		layer_id = "scatter_layer"
# 	)


#
# ## handle:
# ## 1. it's a string - do nothing
# ## 2. it's a symbol representing the column of data.frame
# ## 4. it's a symbol representing a value - do nothing
#
# df <- data.frame(a = 1:5, b = letters[1:5])
#
# f <- function( data, fill_colour = NULL, stroke_colour = NULL ) {
# 	l <- as.list( match.call( expand.dots = F) )
# 	args <- c("fill_colour","stroke_colour")
# 	nms <- names( data )
#
# 	x <- vapply(names(l), function(x) { x %in% args }, T)
# 	x <- x[x]    ## x is the set of arguments we need to evaluate
# 	#x
# 	#lapply(l, typeof)
# 	l <- l[names(x)]
# 	tp <- lapply(l, typeof)
#
# 	print( tp )
# 	print( lapply( names(tp), function(x) is.symbol(tp[[ x ]] ) ) )
#
# 	## if symbol, evaluate it
# 	lapply( names(tp), function(x) {
# 		if ( tp[[ x ]] == "symbol" ) {
# 			if( eval( l[[ x ]] ) %in% nms ) {
# 		    eval( l[[ x ]] )
# 	    } else {
# 	    	eval( l[[ x ]] , parent.frame() )    ## need to evaluate 'x' and get teh value out of it
# 	    }
# 		} else {
# 			l[[ x ]]
# 		}
#
# 	})
# 	#tp
# }
#
#
# ## 1
# f( data = df, fill_colour = "a")
#
#
# ## 2
# fc <- "a"
# f( data = df, fill_colour = fc)
#
# x <- 1
# f( data = df, fill_colour = x)
#
# f( data = df, fill_colour = a)
#
# ## for symbols, if the quote of them is in the name of data, quote it, otherwaise evaluate it
#
#
#
# g <- function(x) force(x)
# g( fc )
# g( "a" )
# g( 1 )
# g( x )
#
# h <- function(x) {
# 	g(x)
# }
#
# h( fc )
# h( "a" )
# h( 1 )
# h( x )
#
#
# f2 <- function( data, fill_colour = NULL, stroke_colour = NULL ) {
#
# 	l <- as.list( match.call( expand.dots = F) )
# 	layer_args <- c("fill_colour","stroke_colour")
# 	nms <- names( data )
#
# 	x <- vapply(names(l), function(x) { x %in% layer_args }, T)
# 	x <- x[x]    ## x is the set of arguments we need to evaluate
# 	l <- l[names(x)]
# 	lapply(l, eval)
# }
#
# ## 1
# f2( data = df, fill_colour = "a")
#
# ## 2
# fc <- "a"
# f2( data = df, fill_colour = fc)
#
# x <- 1
# f2( data = df, fill_colour = x)
#
# f2( data = df, stroke_colour = fc, fill_colour = x)
#
# f2( data = df, stroke_colour = fc, fill_colour = colourvalues::color_values(1:2) )
