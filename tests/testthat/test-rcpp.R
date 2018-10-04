context("rcpp")

## TODO(tests)

## - non-numeric alpha value


test_that("defaults are overwritten by user-supplied arguments", {

	## TODO( n == 2 fails colourvalues::colour_values)

	set.seed(1)
	n <- 5
	df <- data.frame(
		#	id = sample(letters[1:10], size = 26, replace = T)
		id = 1:n
		#	id = seq(as.Date("2018-01-01"), as.Date("2018-01-26"), by = 1)
		#	id = as.factor(1:26)
		, lon = sample(-180:180, size = n, replace = T)
		, lat = sample(-90:90, size = n, replace = T)
		, polyline = sample(letters, size = n, replace = T)
		, r = 1:n
		, s = rnorm(n)
		, stringsAsFactors = F
	)
	l <- list(mapdeck::add_scatterplot2, map = map, data = df, lon = "lon",
			 lat = "lat", polyline = "polyline", radius = 20, fill_colour = "id",
			 fill_opacity = "id", tooltip = 20, palette = "viridis")

	plot <- mapdeck:::rcpp_scatterplot(df, l)
	expect_true( attr(plot, "class") == "json")
	plot <- jsonlite::fromJSON( plot )
	## expect_true(all(plot$radius == 20)) ## TODO
	expect_true(all(colourvalues::colour_values(df$id, alpha = df$id) == plot$fill_colour))

})
