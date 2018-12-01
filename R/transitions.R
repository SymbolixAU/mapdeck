
arc_transitions <- function() {
	return(
		list(
			origin = 0,
			destination = 0,
			stroke_from = 0,
			stroke_to = 0,
			stroke_width = 0
		)
	)
}

geojson_transitions <- function() {
	return(
		list(
			fill_colour = 0,
			stroke_colour = 0,
			stroke_width = 0,
			elevation = 0,
			radius = 0
		)
	)
}

line_transitions <- function() {
	return(
		list(
			origin = 0,
			destination = 0,
			stroke_colour = 0,
			stroke_width = 0
		)
	)
}

path_transitions <- function() {
	return(
		list(
			path = 0,
			stroke_colour = 0,
			stroke_width = 0
		)
	)
}

pointcloud_transitions <- function() {
	return(
		list(
			position = 0,
			fill_colour = 0
		)
	)
}

polygon_transitions <- function() {
	return(
		list(
			polygon = 0,
			fill_colour = 0,
			stroke_colour = 0,
			stroke_width = 0,
			elevation = 0
		)
	)
}

scatterplot_transitions <- function() {
	return(
		list(
			position = 0,
			fill_colour = 0,
			radius = 0
		)
	)
}

text_transitions <- function() {
	return(
		list(
			position = 0,
			fill_colour = 0,
			angle = 0,
			size = 0
		)
	)
}

replace_name <- function( transitions, old, new ) {
	names(transitions)[ which( names( transitions ) == old ) ] <- new
	return( transitions )
}


resolve_transitions <- function( transitions, layer ) {
	if( is.null( transitions ) ) return( NULL )
	transitions <- switch(
		layer,
		"arc" = transitions_arc( transitions ),
		"geojson" = transitions_geojson( transitions ),
		"line" = transitions_line( transitions ),
		"path" = transitions_path( transitions ),
		"pointcloud" = transitions_pointcloud( transitions ),
		"polygon" = transitions_polygon( transitions ),
		"scatterplot" = transitions_scatterplot( transitions ),
		"text" = transitions_text( transitions )
	)
	return( jsonify::to_json( transitions, unbox = TRUE ) )
}

transitions_arc <- function( transitions ) {
	transitions <- replace_name( transitions, "origin", "getSourcePosition" )
	transitions <- replace_name( transitions, "destination", "getTargetPosition" )
	transitions <- replace_name( transitions, "stroke_from", "getSourceColor" )
	transitions <- replace_name( transitions, "stroke_to", "getTargetColor" )
	transitions <- replace_name( transitions, "stroke_width", "getStrokeWidth" )
	return( transitions )
}

transitions_geojson <- function( transitions ) {
	transitions <- replace_name( transitions, "fill_colour", "getFillColor" )
	transitions <- replace_name( transitions, "stroke_colour", "getLineColor" )
	transitions <- replace_name( transitions, "radius", "getRadius" )
	transitions <- replace_name( transitions, "stroke_width", "getLineWidth" )
	transitions <- replace_name( transitions, "elevation", "getElevation" )
	return( transitions )
}

transitions_line <- function( transitions ) {
	transitions <- replace_name( transitions, "origin", "getSourcePosition" )
	transitions <- replace_name( transitions, "destination", "getTargetPosition" )
	transitions <- replace_name( transitions, "stroke_width", "getStrokeWidth" )
	transitions <- replace_name( transitions, "stroke_colour", "getColor" )
	return( transitions )
}

transitions_path <- function( transitions ) {
	transitions <- replace_name( transitions, "path", "getPath" )
	transitions <- replace_name( transitions, "stroke_width", "getWidth" )
	transitions <- replace_name( transitions, "stroke_colour", "getColor" )
	return( transitions )
}

transitions_pointcloud <- function( transitions ) {
	transitions <- replace_name( transitions, "position", "getPosition" )
	transitions <- replace_name( transitions, "fill_colour", "getColor" )
	return( transitions )
}

transitions_polygon <- function( transitions ) {
	transitions <- replace_name( transitions, "polygon", "getPolygon" )
	transitions <- replace_name( transitions, "fill_colour", "getFillColor" )
	transitions <- replace_name( transitions, "stroke_colour", "getLineColor" )
	transitions <- replace_name( transitions, "stroke_width", "getLineWidth" )
	transitions <- replace_name( transitions, "elevation", "getElevation" )
	return( transitions )
}

transitions_scatterplot <- function( transitions ) {
	transitions <- replace_name( transitions, "position", "getPosition" )
	transitions <- replace_name( transitions, "fill_colour", "getColor" )
	transitions <- replace_name( transitions, "radius", "getRadius" )
}

transitions_text <- function( transitions ) {
	transitions <- replace_name( transitions, "position", "getPosition" )
	transitions <- replace_name( transitions, "size", "getSize" )
	transitions <- replace_name( transitions, "fill_colour", "getColor" )
	transitions <- replace_name( transitions, "angle", "getAngle" )
}


