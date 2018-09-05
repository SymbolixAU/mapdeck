#ifndef R_MAPDECK_BASE_H
#define R_MAPDECK_BASE_H

// extensions to base::
Rcpp::NumericVector m_diff(Rcpp::NumericVector x);

Rcpp::NumericVector m_range(Rcpp::NumericVector x);

Rcpp::NumericVector m_seq( double x, double y, int length_out );

Rcpp::NumericVector m_unique( Rcpp::NumericVector x);

Rcpp::NumericVector m_rescale( Rcpp::NumericVector x);

Rcpp::IntegerVector m_findInterval(Rcpp::NumericVector x, Rcpp::NumericVector breaks);

#endif
