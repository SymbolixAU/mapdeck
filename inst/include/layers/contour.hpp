#ifndef R_MAPDECK_LAYERS_CONTOUR_H
#define R_MAPDECK_LAYERS_CONTOUR_H

#include <Rcpp.h>

namespace mapdeck {
namespace contour {

const std::unordered_map< std::string, std::string > contour_colours = {};

const Rcpp::StringVector contour_legend = Rcpp::StringVector::create();

} // namespace contour
} // namespace mapdeck


#endif
