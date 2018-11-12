#ifndef R_MAPDECK_LAYERS_POLYGON_H
#define R_MAPDECK_LAYERS_POLYGON_H

#include <Rcpp.h>

namespace mapdeck {
namespace polygon {

	const std::unordered_map< std::string, std::string > polygon_colours({
		{ "fill_colour", "fill_opacity" },
		{ "stroke_colour", "stroke_opacity" }
	});

	const Rcpp::StringVector polygon_legend = Rcpp::StringVector::create(
		"fill_colour", "stroke_colour"
	);

} // namespace polygon
} // namespace mapdeck


#endif
