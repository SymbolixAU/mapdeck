#ifndef R_MAPDECK_LAYERS_POLYGON_H
#define R_MAPDECK_LAYERS_POLYGON_H

#include <Rcpp.h>

namespace mapdeck {
namespace polygon {

	Rcpp::StringVector polygon_columns = Rcpp::StringVector::create(
		"polyline","elevation","tooltip"
	);

	Rcpp::StringVector polygon_colours = Rcpp::StringVector::create(
		"fill_colour", "fill_opacity","stroke_colour","stroke_opacity","palette"
	);

	Rcpp::StringVector polygon_legend = Rcpp::StringVector::create(
		"fill_colour", "stroke_colour"
	);
} // namespace polygon
} // namespace mapdeck


#endif
