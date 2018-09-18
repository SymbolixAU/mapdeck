#include <Rcpp.h>
#include "R_mapdeck.hpp"
using namespace Rcpp;

Rcpp::StringVector default_polyline(int n) {
	Rcpp::StringVector sv(n);
	sv.fill("");
	return sv;
}

Rcpp::IntegerVector default_elevation(int n) {
  Rcpp::IntegerVector iv(n, 0.0);
	return iv;
}

Rcpp::IntegerVector default_radius(int n) {
  Rcpp::IntegerVector iv(n, 1);
  return iv;
}

Rcpp::NumericVector default_fill_colour( int n ) {
	//return Rcpp::StringVector::create(n, "#440154");
  //Rcpp::StringVector sv(n);
	//sv.fill("#440154FF");
	//return sv;
	Rcpp::NumericVector nv(n, 1.0);
	return nv;
}

Rcpp::NumericVector default_fill_opacity(int n) {
  Rcpp::NumericVector nv(n, 255.0);
	return nv;
}

Rcpp::List construct_df(Rcpp::List df, int nrows) {

	if (nrows < 1) {
		Rcpp::stop("Error creating data layer");
	}

	Rcpp::IntegerVector nv = seq(1, nrows);

	df.attr("class") = "data.frame";
	df.attr("row.names") = nv;

	return df;
}

/*
 * indexColumnName
 * Finds the index of the names of the input data which match the function argument values
 */
int indexColumnName(Rcpp::StringVector& param_value, Rcpp::StringVector& data_names) {

	Rcpp::Rcout << "finding: " << param_value << std::endl;
	Rcpp::Rcout << "in: " << data_names << std::endl;

	int n = data_names.size();
	for (int i = 0; i < n; i++ ) {

		if ( param_value.length() != 1 ) {
			return -1;
		}

		if (param_value[0] == data_names[i] ) {
			return i;
		}
	}
	return -1;
}

bool paramIsSingleString( SEXP param ) {
	return TYPEOF( param ) == STRSXP;
}
