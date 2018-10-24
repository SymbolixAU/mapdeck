#ifndef R_MAPDECK_LAYERS_SCREENGRID_H
#define R_MAPDECK_LAYERS_SCREENGRID_H

#include <Rcpp.h>

namespace mapdeck {
namespace screengrid {

Rcpp::StringVector screengrid_columns = Rcpp::StringVector::create("polyline");

std::map< std::string, std::string > screengrid_colours = {};

Rcpp::StringVector screengrid_legend = Rcpp::StringVector::create();
} // namespace screengrid
} // namespace mapdeck


#endif
