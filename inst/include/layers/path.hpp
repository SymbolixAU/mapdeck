#ifndef R_MAPDECK_LAYERS_PATH_H
#define R_MAPDECK_LAYERS_PATH_H

#include <Rcpp.h>

namespace mapdeck {
namespace path {

	const std::unordered_map< std::string, std::string > path_colours = {
		{ "stroke_colour", "stroke_opacity" }
	};

	const Rcpp::StringVector path_legend = Rcpp::StringVector::create(
		"stroke_colour"
	);
} // namespace path
} // namespace mapdeck


#endif
