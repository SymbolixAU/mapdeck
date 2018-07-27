


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
