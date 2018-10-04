#ifndef R_MAPDECK_H
#define R_MAPDECK_H

#include <Rcpp.h>
using namespace Rcpp;

#define PARAM_UNKNOWN  0
#define PARAM_CONSTANT 1
#define PARAM_VECTOR   2

namespace mapdeck {

  inline size_t find_parameter_index( Rcpp::List& lst_params, const char* to_find ) {
  	Rcpp::StringVector parameter_names = lst_params[ "parameter" ];
  	size_t pos = std::distance(
  		parameter_names.begin(),
  		std::find( parameter_names.begin(), parameter_names.end(), to_find )
  	);
  	if ( pos >= parameter_names.size() ) {
  		return -1;
  	}
  	return pos;
  }

  inline Rcpp::List construct_df(Rcpp::List df, int nrows) {

  	if (nrows < 1) {
  		Rcpp::stop("Error creating data layer");
  	}

  	Rcpp::IntegerVector nv = seq(1, nrows);

  	df.attr("class") = "data.frame";
  	df.attr("row.names") = nv;

  	return df;
  }

	inline void remove_parameters(
			Rcpp::List& params,
			Rcpp::StringVector& param_names,
			Rcpp::StringVector& to_remove ) {
		param_names = Rcpp::setdiff( param_names,  to_remove );
		params = params[ param_names ];
	}

  inline bool param_is_single_string( SEXP param ) {
  	return TYPEOF( param ) == STRSXP;
  }

	/*
	 * determins the data type in the list of argument parameters (not the data)
	 */
	inline int get_parameter_r_type( SEXP param ) {
		// A 'variable' passed in is type 1 - SYMSXP
		// A function (c(), list(), matrix(), viridisLite::viridis) is type 6 - LANGSXP
		return TYPEOF( param );
	}

} // namespace mapdeck

// Rcpp::StringVector default_polyline(int n);
//
// Rcpp::IntegerVector default_elevation(int n);
//
// Rcpp::IntegerVector default_radius(int n);
//
// Rcpp::NumericVector default_fill_colour(int n);
//
// Rcpp::NumericVector default_fill_opacity(int n);
//
// Rcpp::List construct_df(Rcpp::List df, int nrows);

int indexColumnName(Rcpp::StringVector& param_value, Rcpp::StringVector& data_names);

//bool paramIsSingleString( SEXP param );

#endif
