# Check Hex
#
# Checks if the paramter is a hex colour
# @param arg
checkHex <- function(arg) {
	if(!is.null(arg)) {
		if(!isHexColour(arg))
			stop(paste0(deparse(substitute(arg)), " must be a valid hex colour"))
	}
}

# Check Hex Alpha
# checks if the paramter is HEX AND has the alpha component
checkHexAlpha <- function(arg) {
	checkHex(arg)
	if(!nchar(arg) %in% c(9)) {
		stop(paste0(deparse(substitute(arg)), " must be a valid hex colour with an alpha component"))
	}
}


# Check Palette
#
# Checks if the palette supplied is a function
# @param arg
checkPalette <- function(arg) {
	if(!is.null(arg)) {
		if(!is.function(arg))
			stop(paste0(deparse(substitute(arg)), " must be a function which generates hex colours"))
	}
}

# Check Numeric
#
# Checks the argument is length 1 numeric
# @param arg
checkNumeric <- function(arg) {
	if(!is.null(arg)) {
		if(!is.numeric(arg) | length(arg) != 1)
			stop(paste0(deparse(substitute(arg)), " must be a single numeric value"))
	}
}



# Is Using Polyline
#
# Checks if the polyline argument is null or not
# @param polyline
isUsingPolyline <- function(polyline){
	if(!is.null(polyline)) return(TRUE)
	return(FALSE)
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
