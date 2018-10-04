#ifndef R_MAPDECK_DEFAULTS_H
#define R_MAPDECK_DEFAULTS_H

#include <Rcpp.h>

namespace mapdeck {
namespace defaults {

  const Rcpp::StringVector default_palette = "viridis";

	inline Rcpp::StringVector default_polyline(int n) {
		Rcpp::StringVector sv(n);
		sv.fill("");
		return sv;
	}

	inline Rcpp::IntegerVector default_elevation(int n) {
		Rcpp::IntegerVector iv(n, 0.0);
		return iv;
	}

	inline Rcpp::IntegerVector default_radius(int n) {
		Rcpp::IntegerVector iv(n, 100000);
		return iv;
	}

	inline Rcpp::NumericVector default_fill_colour( int n ) {
		Rcpp::NumericVector nv(n, 1.0);
		return nv;
	}

	inline Rcpp::NumericVector default_fill_opacity(int n) {
		Rcpp::NumericVector nv(n, 255.0);
		return nv;
	}


} // namespace defaults
} // namespace mapdeck



#endif
