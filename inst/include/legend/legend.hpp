#ifndef MAPDECK_LEGEND_H
#define MAPDECK_LEGEND_H

#include <Rcpp.h>
#include "mapdeck.hpp"

void set_legend_option( Rcpp::List& opts, const char* option, std::string& value, const char* colour_name );

Rcpp::List construct_legend_list( Rcpp::List& lst_params,
                                  Rcpp::List& params,
                                  Rcpp::StringVector& param_names,
                                  Rcpp::StringVector& legend_types );



// namespace mapdeck {
// namespace legend {
//
//
//
// } // namespace legend
// } // namespace mapdeck

#endif
