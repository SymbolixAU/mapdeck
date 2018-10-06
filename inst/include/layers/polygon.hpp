#ifndef R_POLYGON_H
#define R_POLYGON_H

#include <Rcpp.h>

namespace mapdeck {
namespace polygon {

	Rcpp::StringVector polygon_columns = Rcpp::StringVector::create(
		"polyline","elevation","tooltip"
	);

	Rcpp::StringVector polygon_colours = Rcpp::StringVector::create(
		"fill_colour", "fill_opacity","stroke_colour","stroke_opacity","palette"
	);
} // namespace polygon
} // namespace mapdeck


#endif
