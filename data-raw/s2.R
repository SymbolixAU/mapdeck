

df <- jsonify::from_json("https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/sf.s2cells.json")

s2 <- as.data.frame(df)

usethis::use_data(s2, overwrite = TRUE)

