#ifndef R_MAPDECK_LAYERS_LINE_H
#define R_MAPDECK_LAYERS_LINE_H

#include <Rcpp.h>

namespace mapdeck {
namespace line {

// Rcpp::StringVector line_columns = Rcpp::StringVector::create(
// 	"origin","destination", "stroke_width", "tooltip"
// );

// Rcpp::StringVector line_colours = Rcpp::StringVector::create(
// 	"stroke_colour","stroke_opacity","palette"
// );

std::unordered_map< std::string, std::string > line_colours = {
	{ "stroke_colour", "stroke_opacity" }
};

Rcpp::StringVector line_legend = Rcpp::StringVector::create(
	"stroke_colour"
);
} // namespace line
} // namespace mapdeck

#endif
