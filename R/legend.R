#' Clear Legend
#'
#' Clears the legend for a given layer_id
#'
#' @param map_id the id of the map you want to clear the legend from.
#' @param layer_id single value specifying an id for the layer. Use this value to
#' distinguish between shape layers of the same type. Layers with the same id are likely
#' to conflict and not plot correctly
#'
#' @export
clear_legend <- function( map_id, layer_id ) {
	invoke_method( map_id, "clear_legend", layer_id );
}


resolveLegend <- function(legend, legend_options, colour_palettes) {

	if(any(vapply(legend, isTRUE, T))){
		legend <- constructLegend(colour_palettes, legend)
		if(!is.null(legend_options)){
			legend <- addLegendOptions(legend, legend_options)
		}
	}
	return(legend)
}


constructLegend <- function(colour_palettes, legend){

	## remove any colour_palettes not needed
	cp <- sapply(colour_palettes, function(x) names(x[['variables']]))

	legend <- flattenLegend(legend)

	cp <- cp[cp %in% legend]

	## cp are now the valid colours
	lst <- lapply(colour_palettes, function(x){

		if(all(names(x[['variables']]) %in% cp)){

			## format the palette - needs binning if it's gradient
			type <- getLegendType(x$palette[['variable']])
			x$palette <- formatPalette(x$palette, type)

			list(
				## if both a fill and stroke are used, fill takes precedence
				colourType = ifelse('fill_colour' %in% names(x$variables), 'fill_colour', names(x$variables)[1]),
				type = type,
				title = unique(x$variable),
				legend = x$palette,
				css = NULL,
				position = NULL
			)
		}
	})

	lst[sapply(lst, is.null)] <- NULL
	return(lst)
}


# Format Palette
#
# Formats the palette ready for the legend. A gradient palette is reduced
# to a selected number of 'bins'. A category legend is returned as-is
#
# @param palette the colour palette to format (returned from createColourPalettes())
# @param type the type of leged/palette (returned from getLegendType)
formatPalette <- function(palette, type){
	## palette shoudl be a data.frame
	if(type == "gradient"){

		## TODO:
		## - better representation of the min & max values on the legend
		## - options:
		## -- show the min & max at the extremeties of the legend
		## -- have an option to 'turn off maximum/minimum values
		## -- which will then remove the maxima, and instead use < and + as a
		## -- prefix and suffix to the min/max values

		# rows <- 1:32434



		palette <- palette[with(palette, order(variable)), ]

		## cut the palette
		rows <- 1:nrow(palette)
		rowRange <- range(rows)
		rw <- unique(round(pretty(rows, n = 5)))
		rw <- rw[rw >= rowRange[1] & rw <= rowRange[2]]

		if(rw[1] != 1) rw <- c(1, rw)
		if(rw[length(rw)] != nrow(palette)) rw <- c(rw, nrow(palette))

		palette <- palette[rw, ]
	}
	return(palette)
}

# Get Legned Type
# determins the type of legend to plot given the data
# @param colourColum
getLegendType <- function(colourColumn) UseMethod("getLegendType")

#' @export
getLegendType.numeric <- function(colourColumn) "gradient"

#' @export
getLegendType.default <- function(colourColumn) "category"



flattenLegend <- function(legend) UseMethod("flattenLegend")

#' @export
flattenLegend.list <- function(legend){
	legend <- unlist(legend)
	legend <- names(legend)[legend == T]
	return(legend)
}

#' @export
flattenLegend.logical <- function(legend){
	if(length(names(legend)) > 0){
		## it's a named vector
		legend <- names(legend)[legend]
	}else{
		legend <- legend_colours()[legend]
	}
	return(legend)
}

# add legend options
#
# updates a legend with various options
#
# @param legend constructed from constructLegend()
# @param legend_options list of user defined legend options
addLegendOptions <- function(legend, legend_options){

	## If any names of legend_options not in c("fill_colour", "stroke_colour")
	## then those will be applied to all
	## otherwise, it will be either a fill_colour or a stroke_colour
	nonAesthetics <- names(legend_options)[!names(legend_options) %in% legend_colours()]

	if(length(nonAesthetics) > 0){
		## then we can't use the individual mappings
		legend <- lapply(legend, replaceLegendOption, legend_options)
	}else{
		## apply the mappings directly to the aesthetics
		toMapDirectly <- names(legend_options)[names(legend_options) %in% legend_colours()]
		toMapDirectly <- toMapDirectly[vapply(toMapDirectly, function(x) is.list(legend_options[[x]]), T)]

		legend <- lapply(legend_colours(), function(x){
			idx <- which(vapply(legend, function(y) y$colourType == x, T))
			if(length(idx) > 0){
				replaceLegendOption(legend[[idx]], legend_options[[x]])
			}
		})
	}

	return(legend)
}

replaceLegendOption <- function(legend, legend_option){

	if(!is.null(legend_option[['title']]))
		legend[['title']] <- legend_option[['title']]

	if(!is.null(legend_option[['css']]))
		legend[['css']] <- legend_option[['css']]

	# if(!is.null(legend_option[['position']]))
	# 	legend[['position']] <- legend_option[['position']]


	## reverse
	if(isTRUE(legend_option[['reverse']])){
		df <- legend[['legend']]
		legend[['legend']] <- df[dim(df)[1]:1,]
	}


	#### Formatting values
	legend[['legend']][, 'variable'] <- formatLegendValue(legend[['legend']][, 'variable'])

	if(!is.null(legend_option[['prefix']]))
		legend[['legend']][, 'variable'] <- paste0(legend_option[['prefix']], legend[['legend']][, 'variable'])

	if(!is.null(legend_option[['suffix']]))
		legend[['legend']][, 'variable'] <- paste0(legend[['legend']][, 'variable'], legend_option[['suffix']])

	return(legend)
}


formatLegendValue <- function(legendValue) UseMethod("formatLegendValue")

#' @export
formatLegendValue.numeric <- function(legendValue) format(legendValue, big.mark = ",")

#' @export
formatLegendValue.POSIXct <- function(legendValue){
	tz <- attr(legendValue, 'tzone')
	as.Date(legendValue, tz = tz)
}

#' @export
formatLegendValue.default <- function(legendValue) legendValue

legend_colours <- function() c("fill_colour", "stroke_colour", "stroke_from", "stroke_to")
