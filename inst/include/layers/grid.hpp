#ifndef R_MAPDECK_LAYERS_GRID_H
#define R_MAPDECK_LAYERS_GRID_H

#include <Rcpp.h>

namespace mapdeck {
namespace grid {

	const std::unordered_map< std::string, std::string > grid_colours = {};

	const Rcpp::StringVector grid_legend = Rcpp::StringVector::create();

} // namespace grid
} // namespace mapdeck


#endif
