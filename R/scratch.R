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
# 		, radioButtons(
# 			inputId = "transition"
# 			, label = "transition"
# 			, choices = c("fly", "linear")
# 		)
# 	)
# 	, dashboardBody(
# 		box(
# 			width = 12
#   		, mapdeckOutput(
#   			outputId = "map"
#   			# , height = "600px"
#   		)
# 		)
# 	)
# )
#
# server <- function(input, output, session) {
#
# 	key <- read.dcf("~/Documents/.googleAPI", fields = "MAPBOX")
# 	dt <- as.data.table(capitals)
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
# 	selected_country <- reactive({
# 		as.numeric( dt[country == input$countries, .(lon, lat)] )
# 	})
#
# 	output$map <- renderMapdeck({
#
# 		if(is.null(dt) || is.null(dt)) return()
#
# 		mapdeck(
# 			token = key
# 			, style = "mapbox://styles/mapbox/dark-v9"
# 			, pitch = 35
# 		) %>%
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
# 		c(input$countries)
# 	}, {
# 		if(is.null(input$transition) || is.null(selected_country())) return()
#
# 		mapdeck_update('map') %>%
# 			mapdeck_view(
# 				location = selected_country()
# 				, transition = input$transition
# 				, duration = 2000
# 				, zoom = 4
# 			)
# 	})
# }
# shinyApp(ui, server)
#

# mapdeck(
# 	token = key
# 	, style = "mapbox://styles/mapbox/dark-v9"
# 	, pitch = 35
# ) %>%
# 	add_geojson(
# 		data = geojson
# 		, layer_id = "geojson"
# 	)


library(shiny)
library(shinydashboard)
library(mapdeck)
ui <- dashboardPage(
	dashboardHeader()
	, dashboardSidebar()
	, dashboardBody(
		box(
			width = 8
			,
			mapdeckOutput(
				outputId = "map"
				, height = "600px"
			)
		)
		, box(
			width = 4
			, sliderInput(
				inputId = "light_x"
				, label = "Light x"
				, min = -180
				, max = 180
				, value = 0
			)
			, sliderInput(
				inputId = "light_y"
				, label = "Light y"
				, min = -90
				, max = 90
				, value = 0
			)
			, sliderInput(
				inputId = "light_z"
				, label = "Light z"
				, min = 0
				, max = 100000
				, value = 0
			)
			, sliderInput(
				inputId = "ambient_ratio"
				, label = "ambience"
				, min = 0
				, max = 1
				, step = 0.01
				, value = 0.5
			)
		)
	)
)
server <- function(input, output) {

	df <- melbourne
	df$elevation <- sample(100:5000, size = nrow(df))

	output$map <- renderMapdeck({
		mapdeck(
			token = key
			, style = mapdeck_style('dark')
			, pitch = 35
		) %>%
			add_polygon(
				data = df
				, polyline = "geometry"
				, fill_colour = "fillColor"
				, stroke_colour = "strokeColor"
				, elevation = "elevation"
				, stroke_width = 0
				, layer_id = "poly"
			)
	})

	observeEvent({
		c(input$light_x, input$light_y, input$light_z, input$ambient_ratio)
	}, {

		light_settings <- list(
			lightsPosition = c(input$light_x, input$light_y, input$light_z)
			, ambientRatio = input$ambient_ratio
		)

		mapdeck_update('map') %>%
			add_polygon(
				data = df
				, polyline = "geometry"
				, fill_colour = "fillColor"
				, stroke_colour = "strokeColor"
				, elevation = "elevation"
				, stroke_width = 0
				, layer_id = "poly"
				, light_settings = light_settings
			)

	})

}
shinyApp(ui, server)










