#include <Rcpp.h>

#include "R_mapdeck.hpp"
#include "R_scatterplot.hpp"
#include "palette/palette.hpp"

// [[Rcpp::depends(jsonify)]]
#include "jsonify/to_json.hpp"

// [[Rcpp::depends(googlePolylines)]]
//#include "googlePolylines/encode/encode_api.hpp"

using namespace Rcpp;


// TODO
// 1. define which columns are to be in the final data.frame object
// 2. which of 'params' are column names
// - of column name
//

Rcpp::List scatterplot_defaults(int n) {

	return Rcpp::List::create(
		_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["radius"] = mapdeck::defaults::default_radius(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
		//_["fill_opacity"] = 255.0
	);
}

// [[Rcpp::export]]
Rcpp::StringVector test_palette(int data_rows, Function f) {
	Rcpp::StringVector sv = f(data_rows);
	return sv;
}


/*
 * Takes the parameters / arguments supplied by the user and fills a named vector
 * of their indeces in the data supplied by the user
 *
 * why am i doing this... ?
 */
void param_data_column_index( Rcpp::NumericVector& param_indexes,
                              Rcpp::List& params,
                              Rcpp::DataFrame& data) {

	int i = 0;
	int n = params.size();
	Rcpp::StringVector data_names = data.names();

	for ( i = 0; i < n; i++ ) {
		if ( mapdeck::param_is_single_string( params[i] ) ) {
		  Rcpp::StringVector param_value = params[i];
		}
	}

	//Rcpp::Rcout << "param indeces in data: " << param_indexes << std::endl;
}

Rcpp::List construct_params(
		Rcpp::DataFrame& data,
		Rcpp::List& params,
		int& fill_colour_location,
		int& fill_opacity_location
	) {

	int n_params = params.size();
	Rcpp::StringVector param_names = params.names();
	Rcpp::IntegerVector parameter_r_types( n_params );
	Rcpp::IntegerVector data_column_index( n_params, -1 );
	Rcpp::StringVector data_names = data.names();

	int i = 0;
	int parameter_type;

	for (i = 0; i < n_params; i++) {
		parameter_type = mapdeck::get_parameter_r_type( params[i] );
		parameter_r_types[i] = parameter_type;

		if ( parameter_type == STRSXP ) { // STRSXP (string vector)

			Rcpp::StringVector param_value = params[i];
			data_column_index[i] = indexColumnName( param_value, data_names );

			// these colour values are stored for convenience
			// do I also need 'stroke_colour' as well?
			// OR, should I just have a function to find a variable in the 'paramter_names' vector
			// - there shouldn't be much overhead doing that each time for each var?
			if ( param_names[i] == "fill_colour" ) {
				fill_colour_location = i;
			} else if ( param_names[i] == "fill_opacity" ) {
				fill_opacity_location = i;
			}

		}
	}
	return Rcpp::List::create(
		_["parameter"] = param_names,
		_["parameter_type"] = parameter_r_types,
		_["data_column_index"] = data_column_index
	);
}

// SEXP resolve_palette( Rcpp::List& lst_params, Rcpp::List& params ) {
//
// 	SEXP pal = mapdeck::default_palette;
// 	int idx =  find_parameter_index( lst_params, "palette" );
// 	Rcpp::Rcout << "palette index: " << idx << std::endl;
//
// 	if (idx >= 0 ) {
// 		// if function, evaluate it? (or do this in R before entering Rcpp?)
// 		pal = params[ idx ];
// 	}
// 	return pal;
// }

// colour functions:
// Numeric Fill && Numeric Opacity && string palette
// Numeric Fill && Numeric Opacity && matrix palette

// Character fill && Numeric Opacity && string palette
// Character fill && Numeric Opacity && matrix palette

// need to return hex string of colours
// not using Function palettes inside Rcpp - this will be resolved at R level.
void fill_colour(
		Rcpp::List& lst_params,
		Rcpp::List& params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		Rcpp::IntegerVector& data_column_index,
		Rcpp::StringVector& hex_strings,
		SEXP& fill,
		Rcpp::NumericVector& alpha,
		int& fill_colour_location, // locations of the paramter in the parameter list
		int& fill_opacity_location
	) {

	//std::string palette = "viridis";      // TODO
	std::string na_colour = "#808080FF";  // TODO
	bool include_alpha = true;

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
	//Rcpp:Rcout << hex_strings << std::endl;
}

void resolve_fill(
		Rcpp::List& lst_params,
		Rcpp::List& params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		int& fill_colour_location, // locations of the paramter in the parameter list
		int& fill_opacity_location ) {

  Rcpp::IntegerVector data_column_index = lst_params[ "data_column_index" ];
	Rcpp::IntegerVector parameter_type = lst_params[ "parameter_type" ];

	Rcpp::StringVector hex_strings( data.nrows() );
	Rcpp::NumericVector alpha( 1, 255.0 );
	SEXP fill;

	// data_column_index >= 0 are VECTORS
	// data_column_index == -1 && parameter_type

	// TODO - iff a vector of hex strings; don't interpolate
	// TODO - iff colour is a single value? If it's a numeric? need to stop.

	if ( fill_colour_location >= 0 && fill_opacity_location >= 0 ) {
		// both need resolving

		// no need to do anything with the values, becaues it exsits in the data object
		// the final fill_colour will be a hex string with ALPHA  : "#AABBCCFF"
		// in this instance, both fill_colour and fill_opacity exist on the data
		// need to work out their type, Switch, and call colourvalues::

		int alphaColIndex = data_column_index[ fill_opacity_location ];
		int fillColIndex = data_column_index[ fill_colour_location ];

		// Rcpp::Rcout << "alpha col index: " << alphaColIndex << std::endl;
		// Rcpp::Rcout << "fill col index: " << fillColIndex << std::endl;

		if ( fillColIndex == -1 ) {
			// it doesn't exist in the data
			// TODO(check if it's a hex colour and use it for all data)

			fill = lst_defaults[ "fill_colour" ];
		} else {
			fill = data[ fillColIndex ];
		}

		if ( alphaColIndex == -1 ) {
			// TODO(check it's numeric [0, 255]);

		} else {
			alpha = data[ alphaColIndex ];
		}

		fill_colour( lst_params, params, data, lst_defaults, data_column_index, hex_strings,
               fill, alpha, fill_colour_location, fill_opacity_location );

	} else if ( fill_colour_location >= 0 && fill_opacity_location == -1 ) {
		// fill colour needs resolving, and opacity is default

		int fillColIndex = data_column_index[ fill_colour_location ];

		if ( fillColIndex == -1 ) {
			// TODO(check if it's a hex colour and use it for all data)

			fill = lst_defaults[ "fill_colour" ];
		} else {
			fill = data[ fillColIndex ];
		}

		fill_colour( lst_params, params, data, lst_defaults, data_column_index, hex_strings,
               fill, alpha, fill_colour_location, fill_opacity_location );

	} else if ( fill_colour_location == -1 && fill_opacity_location >= 0 ) {

		// fill opacity needs resolving, and colour is default.

		int alphaColIndex = data_column_index[ fill_opacity_location ];
		fill = lst_defaults[ "fill_colour" ];

		if ( alphaColIndex == -1 ) {
			// TODO(check it's numeric [0, 255]);

		} else {
			alpha = data[ alphaColIndex ];
		}

		fill_colour( lst_params, params, data, lst_defaults, data_column_index, hex_strings,
               fill, alpha, fill_colour_location, fill_opacity_location );

	} else {
		// neither fill colour NOR fill_opacity are supplied on the data
		//Rcpp::Rcout << "no fill supplied: " << std::endl;
		// need to use defaults
		fill = lst_defaults[ "fill_colour" ];
		//Rcpp::NumericVector alpha(1, 255.0);  // opacity HAS to be numeric!

		fill_colour( lst_params, params, data, lst_defaults, data_column_index, hex_strings,
               fill, alpha, fill_colour_location, fill_opacity_location );

	}

	//Rcpp::Rcout << "hex strings: " << hex_strings << std::endl;
	lst_defaults[ "fill_colour" ] = hex_strings;
}


// [[Rcpp::export]]
Rcpp::StringVector rcpp_scatterplot( Rcpp::DataFrame data, Rcpp::List params ) {

	int fill_colour_location = -1 ;
	int fill_opacity_location = -1;
	//int palette_location = -1;
	int data_rows = data.nrows();

	Rcpp::StringVector param_names = params.names();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults

	// TODO(parameter checks")
	// - fill_colour & stroke_colour - vector on data, constant hex value
	// - fill_opacity & stroke_opacity - NUMERIC vector on data, constant [0,255]

	Rcpp::List lst_params = construct_params( data, params, fill_colour_location, fill_opacity_location );

	mapdeck::palette::resolve_palette( lst_params, params );

	resolve_fill( lst_params, params, data, lst_defaults, fill_colour_location, fill_opacity_location );

	//Rcpp::Rcout << "fill resolved" << std::endl;

	Rcpp::StringVector cols_remove = mapdeck::scatterplot_colours;

	mapdeck::remove_parameters( params, param_names, mapdeck::scatterplot_colours );

	lst_params = construct_params( data, params, fill_colour_location, fill_opacity_location );

	// TODO(don't do anything if the stroke attribut isn't available)
	//resolve_stroke( )

	//Rcpp::NumericVector param_indexes = mapdeck::scatterplot_param_column_index;
	//param_data_column_index(param_indexes,params, data);


	//Rcpp::StringVector sv = mapdeck::scatterplot_columns;
	//Rcpp::NumericVector data_types( data.ncol() );

	//Rcpp::List data_list = Rcpp::as< Rcpp::List >( data );


	// for ( Rcpp::List::iterator it = data_list.begin(); it != data_list.end(); ++it ) {
	// 	data_types[ counter ] = TYPEOF( *it );
	// 	counter++;
	// }

	int n = params.size();
	int colIndex = -1;

	Rcpp::StringVector data_names = data.names();

	for (int i = 0; i < n; i ++ ) {
		// if the param element is length 1; check if it's a column name

		if( mapdeck::param_is_single_string( params[i] ) ) {
			// it's a single string
			// is it also a column name

			Rcpp::StringVector param_value = params[i];

			colIndex = indexColumnName( param_value, data_names );

			if ( colIndex >= 0) {
				// The param_value IS a column name
				// which 'sv' does it belong in?
				Rcpp::String thisParam = param_names[i];
				std::string this_string_param = thisParam;

				lst_defaults[ thisParam ] = data[ colIndex ];
				// TODO(if it's not a required column (e.g. tooltip), needs to append it to the list)

				// TODO(resolve colours)
				// - scatterplot requires fill_colour and fill_opacity.
				// - it will have been initialised with defaults
				// - if opacity has been provided, is it a vector or a constant?
				// - it has to be numeric.

			}
		} else {
				// TODO(if it's not a column name, but thisParam IS in sv, it's a value to use for the whole column))
				// get the type of 'params[i]'
				// create a vector of that type
				if( mapdeck::param_is_single_string( params[i] ) ) {
  				Rcpp::String thisString = params[i];
   				Rcpp::StringVector sv( data_rows, thisString );
	  			lst_defaults[ thisString ] = sv;
				}
		}
	}

	// to_json accepts SEXP
	//SEXP lst = lst_defaults;

	Rcpp::DataFrame df = mapdeck::construct_df( lst_defaults, data_rows );

	return jsonify::dataframe::to_json( df );

	//return construct_df( lst_defaults, data_rows );
	//return lst_defaults;
}
