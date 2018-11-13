#ifndef R_MAPDECK_LAYERS_SCREENGRID_H
#define R_MAPDECK_LAYERS_SCREENGRID_H

#include <Rcpp.h>

namespace mapdeck {
namespace screengrid {

  const std::unordered_map< std::string, std::string > screengrid_colours = {};

  const Rcpp::StringVector screengrid_legend = Rcpp::StringVector::create();

} // namespace screengrid
} // namespace mapdeck


#endif
