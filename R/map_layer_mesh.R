mapdeckMeshDependency <- function() {
	list(
		createHtmlDependency(
			name = "mesh",
			version = "1.0.0",
			src = system.file("htmlwidgets/lib/mesh", package = "mapdeck"),
			script = c("mesh.js"),
			all_files = FALSE
		)
	)
}



find_mesh_index <- function( data ) {
	 ## prefer triangles (in future maybe we do both)
	idx <- "it"
	if (!idx %in% names(data)) {
		idx <- "ib"
	}
	if (!idx %in% names(data)) stop("seems to be a malformed mesh3d,withno 'it' 'ib' array?")
	idx
}


#' Add Mesh
#'
#' Adds polygons to the map from a \code{mesh3d} object
#'
#' @inheritParams add_polygon
#'
#' @inheritSection add_arc legend
#' @inheritSection add_arc id
#'
#' @examples
#' \donttest{
#'
#' ## exaggerate the elevation slightly
#' m <- melbourne_mesh
#' m$vb[3, ] <- m$vb[3, ] * 50
#'
#'mapdeck() %>%
#'  add_mesh(
#'  data = m
#'  )
#'
#' }
#'
#' @details
#'
#' \code{add_mesh} supports mesh3d objects
#'
#' @export
add_mesh <- function(
	map,
	data = get_map_data(map),
	fill_opacity = NULL,
	elevation = NULL,
	tooltip = NULL,
	auto_highlight = FALSE,
	highlight_colour = "#AAFFFFFF",
	light_settings = list(),
	layer_id = NULL,
	id = NULL,
	palette = "viridis",
	na_colour = "#808080FF",
	legend = FALSE,
	legend_options = NULL,
	legend_format = NULL,
	update_view = TRUE,
	focus_layer = FALSE,
	digits = 6,
	transitions = NULL,
	brush_radius = NULL
) {

	#if( is.null( stroke_colour )) stroke_colour <- fill_colour
	experimental_layer( "mesh" )

	if(!inherits(data, "mesh3d")) {
		stop("mapdeck - expecting mesh3d object")
	}

	l <- list()
	fill_colour = "average_z"
	# fill_colour = "z"
	l[["fill_colour"]] <- force( fill_colour )
	l[["fill_opacity"]] <- resolve_opacity( fill_opacity )
	l[["elevation"]] <- force( elevation )
	l[["tooltip"]] <- force( tooltip )
	l[["id"]] <- force( id )
	l[["na_colour"]] <- force( na_colour )

	vertex <- "vb"
	index <- find_mesh_index( data )

	## check: need different checks for sense
	# if ( data[["primitivetype"]] == "quad" & is.null( data[["ib"]] ) ) {
	# 	stop("mapdeck - badly formed mesh3d type. Found quad and expecting ib index")
	# }
	# if ( data[["primitivetype"]] == "triangle" & is.null( data[["it"]] ) ) {
	# 	stop("mapdeck - badly formed mesh3d type. Found triangle and expecting it index")
	# }
	l <- resolve_palette( l, palette )
	l <- resolve_legend( l, legend )
	l <- resolve_legend_options( l, legend_options )

	l <- resolve_data( data, l, c("POLYGON") )

	bbox <- init_bbox()
	update_view <- force( update_view )
	focus_layer <- force( focus_layer )

	is_extruded <- TRUE
	# if( !is.null( l[["stroke_width"]] ) | !is.null( l[["stroke_colour"]] ) ) {
	# 	is_extruded <- FALSE
	# 	if( !is.null( elevation ) ) {
	# 		message("stroke provided, ignoring elevation")
	# 	}
	# 	if( is.null( l[["stroke_width"]] ) ) {
	# 		l[["stroke_width"]] <- 1L
	# 	}
	# }

	if ( !is.null(l[["data"]]) ) {
		data <- l[["data"]]
		l[["data"]] <- NULL
	}

	## sf objects come with a bounding box
	if( !is.null(l[["bbox"]] ) ) {
		bbox <- l[["bbox"]]
		l[["bbox"]] <- NULL
	}

	checkHexAlpha(highlight_colour)
	layer_id <- layerId(layer_id, "polygon")

	map <- addDependency(map, mapdeckMeshDependency())

	tp <- l[["data_type"]]
	l[["data_type"]] <- NULL

	jsfunc <- "add_mesh"

	if ( tp == "mesh" ) {
		# geometry_column <- c( "geometry" )
		geometry_column <- c( vertex, index )
		shape <- rcpp_mesh_geojson( data, l, geometry_column, digits )
		#return( shape )
	}

	#	geometry_column <- c( "geometry" ) ## This is where we woudl also specify 'origin' or 'destination'
	#	shape <- rcpp_polygon_geojson( data, l, geometry_column )
	# } else if ( tp == "sfencoded" ) {
	# 	geometry_column <- "polyline"
	# 	shape <- rcpp_polygon_polyline( data, l, geometry_column )
	# 	jsfunc <- "add_polygon_polyline"
	# }

	# return( shape )

	light_settings <- jsonify::to_json(light_settings, unbox = T)
	js_transitions <- resolve_transitions( transitions, "polygon" )

	if( inherits( legend, "json" ) ) {
		shape[["legend"]] <- legend
	} else {
		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
	}

	invoke_method(
		map, jsfunc, map_type( map ), shape[["data"]], layer_id, light_settings,
		auto_highlight, highlight_colour, shape[["legend"]], bbox, update_view, focus_layer,
		js_transitions, is_extruded, brush_radius
	)
}



