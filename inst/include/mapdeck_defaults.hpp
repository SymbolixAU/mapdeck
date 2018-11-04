#ifndef R_MAPDECK_DEFAULTS_H
#define R_MAPDECK_DEFAULTS_H

#include <Rcpp.h>

namespace mapdeck {
namespace defaults {

  // const Rcpp::StringVector default_palette = "viridis";
  // const std::string default_na_colour = "#808080FF";

  // TODO( dont' necessarily need polyline anymore )
	inline Rcpp::StringVector default_polyline( int n ) {
		// created so it's pre-allocated - every data set will require a polylne vector
		Rcpp::StringVector sv(n);
		return sv;
	}
  // TODO( use lon & lat defauts in stead of polyline if using a data.frame of points!)
	inline Rcpp::NumericVector default_lon( int n ) {
		Rcpp::NumericVector nv(n, 0.0);
		return nv;
	}

	inline Rcpp::NumericVector default_lat( int n ) {
		Rcpp::NumericVector nv(n, 0.0);
		return nv;
	}

	inline Rcpp::IntegerVector default_elevation(int n) {
		Rcpp::IntegerVector iv(n, 0.0);
		return iv;
	}

	inline Rcpp::IntegerVector default_radius(int n) {
		Rcpp::IntegerVector iv(n, 1000);
		return iv;
	}

	inline Rcpp::NumericVector default_fill_colour( int n ) {
		Rcpp::NumericVector nv(n, 1.0);
		return nv;
	}

	inline Rcpp::NumericVector default_stroke_colour( int n ) {
		Rcpp::NumericVector nv(n, 1.0);
		return nv;
	}

	inline Rcpp::NumericVector default_fill_opacity( int n ) {
		Rcpp::NumericVector nv(n, 255.0);
		return nv;
	}

	inline Rcpp::NumericVector default_stroke_opacity( int n ) {
		Rcpp::NumericVector nv(n, 255.0);
		return nv;
	}

	inline Rcpp::NumericVector default_stroke_width( int n ) {
		Rcpp::NumericVector nv(n, 1.0);
		return nv;
	}

	inline Rcpp::StringVector default_text_anchor( int n ) {
		Rcpp::StringVector sv(n, "middle");
		return sv;
	}

	inline Rcpp::NumericVector default_angle( int n ) {
		Rcpp::NumericVector nv(n, 0.0);
		return nv;
	}

	inline Rcpp::StringVector default_text_alignment( int n ) {
		Rcpp::StringVector sv(n, "center");
		return sv;
	}

	inline Rcpp::NumericVector default_text_size( int n ) {
		Rcpp::NumericVector nv(n, 32.0);
		return nv;
	}

} // namespace defaults
} // namespace mapdeck



#endif
