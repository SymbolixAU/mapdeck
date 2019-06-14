#ifndef R_MAPDECK_LAYERS_TRIPS_H
#define R_MAPDECK_LAYERS_TRIPS_H

#include <Rcpp.h>

namespace mapdeck {
namespace trips {

	const std::unordered_map< std::string, std::string > trips_colours = {
		{ "stroke_colour", "stroke_opacity" }
	};

	const Rcpp::StringVector trips_legend = Rcpp::StringVector::create(
		"stroke_colour"
	);

} // namespace trips
} // namespace mapdeck


#endif
