
# add_binary <- function(
# 	coordinates,
# 	start_indices,
# 	stroke_colour = NULL,
# 	stroke_width = NULL,
# 	fill_colour = NULL,
# 	layer_id = NULL,
# 	layer = c("scatterplot","path","trips")
# ) {
# 	layer <- match.arg(layer)
#
#
# 	switch(layer,
# 		"scatterplot" = {
# 			binary_scatterplot(...)
# 		},
# 		"path" = {
# 			binary_path(...)
# 		},
# 		"trips"= {
# 			binary_trips(...)
# 		}
# 	)
#
#
# }

#' @param start_indices 0-based integer vector of indexes
#' @param stride The number of values per coordinate
#' @param stroke_colour vector of interleaved RGBA values (stride 4)
#' @param stroke_width vector of width values for each coordinate.
binary_path <- function(
	map,
	coordinates,
	start_indices,
	stride,
	stroke_colour,
	stroke_width,
	layer_id = NULL
	) {

	## Data -------------
	## coordinates
	## start_indixes
	## stroke_colour
	## stroke_width

	layer_id <- layerId(layer_id, "path")
	map <- addDependency(map, mapdeckPathDependency())

	# js_transitions <- resolve_transitions( transitions, "path" )
	js_transitions <- NULL
	legend_type <- "rgb"

	## Logic
	## n_coordinates == length( coordinates ) / stride
	## n_coordinates == length( start_indices )
	## length(stroke_width) == n_coordinates
	## length(stroke_colour) == n_coordinates * 4

	auto_highlight = FALSE
	highlight_colour = "#AAFFFFFF"
	#palette = "viridis"
	#na_colour = "#808080FF"
	#legend = FALSE
	#legend_options = NULL
	#legend_format = NULL
	update_view = TRUE
	focus_layer = FALSE
	digits = 6
	transitions = NULL
	brush_radius = NULL

	dash_size = NULL
	dash_gap = NULL
	offset = NULL
	width_units = "meters"
	width_min_pixels = NULL
	width_max_pixels = NULL
	width_scale = 1
	#tooltip = NULL
	billboard = FALSE

	use_offset <- !is.null( offset )
	use_dash <- !is.null( dash_size ) && !is.null( dash_gap )

	bbox <- init_bbox()

	data <- list(
		coordinates = coordinates,
		start_indices = start_indices,
		stride = stride,
		data = list(
			stroke_colour = stroke_colour,
			stroke_width = stroke_width,
			tooltip = NULL
		)
	)


	shape <- list(
		data = jsonify::to_json(
			data
			, unbox = FALSE
			, digits = digits
			, factors_as_string = TRUE
			, numeric_dates = FALSE
			, by = "column"
		)
	)

	shape[["legend"]] <- list()

	invoke_method(
		map, "add_path_geo", map_type( map ), shape, layer_id, auto_highlight,
		highlight_colour, bbox, update_view, focus_layer,
		js_transitions, billboard, brush_radius, width_units, width_scale, width_min_pixels,
		width_max_pixels, use_offset, use_dash, legend_type
	)

}
