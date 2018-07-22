

sf <- geojsonsf::geojson_sf( googleway::geo_melbourne )
melbourne <- googlePolylines::encode(sf)

usethis::use_data( melbourne )

