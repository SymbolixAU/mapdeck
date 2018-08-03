# Create Map Object
#
# Creates the map object from the input data and arguments. If the arguments
# are columns of the \code{data}, the column is used. Otherwise, the value
# is assumed to be required for every row of \code{data} and is replicated
# for the whole data set
#
# prior to entering this function all the data arguments will have been resolved.
# for exmaple, if the info_window is a chart (list), it will already have been
# removed from the objArgs.
#
# @param data data passed into the map layer function
# @param cols all the columns required for the given map object
# @param objArgs the arguments passed into the map layer function
createMapObject <- function(data, cols, objArgs) {

	dataNames <- names(data)

	argsIdx <- match(cols, names(objArgs)) ## those that exist in 'cols'
	argsIdx <- argsIdx[!is.na(argsIdx)]
	argValues <- sapply(1:length(objArgs), function(x) objArgs[[x]])

	dataArgs <- which(argValues %in% names(data)) ## those where there is a column of data

	additionalValues <- setdiff(argsIdx, dataArgs)

	dataCols <- vapply(dataArgs, function(x) objArgs[[x]], "")
	dataNames <- names(objArgs)[dataArgs]

	df <- stats::setNames(data[, dataCols, drop = F], dataNames)

	## need to resolve info windows here, because if it's a list of data
	## to be used in a chart, this will fail
	if (length(additionalValues) > 0) {

		extraCols <- lapply(additionalValues, function(x){

			## the rep(eval(info_window)) won't work if it's a list...
			## this is designed for when the value passed is a single value, like a colour #00FF00
			stats::setNames(as.data.frame(rep(eval(objArgs[[x]]), nrow(df)), stringsAsFactors = F), names(objArgs)[x])
		})
		df <- cbind(df, do.call(cbind, extraCols))
	}

	# if("info_window" %in% names(df)){
	# 	df[['info_window']] <- as.character(df[['info_window']])
	# }
	return(df)
}


# Replace Variable Colours
#
# Replaces the columns in shape object with the colours they have been mapped to
#
# @param shape object to be plotted on map
# @param colours list of colours that will replace the data in shape
replaceVariableColours <- function(shape, colours) {

	eachColour <- do.call(cbind, colours)
	colourNames <- colnames(eachColour)

	## need to strip off attributes so rstudio and browsers can plot the colours
	## (there is an issue with one or the other not recognisign an array ["#FF00FF"])
	shape[, c(unname(colourNames))] <- as.data.frame(eachColour, stringsAsFactors = F)

	return(shape)
}


# Add Defaults
#
# adds the default object parameters to a shape
#
# @param shape object to be plotted on a map
# @param requiredDefaults required columns of default data
# @param shapeType the type of shape
addDefaults <- function(shape, requiredDefaults, shapeType) {

	n <- nrow(shape)
	defaults <- switch(
		shapeType
		, "arc" = arcDefaults(n)
		, "grid" = gridDefaults(n)
		, "line" = lineDefaults(n)
		, "path" = pathDefaults(n)
		, "pointcloud" = pointcloudDefaults(n)
		, "polygon" = polygonDefaults(n)
		, "scatterplot" = scatterplotDefaults(n)
		, "screengrid" = screengridDefaults(n)
		)
	shape <- cbind(shape, defaults[, requiredDefaults, drop = F])
	return(shape)
}


shapeAttributes <- function(fill_colour, stroke_colour, stroke_from, stroke_to) {
	c("stroke_colour" = stroke_colour,
		"fill_colour" = fill_colour,
		"stroke_from" = stroke_from,
		"stroke_to" = stroke_to)
}



