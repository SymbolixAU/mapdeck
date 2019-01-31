#ifndef R_MAPDECK_LAYERS_HEXAGON_H
#define R_MAPDECK_LAYERS_HEXAGON_H

#include <Rcpp.h>

namespace mapdeck {
namespace hexagon {

	const std::unordered_map< std::string, std::string > hexagon_colours;

	const Rcpp::StringVector hexagon_legend = Rcpp::StringVector::create();

} // namespace hexagon
} // namespace mapdeck


#endif
