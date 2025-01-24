url <- "https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/sf.geohashes.json"
geohash <- jsonify::from_json(url)

usethis::use_data(geohash, overwrite = TRUE)
