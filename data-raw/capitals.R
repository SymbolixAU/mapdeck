
url <- 'https://lab.lmnixon.org/4th/worldcapitals.html'
doc <- rvest::html(url)
coords <- doc %>%
	rvest::html_table()


coords[[1]]

library(data.table)
dt_coords <- as.data.table(coords[[1]])

setnames(dt_coords, names(dt_coords), c("country","capital","latitude","longitude"))
dt_coords <- dt_coords[2:(.N-3), ]

dt_coords[
	, `:=`(
		lat = as.numeric(gsub("[A-Z]","",latitude))
		, lon = as.numeric(gsub("[A-Z]", "", longitude))
	)
]

dt_coords[
	grepl("S", latitude)
	, `:=`(
		lat = -lat
	)
]

dt_coords[
	grepl("W", longitude)
	, `:=`(
		lon = -lon
	)
]

dt <- dt_coords[, .(country, capital, lat, lon)]
capitals <- as.data.frame(dt)

usethis::use_data(capitals)
