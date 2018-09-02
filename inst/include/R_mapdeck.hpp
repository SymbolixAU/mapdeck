#ifndef R_MAPDECK_H
#define R_MAPDECK_H

#include <Rcpp.h>
using namespace Rcpp;

Rcpp::StringVector default_polyline(int n);

Rcpp::IntegerVector default_elevation(int n);

Rcpp::IntegerVector default_radius(int n);

Rcpp::StringVector default_fill_colour(int n);

Rcpp::IntegerVector default_fill_opacity(int n);

Rcpp::List construct_df(Rcpp::List df, int nrows);

int indexColumnName(Rcpp::StringVector param_value, Rcpp::StringVector data_names);

bool paramIsSingleString( SEXP param );

#endif
