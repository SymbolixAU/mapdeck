
library(microbenchmark)

set.seed(12345)
x <- rnorm(n = 1e8, mean = 20, sd = 5)

## diff
microbenchmark(
	base = { diff(x) },
	mapdeck = { mapdeck:::rcpp_diff(x) },
	times = 5
)
# Unit: milliseconds
# expr          min        lq      mean    median        uq      max neval
# base    2708.9137 2733.9890 2796.4497 2763.3843 2814.1295 2961.832     5
# mapdeck  531.1946  537.8336  572.0413  557.3267  586.2815  647.570     5

microbenchmark(
	base = { range(x) },
	mapdeck = { mapdeck:::rcpp_range(x) },
	times = 5
)
# Unit: milliseconds
# expr         min       lq     mean   median       uq       max neval
# base    954.8437 959.7995 981.9079 962.0444 965.2019 1067.6499     5
# mapdeck 534.8436 535.5534 538.1439 536.6304 538.6191  545.0728     5
set.seed(12345)
x <- rnorm(n = 1e7, mean = 20, sd = 5)
microbenchmark(
	base = { unique(x) },
	mapdeck = { mapdeck:::rcpp_unique(x) },
	times = 5
)
# Unit: milliseconds
# expr         min       lq     mean   median       uq      max neval
# base    877.6898 879.9819 903.4638 891.4179 892.0746 976.1548     5
# mapdeck 683.0401 697.7542 720.2502 715.6195 726.6209 778.2161     5

microbenchmark(
	base = { scales::rescale(x) },
	mapdeck = { mapdeck:::rcpp_rescale(x) },
	times = 5
)
# Unit: milliseconds
# expr          min        lq     mean   median       uq      max neval
# base    210.11349 212.04302 244.8254 238.8796 239.2228 323.8682     5
# mapdeck  88.89261  91.10778 107.8947 119.3469 119.4605 120.6658     5

microbenchmark(
	base = { seq(1, 100, length.out = 1e7) },
	mapdeck = { mapdeck:::rcpp_seq(1, 100, 1e7) },
	times = 5
)
# Unit: milliseconds
# expr         min       lq      mean   median       uq      max neval
# base    86.55416 87.86682 140.61361 93.45137 161.4568 273.7389     5
# mapdeck 24.65497 24.93659  59.33839 44.80577 100.0565 102.2381     5

set.seed(12345)
x <- sample(1:50, size = 20, replace = T)

vals <- unique(x)
scaledVals <- scales::rescale(vals)
rng <- range(scaledVals)
s <- seq(rng[1], rng[2], length.out = length(scaledVals) + 1)
f <- findInterval(scaledVals, s, all.inside = T)

n <- list(length(scaledVals))

do.call(viridisLite::viridis, n)[f]
vals


df_old <- mapdeck:::generatePalette.numeric(colData = x, pal = viridisLite::plasma)

df_new <- mapdeck:::rcpp_generate_palette(x, viridisLite::plasma)
names(df_new) <- c("colour", "variable")

df_old[with(df_old, order(variable)), ]
df_new[with(df_new, order(variable)), ]

## need 'unique' to maintain order

set.seed(12345)
x <- sample(1:10000, size = 1e7, replace = T)

microbenchmark(
	old = { mapdeck:::generatePalette.numeric(colData = x, pal = viridisLite::plasma) },
	new = { mapdeck:::rcpp_generate_palette(x, viridisLite::plasma) },
	times = 5
)
# Unit: milliseconds
# expr      min       lq     mean   median        uq      max neval
# old  933.3588 937.0437 981.4558 957.3068 1012.8447 1066.725     5
# new  892.8148 910.6085 946.7140 959.3961  981.9608  988.790     5
#
## was it worth it... ???
