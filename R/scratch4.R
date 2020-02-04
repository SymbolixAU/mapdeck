

library(sf)
library(mapdeck)

nc <- sf::st_read( system.file( "shape/nc.shp", package = "sf"))

mapdeck() %>%
	add_polygon(
		data = nc
	)

df <- data.frame(
	x = rnorm(1e6)
	, y = rnorm(1e6)
	, val = sample(letters, size = 1e6, replace = T)
)

# mapdeck() %>%
# 	add_scatterplot(
# 		data = df
# 		, lon = "x"
# 		, lat = "y"
# 		, fill_colour = "val"
# 		, debug_cpp = "columnar"
# 	)


## IT IS THE GENERATING OF THE 'COORDINATES' which is slow
## needs to be increased
library(microbenchmark)

microbenchmark::microbenchmark(

	left = {
		mapdeck() %>%
			add_scatterplot(
				data = df
				, lon = "x"
				, lat = "y"
				, fill_colour = "val"
				, debug_cpp = "columnar"
				, leave_early = TRUE
				)
	},
	coloured = {
		mapdeck() %>%
			add_scatterplot(
				data = df
				, lon = "x"
				, lat = "y"
				, fill_colour = "val"
				, debug_cpp = "columnar"
				, leave_early = FALSE
				)
	},
	times = 2
)


#
#
# set_token( read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
#
# library(shiny)
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar()
# 	, dashboardBody(
# 		mapdeck::mapdeckOutput(
# 			outputId = "map"
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	set_token( read.dcf("~/Documents/.googleAPI", fields = "MAPBOX") )
#
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck() %>%
# 			add_scatterplot(
# 				data = capitals
# 				, radius = 500000
# 			)
# 	})
#
# 	observeEvent(input$map_drag_start, {
# 		print( input$map_drag_start )
# 	})
# }
#
# shinyApp( ui, server )
#
#
#
#
# library(shinydashboard)
#
# ui <- dashboardPage(
# 	dashboardHeader()
# 	, dashboardSidebar(
# 		actionButton(
# 			inputId = "clear"
# 			, label = "clear"
# 		)
# 	)
# 	, dashboardBody(
# 		mapdeck::mapdeckOutput(
# 			outputId = "map"
# 		)
# 	)
# )
#
# server <- function(input, output) {
#
# 	set_token( read.dcf("~/Documents/.googleAPI", fields = "MAPBOX") )
#
# 	l1 <- legend_element(
# 		variables = c("Begins with A", "Doesn't begin with A")
# 		, colours = c("#00FF00FF", "#FF0000FF")
# 		, colour_type = "fill"
# 		, variable_type = "category"
# 	)
# 	js <- mapdeck_legend(l1)
#
# 	output$map <- mapdeck::renderMapdeck({
# 		mapdeck() %>%
# 			add_path(
# 				data = roads
# 				, stroke_colour = "ROAD_NAME"
# 				, legend = T
# 			)
# 	})
#
# 	observeEvent(input$clear, {
# 		mapdeck::mapdeck_update(map_id = "map") %>%
# 			add_path(
# 				data = roads[0, ]
# 				, clear_legend = FALSE
# 				, clear_view = FALSE
# 			)
# 	})
# }
#
# shinyApp(ui, server)
#
#
# mapdeck() %>%
# 	add_path(
# 		data = roads
# 		, stroke_width = 20
# 		, auto_highlight = T
# 		, highlight_colour = "#FF0000FF"
# 	) %>%
# 	add_path(
# 		data = roads[0,]
# 		, stroke_width = 20
# 		, auto_highlight = T
# 		, highlight_colour = "#FF0000FF"
# 		, clear_legend = FALSE
# 	)
#
#
#
#
#
# library(mapdeck)
#
# set_token( read.dcf("~/.mapbox", fields = "MAPBOX"))
#
# x <- c(0,0,1,1,2,2,3,3,0)
# y <- c(0,1,1,2,2,3,3,0,0)
# z <- c(0,10, 50, 1000, 200000, 10000, 30, 5000, 0) ## elevation
# m <- c(0,1,3,5,10,20,50, 150, 200)  # timestamps
#
# l1 <- matrix( c(x, y, z, m), ncol = 4 )
# l2 <- matrix( c(rev(x), rev(y), rev(z), m ), ncol = 4 )
#
# l1 <- sf::st_sfc( sf::st_linestring( x = l1 ) )
# l2 <- sf::st_sfc( sf::st_linestring( x = l2 ) )
#
# sf <- sf::st_sf( geometry = sf::st_sfc( c(l1, l2)  ) )
#
# sf$id <- c(1,2)
#
# sf$elev <- list(z, rev(z))
#
# mapdeck(
# 	location = c(0, 0)
# 	, zoom = 4
# 	, pitch = 65
# 	, style = mapdeck_style("dark")
# ) %>%
# 	add_trips(
# 		data = sf
# 		, stroke_colour = ""
# 		, start_time = 0
# 		, end_time = 200
# 		, trail_length = 50
# 		, legend = T
# 	)
#
#
#
#
#
# library(gpxsf)
# library(sf) ## for print methods of sf objects
# gpx <- system.file("gpx/city_trail.gpx", package = "gpx")
# sf <- gpx::gpx_sf( gpx, time = "counter" )
#
# mapdeck(
# 	style = mapdeck_style("dark")
# 	, location = c(145, -37.9)
# 	, zoom = 8
# 	) %>%
# 	add_trips(
# 		data = sf
# 		, trail_length = 2000
# 		, animation_speed = 50
# 		, stroke_colour = "#FFFFFF"
# 	) %>%
# 	add_path(
# 		data = roads
# 		, stroke_opacity = 0.3
# 	)
#
#
#
# sf <- sf::st_read("~/Desktop/bats/lines.shp")
# mapdeck() %>% add_sf( data = sf)
#
#
#
# library(quadmesh)
# library(raster)
# ## dummy raster
# rr <- setExtent(raster::raster(matrix(sample(1:12), 3)), raster::extent(0, 4, 0, 3))
# qm <- quadmesh(rr * 10000)  ## something suitably exaggerated
#
#
# library(mapdeck)
#
#
# mapdeck() %>%
# 	add_mesh2(
# 		data = qm
# 		#, fill_colour = "avg_z"
# 	)
#
#
#
# sf <- sf::st_read(system.file("shape/nc.shp", package="sf")) %>%
# 	sf::st_transform(3857)
#
# mapdeck() %>%
# 	add_polygon(
# 		data = sf
# 		, layer = "polygon_layer"
# 		, fill_colour = "NAME")
