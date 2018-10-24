#ifndef R_MAPDECK_COLOUR_H
#define R_MAPDECK_COLOUR_H

#include <Rcpp.h>

Rcpp::List make_colours(
		Rcpp::List& lst_params,
		Rcpp::List& params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		Rcpp::IntegerVector& data_column_index,
		SEXP& palette_type,                // string or matrix
		Rcpp::NumericVector& alpha,
		const char* colour_name );


void resolve_colour(
		Rcpp::List& lst_params,
		Rcpp::List& params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		const char* colour_name,
		const char* opacity_name,
		Rcpp::List& lst_legend );

#endif
