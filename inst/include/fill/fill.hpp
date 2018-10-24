#ifndef R_MAPDECK_FILL_H
#define R_MAPDECK_FILL_H

#include <Rcpp.h>
#include "palette/palette.hpp"

#include <Rcpp/Benchmark/Timer.h>

namespace mapdeck {
namespace fill {

	/*
	 * fill colour
	 * determines the type of variable to use as teh fill colour (string/numeric)
	 *
	 */
	inline Rcpp::List fill_colour(
			Rcpp::List& lst_params,
			Rcpp::List& params,
			Rcpp::DataFrame& data,
			Rcpp::List& lst_defaults,
			Rcpp::IntegerVector& data_column_index,
			//Rcpp::StringVector& hex_strings,
			SEXP& fill,                // string or matrix
			Rcpp::NumericVector& alpha,
			int& fill_colour_location, // locations of the paramter in the parameter list
			int& fill_opacity_location
	) {

		// Rcpp::Timer timer;

		std::string na_colour = params.containsElementNamed("na_colour") ? params["na_colour" ] : mapdeck::defaults::default_na_colour;
		//std::string na_colour =  params[ "na_colour" ];
		bool include_alpha = true;            // always true - deck.gl supports alpha

		//timer.step("resolving palette");
		SEXP pal = mapdeck::palette::resolve_palette( lst_params, params );
		//timer.step("palette resolved");

		switch ( TYPEOF( fill ) ) {
		case 16: {
			//Rcpp::Rcout << "fill category " << std::endl;

			Rcpp::StringVector fill_colour_vec = Rcpp::as< Rcpp::StringVector >( fill );
			Rcpp::List legend = mapdeck::palette::colour_with_palette( pal, fill_colour_vec, alpha, na_colour, include_alpha );
			legend[ "colour_type" ] = "fill_colour";
			legend[ "type" ] = "category";

			return legend;
			break;
		}
		default: {
			// timer.step("starting fill");
			Rcpp::NumericVector fill_colour_vec = Rcpp::as< Rcpp::NumericVector >( fill );
			Rcpp::List legend = mapdeck::palette::colour_with_palette( pal, fill_colour_vec, alpha, na_colour, include_alpha );
			legend[ "colour_type" ] = "fill_colour";
			legend[ "type" ] = "gradient";
			// timer.step("fill done");
			//
			// Rcpp::NumericVector timeresult( timer );
			// int n =  1000000;
			// for( int i = 0; i < timeresult.size(); i++ ) {
			// 	timeresult[i] = timeresult[i] / n;
			// }
			// Rcpp::Rcout << timeresult << std::endl;


			return legend;
			break;
		}
		}
	}

  inline void resolve_fill(
  		Rcpp::List& lst_params,
  		Rcpp::List& params,
  		Rcpp::DataFrame& data,
  		Rcpp::List& lst_defaults,
  		int& fill_colour_location, // locations of the paramter in the parameter list
  		int& fill_opacity_location,
  		Rcpp::List& lst_legend ) {

  	//Rcpp::Timer timer;
  	//timer.step("start");

  	Rcpp::IntegerVector data_column_index = lst_params[ "data_column_index" ];
  	Rcpp::IntegerVector parameter_type = lst_params[ "parameter_type" ];

  	//Rcpp::StringVector hex_strings( data.nrows() );

  	Rcpp::NumericVector alpha( 1, 255.0 ); // TODO: the user can supply a single value [0,255] to use in place of this

  	//timer.step("fill defaults");
  	SEXP fill = lst_defaults[ "fill_colour" ];

  	int alphaColIndex = fill_opacity_location >= 0 ? data_column_index[ fill_opacity_location ] : -1;
  	int fillColIndex = fill_colour_location >= 0 ? data_column_index[ fill_colour_location ] : -1;

  	if ( fillColIndex >= 0 ) {
  		//timer.step("getting fill colours from data");
  		fill = data[ fillColIndex ];
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
  		int find_opacity = mapdeck::find_character_index_in_vector( sv, "fill_opacity" );
  		if (find_opacity >= 0 ) {
  			int a = params[ find_opacity ]; // will throw an error if not correct type
  			alpha.fill( a );
  		}
  	}

  	//timer.step("starting legend");
  	Rcpp::List legend = mapdeck::fill::fill_colour(
  		lst_params, params, data, lst_defaults, data_column_index, //hex_strings,
  		fill, alpha, fill_colour_location, fill_opacity_location
  	);
  	//timer.step("finished legend");

  	bool make_legend ;

  	if ( lst_legend.containsElementNamed("fill_colour") ) {
  	  make_legend = lst_legend[ "fill_colour" ];
  	}

  	lst_defaults[ "fill_colour" ] = legend[ "colours" ];

  	// TODO( don't build legend if not asked for )
  	if ( lst_legend.containsElementNamed("fill_colour") && fillColIndex >= 0 ) {
  		//Rcpp::Rcout << "found fill colour legend" << std::endl;
  		// need the title to be the name of the variable
  		//Rcpp::Rcout << "make_legend " << make_legend << std::endl;
  		if (  make_legend == true ) {
	  		std::string title = params[ "fill_colour" ];

	  		Rcpp::List summary = Rcpp::List::create(
	  			Rcpp::_["colour"] = legend[ "summary_colours" ],
	        Rcpp::_["variable"] = legend[ "summary_values" ],
	        Rcpp::_["colourType"] = legend[ "colour_type" ],
	        Rcpp::_["type"] = legend[ "type" ],
	        Rcpp::_["title"] = title
	  		);
	  		lst_legend[ "fill_colour" ] = summary;
  		}
  	}

  	// Rcpp::NumericVector timeresult( timer );
  	// int n =  1000000;
  	// for( int i = 0; i < timeresult.size(); i++ ) {
  	// 	timeresult[i] = timeresult[i] / n;
  	// }
  	// Rcpp::Rcout << timeresult << std::endl;

  }

} // namespace fill
} // namespace mapdeck


#endif
