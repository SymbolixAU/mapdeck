#
# library(quadmesh)
# set_token(read.dcf("~/Documents/.googleAPI", fields = "MAPBOX"))
# x <- readRDS( unzip( "~/Downloads/melbourne_mesh.zip") )
#
# mapdeck() %>%
# 	add_mesh(
# 		data = x
# 	)
#
#
#
#
# library(microbenchmark)
#
# microbenchmark(
# 	shape1 = { mapdeck() %>% add_mesh( data = x ) },
# 	shape2 = { mapdeck() %>% add_mesh2( data = x ) },
# 	times = 1
# )
#
#
# x <- readRDS( unzip( "~/Downloads/triangles.zip") )
#
# mapdeck() %>%
# 	add_mesh(
# 		data = x
# 	)
