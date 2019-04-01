#ifndef R_MAPDECK_LAYERS_COLUMN_H
#define R_MAPDECK_LAYERS_COLUMN_H

#include <Rcpp.h>

namespace mapdeck {
namespace column {

const std::unordered_map< std::string, std::string > column_colours;

const Rcpp::StringVector column_legend = Rcpp::StringVector::create();

} // namespace column
} // namespace mapdeck


#endif
