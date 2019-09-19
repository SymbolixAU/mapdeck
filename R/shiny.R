# replacement for shiny::getDefaultReactiveDomain()
# issue 225
getDefaultReactiveDomain <- function() {
	globals <- getShinyGlobal()
	return( globals$domain )
}

getShinyGlobal <- function() {
	getFromNamespace(".globals", ns = "shiny")
}


createWebDependency <- function( dependency, scrubFile = TRUE ) {
	if (is.null(dependency))
		return(NULL)
	if (!inherits(dependency, "html_dependency"))
		stop("Unexpected non-html_dependency type")
	if (is.null(dependency$src$href)) {
		prefix <- paste(dependency$name, "-", dependency$version,
										sep = "")
		addResourcePath(prefix, dependency$src$file)
		dependency$src$href <- prefix
	}
	if (scrubFile)
		dependency$src$file <- NULL
	return(dependency)
}

getShinyOption <- function( name, default = NULL ) {
	name <- as.character( name )
	global <- getShinyGlobal()
	if( name %in% names( global$options ) ) {
		return( global$options[[name]] )
	} else {
		return( default )
	}
}

addResourcePath <- function( prefix, directoryPath ) {
	if (length(prefix) != 1)
		stop("prefix must be of length 1")
	if (!grepl("^[a-z0-9\\-_][a-z0-9\\-_.]*$", prefix, ignore.case = TRUE,
						 perl = TRUE)) {
		stop("addResourcePath called with invalid prefix; please see documentation")
	}
	if (prefix %in% c("shared")) {
		stop("addResourcePath called with the reserved prefix '",
				 prefix, "'; ", "please use a different prefix")
	}
	normalizedPath <- tryCatch(normalizePath(directoryPath, mustWork = TRUE),
														 error = function(e) {
														 	stop("Couldn't normalize path in `addResourcePath`, with arguments: ",
														 			 "`prefix` = '", prefix, "'; `directoryPath` = '",
														 			 directoryPath, "'")
														 })
	if (!is.null(getShinyOption("server"))) {
		getShinyOption("server")$setStaticPath(.list = stats::setNames(normalizedPath,
																																	 prefix))
	}
	globals <- getShinyGlobal()
	globals$resourcePaths[[prefix]] <- httpuv::staticPath(normalizedPath)
	globals$resources[[prefix]] <- list(directoryPath = normalizedPath,
																			func = staticHandler(normalizedPath))
}

staticHandler <- function( root ) {
	force(root)
	return(function(req) {
		if (!identical(req$REQUEST_METHOD, "GET")) return(NULL)
		path <- URLdecode(req$PATH_INFO)
		if (is.null(path)) return(httpResponse(400, content = "<h1>Bad Request</h1>"))
		if (path == "/") path <- "/index.html"
		if (grepl("\\", path, fixed = TRUE)) return(NULL)
		abs.path <- resolve(root, path)
		if (is.null(abs.path)) return(NULL)
		content.type <- getContentType(abs.path)
		response.content <- readBin(abs.path, "raw", n = file.info(abs.path)$size)
		return(httpResponse(200, content.type, response.content))
	})
}

httpResponse <- function( status = 200, content_type = "text/html; charset=UTF-8",
													content = "", headers = list()) {
	headers <- as.list(headers)
	if (is.null(headers$`X-UA-Compatible`))
		headers$`X-UA-Compatible` <- "IE=edge,chrome=1"
	resp <- list(status = status, content_type = content_type,
							 content = content, headers = headers)
	class(resp) <- "httpResponse"
	return(resp)
}

resolve <- function( dir, relpath ) {
	abs.path <- file.path(dir, relpath)
	if (!file.exists(abs.path))
		return(NULL)
	abs.path <- normalizePath(abs.path, winslash = "/", mustWork = TRUE)
	dir <- normalizePath(dir, winslash = "/", mustWork = TRUE)
	if (.Platform$OS.type == "windows" )
		dir <- sub("/$", "", dir)
	if (nchar(abs.path) <= nchar(dir) + 1)
		return(NULL)
	if (substr(abs.path, 1, nchar(dir)) != dir || substr(abs.path,
																											 nchar(dir) + 1, nchar(dir) + 1) != "/") {
		return(NULL)
	}
	return(abs.path)
}

getContentType <- function( file, defaultType = "application/octet-stream") {
	subtype <- ifelse(grepl("[.]html?$", file), "charset=UTF-8",
										"")
	mime::guess_type(file, unknown = defaultType, subtype = subtype)
}
