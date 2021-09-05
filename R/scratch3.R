

# library(sf)
# library(geojsonsf)
# library(mapdeck)
# library(data.table)
#
# set_token(read.dcf("~/.mapbox", fields="MAPBOX"))
# sf <- geojsonsf::geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")
# sf <- sf[1:16, ]
#
# ## calling on the full object crashes
# res <- mapdeck() %>%
# 	add_triangle(
# 		data = sf
# 	)
#
# str( res$data )

# sf_poly <- sfheaders::sf_cast(sf, "POLYGON")
#
# lst_ear_1 <- interleave:::rcpp_interleave_triangle(sf_poly$geometry, NULL)
#
# lst_ear_2 <- mapdeck:::rcpp_interleave_primitive_triangle(
# 	sf_poly, integer(0)
# )
#
# all.equal(
# 	lst_ear_1$coordinates
# 	, lst_ear_2$coordinates
# )
# ## Interleaving the coordinates 'works'.
#
# dt_tri <- as.data.table(matrix(lst_ear_1$coordinates, byrow = T, ncol =2))
#
# lst_ear_1$start_indices + 1
# lst_ear_1$geometry_coordinates
#
# dt_ids <- data.table(
# 	polygon_id = lst_ear_1$start_indices + 1
# 	, n_coords = lst_ear_1$geometry_coordinates
# )
#
# dt_ids <- dt_ids[rep(1:.N, n_coords)]
#
# dt_tri <- cbind(dt_tri, dt_ids)
# dt_tri[, triangle_id := rep(1:(.N/3), each = 3)]
#
# sf_tri <- sfheaders::sf_polygon(
# 	ob = dt_tri
# 	, x = "V1"
# 	, y = "V2"
# 	, polygon_id = "triangle_id"
# )
#
#
# mapdeck() %>%
# 	add_polygon(
# 		data = sf_tri
# 		, fill_colour = "triangle_id"
# 	)
#
# ## This is the one with the probable crash
# ## as it also goes through spatialwidget
# # mapdeck:::rcpp_triangle_interleaved()
#
#
# js <- mapdeck() %>%
# 	add_triangle(
# 		data = sf_poly
# 		, fill_colour = "SA2_NAME16"
# 	)
#
# str( js )
#
# lst_js <- jsonify::from_json(js$data)
#
#
# str(lst)
#
# dt_js <- as.data.table(matrix(lst_js$coordinates, ncol = 2, byrow = 2))
#
# all.equal(lst_js$coordinates, lst_ear_1$coordinates)
#
#
# js <- mapdeck() %>%
# 	add_triangle(
# 		data = sf_poly
# 		, fill_colour = "SA2_NAME16"
# 	)
#
# str( js )
#
# lst <- jsonify::from_json(js$data)
#
# ## If this is all correct, why aren't they plotted correctly
# ## and why does it sometimes hang...????
#
# ## can I use the start indices to rebuild those polygons as triangles?
#
#
# dt_tri <- as.data.table(
# 	matrix(lst$coordinates, ncol = 2, byrow = T)
# )
#
# dt_ids <- data.table(
# 	polygon_id = lst$start_indices + 1
# )
#
# dt_ids[, n_coords := shift(polygon_id, type = "lead") - polygon_id]
# dt_ids[is.na(n_coords), n_coords := dt_tri[, .N] - polygon_id + 1]
# dt_ids <- dt_ids[rep(1:.N, n_coords)]
#
# dt_tri <- cbind(dt_tri, dt_ids)
# dt_tri[, triangle_id := rep(1:(.N/3), each = 3)]
#
# sf_tri <- sfheaders::sf_polygon(
# 	ob = dt_tri
# 	, x = "V1"
# 	, y = "V2"
# 	, polygon_id = "triangle_id"
# )
#
#
# mapdeck() %>%
# 	add_polygon(
# 		data = sf_tri
# 		, fill_colour = "triangle_id"
# 	)
#
# ## ^^ This suggests the interleave / triangle functions seem to work...
# ##
#
# mapdeck() %>%
# 	add_triangle(
# 		data = sf_poly
# 	)
#
#
