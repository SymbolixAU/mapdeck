

sf <- geojsonsf::geojson_sf( googleway::geo_melbourne )
melbourne <- googlePolylines::encode(sf)

usethis::use_data( melbourne )


melbourne_mesh <- readRDS( "./data/melbourne_mesh.rds")

# mapdeck() %>%
# 	add_mesh(
# 		data = melbourne_mesh
# 	)

usethis::use_data(melbourne_mesh, overwrite = TRUE)
