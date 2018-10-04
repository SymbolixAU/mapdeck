context("rcpp")

## TODO(tests)

## - non-numeric alpha value
## - string, logical, numeric, factor fill values
## - na_colour

test_that("defaults are overwritten by user-supplied arguments from input data", {

	## TODO( n == 2 fails colourvalues::colour_values)

	set.seed(1)
	n <- 5
	df <- data.frame(
		id = 1:n
		, lon = sample(-180:180, size = n, replace = T)
		, lat = sample(-90:90, size = n, replace = T)
		, polyline = sample(letters, size = n, replace = T)
		, rad = 1:n
		, sample = rnorm(n)
		, stringsAsFactors = F
	)
	l <- list(mapdeck::add_scatterplot2, map = map, data = df, lon = "lon",
			 lat = "lat", polyline = "polyline", radius = "rad", fill_colour = "id",
			 fill_opacity = "id", tooltip = "id", palette = "viridis")

	## Scatterplot
	# - lon
	# - lat
	# - polyline
	# - radius
	# - fill_colour
	# - fill_opacity
	# - tooltip

	plot <- mapdeck:::rcpp_scatterplot(df, l)
	expect_true( attr(plot, "class") == "json")
	plot <- jsonlite::fromJSON( plot )

	expect_true( !"lon" %in% names( plot ) )
	expect_true( !"lat" %in% names( plot ) )
	expect_true( all(plot$polyline == df$polyline ) )
	expect_true( all(plot$radius == df$rad) )
	expect_true( all(colourvalues::colour_values(df$id, alpha = df$id) == plot$fill_colour) )
	expect_true( all(plot$tooltip == df$id) )

})

test_that("defaults are overwritten by user-supplied arguments as single values", {

	## TODO( n == 2 fails colourvalues::colour_values)

	set.seed(1)
	n <- 5
	df <- data.frame(
		id = 1:n
		, lon = sample(-180:180, size = n, replace = T)
		, lat = sample(-90:90, size = n, replace = T)
		, polyline = sample(letters, size = n, replace = T)
		, rad = 1:n
		, sample = rnorm(n)
		, stringsAsFactors = F
	)
	l <- list(mapdeck::add_scatterplot2, map = map, data = df, lon = "lon",
						lat = "lat", polyline = "polyline", radius = 20, fill_colour = 100,
						fill_opacity = "id", tooltip = "20", palette = "viridis")

	## Scatterplot
	# - lon
	# - lat
	# - polyline
	# - radius
	# - fill_colour
	# - fill_opacity
	# - tooltip

	plot <- mapdeck:::rcpp_scatterplot(df, l)
	expect_true( attr(plot, "class") == "json")
	plot <- jsonlite::fromJSON( plot )

	expect_true( !"lon" %in% names( plot ) )
	expect_true( !"lat" %in% names( plot ) )
	expect_true( all(plot$polyline == df$polyline ) )
	expect_true( all(plot$radius == 20) )
	expect_true( all(colourvalues::colour_values(rep(100, 5), alpha = df$id) == plot$fill_colour) )
	expect_true( all(plot$tooltip == 20) )

})




