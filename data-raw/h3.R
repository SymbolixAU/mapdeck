

dt <- data.table::fread("https://raw.githubusercontent.com/uber-common/deck.gl-data/master/examples/3d-heatmap/heatmap-data.csv")

dt <- dt[!is.na(lng)]
dt <- dt[!is.na(lat)]

dt_road_safety <- dt[
	, .(hex = h3::geo_to_h3(c(lat, lng)))
][
	, .(count = .N)
	, by = .(hex)
]

road_safety <- as.data.frame(dt_road_safety)

usethis::use_data(road_safety, overwrite = TRUE)

