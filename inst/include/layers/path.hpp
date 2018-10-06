#ifndef R_PATH_H
#define R_PATH_H

#include <Rcpp.h>

namespace mapdeck {
namespace path {

	Rcpp::StringVector path_columns = Rcpp::StringVector::create(
		"polyline", "tooltip"
	);

	Rcpp::StringVector path_colours = Rcpp::StringVector::create(
	  "stroke_colour","stroke_opacity","palette"
	);
} // namespace path
} // namespace mapdeck


#endif
