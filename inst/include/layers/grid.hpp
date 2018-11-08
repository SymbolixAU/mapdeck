#ifndef R_MAPDECK_LAYERS_GRID_H
#define R_MAPDECK_LAYERS_GRID_H

#include <Rcpp.h>

namespace mapdeck {
namespace grid {

Rcpp::StringVector grid_columns = Rcpp::StringVector::create("polyline");

std::unordered_map< std::string, std::string > grid_colours = {};

Rcpp::StringVector grid_legend = Rcpp::StringVector::create();

} // namespace grid
} // namespace mapdeck


#endif
