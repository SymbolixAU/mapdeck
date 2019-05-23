#ifndef R_MAPDECK_LAYERS_MESH_H
#define R_MAPDECK_LAYERS_MESH_H

#include <Rcpp.h>

namespace mapdeck {
namespace mesh {

	const std::unordered_map< std::string, std::string > mesh_colours({
		{ "fill_colour", "fill_opacity" }
	});

	const Rcpp::StringVector mesh_legend = Rcpp::StringVector::create(
		"fill_colour"
	);

} // namespace mesh
} // namespace mapdeck


#endif