# add_mesh2 <- function(
# 	map,
# 	data = get_map_data(map),
# 	fill_opacity = NULL,
# 	elevation = NULL,
# 	tooltip = NULL,
# 	auto_highlight = FALSE,
# 	highlight_colour = "#AAFFFFFF",
# 	light_settings = list(),
# 	layer_id = NULL,
# 	id = NULL,
# 	palette = "viridis",
# 	na_colour = "#808080FF",
# 	legend = FALSE,
# 	legend_options = NULL,
# 	legend_format = NULL,
# 	update_view = TRUE,
# 	focus_layer = FALSE,
# 	digits = 6,
# 	transitions = NULL
# ) {
#
# 	#if( is.null( stroke_colour )) stroke_colour <- fill_colour
# 	experimental_layer( "mesh" )
#
# 	if(!inherits(data, "mesh3d")) {
# 		stop("mapdeck - expecting mesh3d object")
# 	}
#
# 	l <- list()
# 	fill_colour = "average_z"
# 	l[["fill_colour"]] <- force( fill_colour )
# 	l[["fill_opacity"]] <- resolve_opacity( fill_opacity )
# 	l[["elevation"]] <- force( elevation )
# 	l[["tooltip"]] <- force( tooltip )
# 	l[["id"]] <- force( id )
# 	l[["na_colour"]] <- force( na_colour )
#
# 	vertex <- "vb"
# 	index <- find_mesh_index( data )
#
# 	## check:   this check is now done in find_mesh_index()
# 	# if ( data[["primitivetype"]] == "quad" & is.null( data[["ib"]] ) ) {
# 	# 	stop("mapdeck - badly formed mesh3d type. Found quad and expecting ib index")
# 	# }
# 	# if ( data[["primitivetype"]] == "triangle" & is.null( data[["it"]] ) ) {
# 	# 	stop("mapdeck - badly formed mesh3d type. Found triangle and expecting it index")
# 	# }
# 	l <- resolve_palette( l, palette )
# 	l <- resolve_legend( l, legend )
# 	l <- resolve_legend_options( l, legend_options )
#
# 	l <- resolve_data( data, l, c("POLYGON") )
#
# 	bbox <- init_bbox()
# 	update_view <- force( update_view )
# 	focus_layer <- force( focus_layer )
#
# 	is_extruded <- TRUE
# 	# if( !is.null( l[["stroke_width"]] ) | !is.null( l[["stroke_colour"]] ) ) {
# 	# 	is_extruded <- FALSE
# 	# 	if( !is.null( elevation ) ) {
# 	# 		message("stroke provided, ignoring elevation")
# 	# 	}
# 	# 	if( is.null( l[["stroke_width"]] ) ) {
# 	# 		l[["stroke_width"]] <- 1L
# 	# 	}
# 	# }
#
# 	if ( !is.null(l[["data"]]) ) {
# 		data <- l[["data"]]
# 		l[["data"]] <- NULL
# 	}
#
# 	## sf objects come with a bounding box
# 	if( !is.null(l[["bbox"]] ) ) {
# 		bbox <- l[["bbox"]]
# 		l[["bbox"]] <- NULL
# 	}
#
# 	checkHexAlpha(highlight_colour)
# 	layer_id <- layerId(layer_id, "mesh")
#
# 	map <- addDependency(map, mapdeckMeshDependency())
#
# 	tp <- l[["data_type"]]
# 	l[["data_type"]] <- NULL
#
# 	jsfunc <- "add_mesh"
#
# 	if ( tp == "mesh" ) {
# 		# geometry_column <- c( "geometry" )
# 		geometry_column <- c( vertex, index )
# 		shape <- rcpp_mesh_geojson2( data, geometry_column )
# 		# return( shape )
# 		# shape[["legend"]] <- list()
# 	}
#
# 	#	geometry_column <- c( "geometry" ) ## This is where we woudl also specify 'origin' or 'destination'
# 	#	shape <- rcpp_polygon_geojson( data, l, geometry_column )
# 	# } else if ( tp == "sfencoded" ) {
# 	# 	geometry_column <- "polyline"
# 	# 	shape <- rcpp_polygon_polyline( data, l, geometry_column )
# 	# 	jsfunc <- "add_polygon_polyline"
# 	# }
#
# 	# return( shape )
#
# 	light_settings <- jsonify::to_json(light_settings, unbox = T)
# 	js_transitions <- resolve_transitions( transitions, "polygon" )
#
# 	if( inherits( legend, "json" ) ) {
# 		shape[["legend"]] <- legend
# 	} else {
# 		shape[["legend"]] <- resolve_legend_format( shape[["legend"]], legend_format )
# 	}
#
# 	invoke_method(
# 		map, jsfunc, map_type( map ), shape[["data"]], layer_id, light_settings,
# 		auto_highlight, highlight_colour, shape[["legend"]], bbox, update_view, focus_layer,
# 		js_transitions, is_extruded
# 	)
# }




#' @rdname clear
#' @export
clear_mesh <- function( map, layer_id = NULL) {
	layer_id <- layerId(layer_id, "mesh")
	invoke_method(map, "md_layer_clear", map_type( map ), layer_id, "mesh" )
}


