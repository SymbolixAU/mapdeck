#' Mapdeck_tokens
#'
#' Retrieves the mapdeck token that has been set
#'
#' @export
mapdeck_tokens <- function() getOption("mapdeck")


#' @export
print.mapdeck_api <- function(x, ...) {

	for (i in 1:length(x)) {

		cat("Mapdeck tokens\n")

		for (j in 1:length(x[[i]])){
			cat(" - ", names(x[[i]])[j], ": ")
			key <- x[[i]][[j]]
			cat(ifelse(is.na(key), "", key), "\n")
		}
	}
}

#' Set Token
#'
#' Sets an access token so it's available for all mapdeck calls. See details
#'
#' @param token Mapbox access token
#'
#' @details
#' Use \code{set_token} to make access tokens available for all the \code{mapdeck()}
#' calls in a session so you don't have to keep specifying the \code{token} argument
#' each time
#'
#' @export
set_token <- function(token) {

	options <- getOption("mapdeck")
	api <- "mapbox" ## future-proofing for other api keys

	options[['mapdeck']][[api]] <- token
	class(options) <- "mapdeck_api"
	options(mapdeck = options)
	invisible(NULL)
}


#' Clear tokens
#'
#' Clears the access tokens
#'
#' @export
clear_tokens <- function() {

	options <- list(
		mapdeck = list(
			mapbox = NA_character_
		)
	)
	attr(options, "class") <- "mapdeck_api"
	options(mapdeck = options)

}

get_access_token <- function(api = "mapbox") {

	## try and find specific key,
	## then go for the general one
	api <- getOption("mapdeck")[['mapdeck']][[api]]
	if(is.null(api) || is.na(api)) stop("Please supply an access token. Use either the 'token' parameter, or use `set_token()`")
	return(api)
}

