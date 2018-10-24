#ifndef R_MAPDECK_LAYERS_PATH_H
#define R_MAPDECK_LAYERS_PATH_H

#include <Rcpp.h>

namespace mapdeck {
namespace path {

	Rcpp::StringVector path_columns = Rcpp::StringVector::create(
		"polyline", "stroke_width", "tooltip"
	);

	Rcpp::StringVector path_colours = Rcpp::StringVector::create(
	  "stroke_colour","stroke_opacity","palette"
	);

	Rcpp::StringVector path_legend = Rcpp::StringVector::create(
		"stroke_colour"
	);
} // namespace path
} // namespace mapdeck


#endif
