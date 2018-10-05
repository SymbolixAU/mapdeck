#ifndef R_MAPDECK_FILL_H
#define R_MAPDECK_FILL_H

#include <Rcpp.h>
#include "palette/palette.hpp"

namespace mapdeck {
namespace fill {

	/*
	 * fill colour
	 * determines the type of variable to use as teh fill colour (string/numeric)
	 *
	 */
	inline void fill_colour(
			Rcpp::List& lst_params,
			Rcpp::List& params,
			Rcpp::DataFrame& data,
			Rcpp::List& lst_defaults,
			Rcpp::IntegerVector& data_column_index,
			Rcpp::StringVector& hex_strings,
			SEXP& fill,                // string or matrix
			Rcpp::NumericVector& alpha,
			int& fill_colour_location, // locations of the paramter in the parameter list
			int& fill_opacity_location
	) {

		std::string na_colour = "#808080FF";  // TODO
		bool include_alpha = true;            // always true - deck.gl supports alpha

		SEXP pal = mapdeck::palette::resolve_palette( lst_params, params );

		switch ( TYPEOF( fill ) ) {
		case 16: {
			Rcpp::StringVector fill_colour_vec = Rcpp::as< Rcpp::StringVector >( fill );
			hex_strings = mapdeck::palette::colour_with_palette( pal, fill_colour_vec, alpha, na_colour, include_alpha );
			break;
		}
		default: {
			Rcpp::NumericVector fill_colour_vec = Rcpp::as< Rcpp::NumericVector >( fill );
			hex_strings = mapdeck::palette::colour_with_palette( pal, fill_colour_vec, alpha, na_colour, include_alpha );
			break;
		}
		}
	}
} // namespace fill
} // namespace mapdeck


#endif
