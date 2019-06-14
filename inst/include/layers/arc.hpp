#ifndef R_MAPDECK_LAYERS_ARC_H
#define R_MAPDECK_LAYERS_ARC_H

#include <Rcpp.h>

namespace mapdeck {
namespace arc {

  int x;

	const std::unordered_map< std::string, std::string > arc_colours = {
		{ "stroke_from", "stroke_from_opacity" },
		{ "stroke_to", "stroke_to_opacity" } // palette??
	};

	const Rcpp::StringVector arc_legend = Rcpp::StringVector::create(
		"stroke_from", "stroke_to"
	);

} // namespace arc
} // namespace mapdeck


#endif
