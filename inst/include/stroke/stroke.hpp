#ifndef R_MAPDECK_STROKE_H
#define R_MAPDECK_STROKE_H

#include <Rcpp.h>
#include "palette/palette.hpp"

namespace mapdeck {
namespace stroke {

/*
* stroke colour
* determines the type of variable to use as teh stroke colour (string/numeric)
*
*/
inline void stroke_colour(
		Rcpp::List& lst_params,
		Rcpp::List& params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		Rcpp::IntegerVector& data_column_index,
		Rcpp::StringVector& hex_strings,
		SEXP& stroke,                // string or matrix
		Rcpp::NumericVector& alpha,
		int& stroke_colour_location, // locations of the paramter in the parameter list
		int& stroke_opacity_location
) {

	std::string na_colour = params.containsElementNamed("na_colour") ? params["na_colour" ] : mapdeck::defaults::default_na_colour;
	bool include_alpha = true;            // always true - deck.gl supports alpha

	SEXP pal = mapdeck::palette::resolve_palette( lst_params, params );

	switch ( TYPEOF( stroke ) ) {
	case 16: {
		Rcpp::StringVector stroke_colour_vec = Rcpp::as< Rcpp::StringVector >( stroke );
		hex_strings = mapdeck::palette::colour_with_palette( pal, stroke_colour_vec, alpha, na_colour, include_alpha );
		break;
	}
	default: {
		Rcpp::NumericVector stroke_colour_vec = Rcpp::as< Rcpp::NumericVector >( stroke );
		hex_strings = mapdeck::palette::colour_with_palette( pal, stroke_colour_vec, alpha, na_colour, include_alpha );
		break;
	}
	}
}

inline void resolve_stroke(
		Rcpp::List& lst_params,
		Rcpp::List& params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		int& stroke_colour_location, // locations of the paramter in the parameter list
		int& stroke_opacity_location ) {

	Rcpp::IntegerVector data_column_index = lst_params[ "data_column_index" ];
	Rcpp::IntegerVector parameter_type = lst_params[ "parameter_type" ];

	Rcpp::StringVector hex_strings( data.nrows() );

	Rcpp::NumericVector alpha( 1, 255.0 ); // TODO: the user can supply a single value [0,255] to use in place of this

	SEXP stroke = lst_defaults[ "stroke_colour" ];

	int alphaColIndex = stroke_opacity_location >= 0 ? data_column_index[ stroke_opacity_location ] : -1;
	int strokeColIndex = stroke_colour_location >= 0 ? data_column_index[ stroke_colour_location ] : -1;

	if ( strokeColIndex >= 0 ) {
		stroke = data[ strokeColIndex ];
	} else {
		// TODO ( if it's a hex string, apply it to all rows of data )
		// i.e., when not a column of data, but ISS a hex string
		// so this will be
		// } else if (is_hex_string() ) {
		// Rcpp::StringVector hex( data_rows, hex );
		//}
	}

	if ( alphaColIndex >= 0 ) {
		alpha = data[ alphaColIndex ];
	} else {
		Rcpp::StringVector sv = params.names();
		int find_opacity = mapdeck::find_character_index_in_vector( sv, "stroke_opacity" );
		if (find_opacity >= 0 ) {
			int a = params[ find_opacity ]; // will throw an error if not correct type
			alpha.fill( a );
		}
	}

	mapdeck::stroke::stroke_colour(
		lst_params, params, data, lst_defaults, data_column_index, hex_strings,
		stroke, alpha, stroke_colour_location, stroke_opacity_location
	);

	lst_defaults[ "stroke_colour" ] = hex_strings;
}


} // namespace stroke
} // namespace mapdeck


#endif
