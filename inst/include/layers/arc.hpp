#ifndef R_MAPDECK_LAYERS_ARC_H
#define R_MAPDECK_LAYERS_ARC_H

#include <Rcpp.h>

namespace mapdeck {
namespace arc {

Rcpp::StringVector arc_columns = Rcpp::StringVector::create(
	"polyline","elevation","tooltip"
);

// Rcpp::StringVector arc_colours = Rcpp::StringVector::create(
// 	"stroke_from","stroke_from_opacity", "stroke_to","stroke_to_opacity","palette"
// );

std::map< std::string, std::string > arc_colours = {
	{ "stroke_from", "stroke_from_opacity" },
	{ "stroke_to", "stroke_to_opacity" } // palette??
};

Rcpp::StringVector arc_legend = Rcpp::StringVector::create(
	"stroke_from", "stroke_to"
);
} // namespace arc
} // namespace mapdeck


#endif
