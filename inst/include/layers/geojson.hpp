#ifndef R_MAPDECK_LAYERS_GEOJSON_H
#define R_MAPDECK_LAYERS_GEOJSON_H

#include <Rcpp.h>

namespace mapdeck {
namespace geojson {

	const std::unordered_map< std::string, std::string > geojson_colours({
		{ "fill_colour", "fill_opacity" },
		{ "stroke_colour", "stroke_opacity" }
	});

	const Rcpp::StringVector geojson_legend = Rcpp::StringVector::create(
		"fill_colour", "stroke_colour"
	);

} // namespace geojson
} // namespace mapdeck


#endif
