replace_name <- function( transitions, old, new ) {
	names(transitions)[ which( names( transitions ) == old ) ] <- new
	return( transitions )
}


resolve_transitions <- function( transitions, layer ) {
	if( is.null( transitions ) ) return( NULL )
	transitions <- switch(
		layer,
		"arc" = transitions_arc( transitions ),
		"column" = transitions_column( transitions ),
		"geojson" = transitions_geojson( transitions ),
		"greatcircle" = transitions_greatcircle( transitions ),
		"grid" = transitions_grid( transitions ),
		"heatmap" = transitions_heatmap( transitions ),
		"hexagon" = transitions_hexagon( transitions ),
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
	transitions <- replace_name( transitions, "height", "getHeight")
	transitions <- replace_name( transitions, "tilt", "getTilt")
	return( transitions )
}

transitions_column <- function( transitions ) {
	transitions <- replace_name( transitions, "fill_colour", "getColor" )
	transitions <- replace_name( transitions, "elevation", "getElevation" )
	transitions <- replace_name( transitions, "position", "getPosition" )
}

transitions_geojson <- function( transitions ) {
	transitions <- replace_name( transitions, "fill_colour", "getFillColor" )
	transitions <- replace_name( transitions, "stroke_colour", "getLineColor" )
	transitions <- replace_name( transitions, "radius", "getRadius" )
	transitions <- replace_name( transitions, "stroke_width", "getLineWidth" )
	transitions <- replace_name( transitions, "elevation", "getElevation" )
	return( transitions )
}

transitions_greatcircle <- function( transitions ) {
	transitions <- replace_name( transitions, "origin", "getSourcePosition" )
	transitions <- replace_name( transitions, "destination", "getTargetPosition" )
	transitions <- replace_name( transitions, "stroke_from", "getSourceColor" )
	transitions <- replace_name( transitions, "stroke_to", "getTargetColor" )
	transitions <- replace_name( transitions, "stroke_width", "getStrokeWidth" )
	# transitions <- replace_name( transitions, "height", "getHeight")
	# transitions <- replace_name( transitions, "tilt", "getTilt")
	return( transitions )
}

transitions_grid <- function( transitions ) {
	transitions <- replace_name( transitions, "elevation", "getElevationValue" )
	transitions <- replace_name( transitions, "colour", "getColorValue" )
	return( transitions )
}

transitions_heatmap <- function( transitions ) {
	transitions <- replace_name( transitions, "intensity", "intensity" )
	transitions <- replace_name( transitions, "threshold", "threshold" )
	transitions <- replace_name( transitions, "weight", "getWeight")
	transitions <- replace_name( transitions, "radius_pixels", "radiusPixels" )
	return( transitions )
}

transitions_hexagon <- function( transitions ) {
	transitions <- replace_name( transitions, "elevation", "getElevationWeight" )
	transitions <- replace_name( transitions, "colour", "getColorWeight" )
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
	transitions <- replace_name( transitions, "elevation_scale", "elevationScale")
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


