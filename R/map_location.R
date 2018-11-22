# jsonlite does not support named vector locations; these functions convert
# location arguments to numeric vectors of (mean) lon & lat
extract_location <- function(x)
    UseMethod("extract_location")

extract_location.numeric <- function(x){
    as.numeric(x) # as.numeric automatically strips names
}

extract_location.matrix <- function(x){
    as.numeric(colMeans(x, na.rm = TRUE))
}

extract_location.data.frame <- function(x){ # also tibbles
    extract_location.matrix(x)
}

extract_location.sf <- function(x){
    g <- x[attr(x, "sf_column")] [[1]]
    extract_location_sfc(g)
}

extract_location_sfc <- function(x){
    colMeans(do.call(rbind, lapply(x, as.matrix)))
}
