#ifndef R_MAPDECK_LAYERS_LINE_H
#define R_MAPDECK_LAYERS_LINE_H

#include <Rcpp.h>

namespace mapdeck {
namespace line {

	const std::unordered_map< std::string, std::string > line_colours = {
		{ "stroke_colour", "stroke_opacity" }
	};

	const Rcpp::StringVector line_legend = Rcpp::StringVector::create(
		"stroke_colour"
	);

} // namespace line
} // namespace mapdeck

#endif
