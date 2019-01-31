#ifndef R_MAPDECK_LAYERS_TEXT_H
#define R_MAPDECK_LAYERS_TEXT_H

#include <Rcpp.h>

namespace mapdeck {
namespace text {

// Rcpp::StringVector text_columns = Rcpp::StringVector::create(
// 	"polyline","tooltip","angle","alignment_baseline","anchor","size"
// );

std::unordered_map< std::string, std::string > text_colours = {
	{ "fill_colour", "fill_opacity" }
};

Rcpp::StringVector text_legend = Rcpp::StringVector::create(
	"fill_colour"
);
} // namespace text
} // namespace mapdeck


#endif
