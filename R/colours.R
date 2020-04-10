
isHexColour <- function(cols){
  hexPattern <- "^#(?:[0-9a-fA-F]{3}){1,2}$|^#(?:[0-9a-fA-F]{4}){1,2}$"
  all(grepl(hexPattern, cols))
}

appendAlpha <- function( col ) {
	if( isHexColour( col ) ) {
		col <- unname(
			vapply(col, function(x) {
				ifelse(
					nchar(x) == 4
					, paste0(x, "F")
					, ifelse(
						nchar(x) == 7
						, paste0(x, "FF")
						, x
						)
					)
				},"" )
		)
	}
	return( col )
}
