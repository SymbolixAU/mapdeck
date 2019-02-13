#ifndef R_MAPDECK_LAYERS_TEXT_H
#define R_MAPDECK_LAYERS_TEXT_H

#include <Rcpp.h>

namespace mapdeck {
namespace text {

std::unordered_map< std::string, std::string > text_colours = {
	{ "fill_colour", "fill_opacity" }
};

Rcpp::StringVector text_legend = Rcpp::StringVector::create(
	"fill_colour"
);
} // namespace text
} // namespace mapdeck


#endif
