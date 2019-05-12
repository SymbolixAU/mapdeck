#ifndef R_MAPDECK_LAYERS_GREATCIRCLE_H
#define R_MAPDECK_LAYERS_GREATCIRCLE_H

#include <Rcpp.h>

namespace mapdeck {
namespace greatcircle {

const std::unordered_map< std::string, std::string > greatcircle_colours = {
	{ "stroke_from", "stroke_from_opacity" },
	{ "stroke_to", "stroke_to_opacity" } // palette??
};

const Rcpp::StringVector greatcircle_legend = Rcpp::StringVector::create(
	"stroke_from", "stroke_to"
);

} // namespace greatcircle
} // namespace mapdeck


#endif
