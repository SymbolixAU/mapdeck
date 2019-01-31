context("legend")

test_that("legend values can be formatted", {

	df <- melbourne
	df$dte <- seq( as.POSIXct("2018-01-01 01:02:30"), as.POSIXct("2019-01-01 13:30:30"), length.out = nrow(df))

	lgnd <- structure("{\"fill_colour\":{\"colour\":[\"#440154FF\",\"#3B528BFF\",\"#21908CFF\",\"#5DC963FF\",\"#FDE725FF\"],\"variable\":[\"2017-12-31T14:02:30\",\"2018-04-01T23:09:30\",\"2018-07-02T08:16:30\",\"2018-10-01T17:23:30\",\"2019-01-01T02:30:30\"],\"colourType\":[\"fill_colour\"],\"type\":[\"gradient\"],\"title\":[\"dte\"],\"css\":[\"\"]},\"stroke_colour\":{\"colour\":[\"#440154FF\",\"#3B528BFF\",\"#21908CFF\",\"#5DC963FF\",\"#FDE725FF\"],\"variable\":[\"1.27\",\"3.06\",\"4.86\",\"6.65\",\"8.44\"],\"colourType\":[\"stroke_colour\"],\"type\":[\"gradient\"],\"title\":[\"AREASQKM\"],\"css\":[\"\"]}}", class = "json")

	format_dates <- function( x ) {
		x <- as.POSIXct(x, tz = "UTC", format = "%Y-%m-%dT%H:%M:%S")
		attr( x, "tzone" ) <- "Australia/Melbourne"
		x <- as.character( x )
		x
	}

	format_number <- function( x ) {
		as.integer( x )
	}

	legend_format <- list(
		fill_colour = format_dates,
		stroke_colour = format_number
	)

	res <- mapdeck:::resolve_legend_format( lgnd, legend_format )

	lst <- jsonlite::fromJSON( res )

	expect_true( all(
		lst$fill_colour$variable == c("2018-01-01 01:02:30", "2018-04-02 09:09:30", "2018-07-02 18:16:30", "2018-10-02 03:23:30", "2019-01-01 13:30:30"))
		)

	expect_true( all( lst$stroke_colour$variable == c(1,3,4,6,8) ) )

})


