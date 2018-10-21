#ifndef MAPDECK_LEGEND_H
#define MAPDECK_LEGEND_H

#include <Rcpp.h>
#include "mapdeck.hpp"

Rcpp::List construct_legend_list( Rcpp::List& lst_params,
                                  Rcpp::List& params,
                                  Rcpp::StringVector& param_names,
                                  Rcpp::StringVector& legend_types );

#endif
