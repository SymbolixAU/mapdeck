


# Is Using Polyline
#
# Checks if the polyline argument is null or not
# @param polyline
isUsingPolyline <- function(polyline){
	if(!is.null(polyline)) return(TRUE)
	return(FALSE)
}


# Layer Id
#
# Checks the layer_id parameter, and provides a default one if NULL
# @param layer_id
layerId <- function(layer_id){
	if(!is.null(layer_id) & length(layer_id) != 1)
		stop("please provide a single value for 'layer_id'")

	if(is.null(layer_id)){
		return("defaultLayerId")
	}else{
		return(layer_id)
	}
}


# Unlist Multi Polyline
#
# unlists a polyline column so it's one row per geometry
#
# @param df
# @param geometry
unlistMultiGeometry <- function( df, geometry ) {

	list_length <- vapply( df[[ geometry ]] , length, 1L)
	unlisted <- unlist( df[[ geometry ]] )
	df_rows <- 1:nrow(df)

	## ensure a one-column data.frame is handle correctly
	df <- df[rep(df_rows, list_length), setdiff(names(df), geometry), drop = F]
	df[[ geometry ]] <- unlisted
	return( df )
}
