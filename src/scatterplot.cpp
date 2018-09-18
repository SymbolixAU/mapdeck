#include <Rcpp.h>
#include "R_mapdeck.hpp"
#include "R_scatterplot.hpp"
#include "googlePolylines.h"  // TODO(use 'rcpp_encodeSfGeometry()' directly)

// [[Rcpp::depends(colourvalues)]]
#include "colourvalues/colours/colours_hex.hpp"

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::StringVector viridis_test(Rcpp::NumericVector x) {
	Rcpp::NumericVector alpha(1);
	alpha[0] = 255;
	std::string palette = "viridis";
	std::string na_colour = "#808080FF";
	bool include_alpha = true;
  return colourvalues::colours_hex::colour_value_hex( x, palette, na_colour, alpha, include_alpha );
//	return colourvalues::colours::colour_value_hex(x, "viridis", "#808080");
}

// TODO
// 1. define which columns are to be in the final data.frame object
// 2. which of 'params' are column names
// - of column name
//

Rcpp::List scatterplot_defaults(int n) {

	// TODO(initialise with defaults, OR, test if column of data exists and
	// initialise with that instead? )

	// e.g.
	// _["polyline"] = param[i] %in% data_names ? data["polyline"] : default_polyline(n);

	return Rcpp::List::create(
		_["polyline"] = default_polyline(n),
		_["elevation"] = default_elevation(n),
		_["radius"] = default_radius(n),
		_["fill_colour"] = default_fill_colour(n),
		_["fill_opacity"] = default_fill_opacity(n)
	);
}

// [[Rcpp::export]]
Rcpp::StringVector test_palette(int data_rows, Function f) {
	Rcpp::StringVector sv = f(data_rows);
	return sv;
}


void colour_values( Rcpp::DataFrame& data,
                    Rcpp::List& lst,
                    int& this_data_type,
                    int& colIndex,
                    Rcpp::String& thisParam
                    // std::string& param_value
                    ) {

	Rcpp::StringVector hex_strings( data.nrows() );

	switch( this_data_type ) {

	case STRSXP: {
		// TODO: include alpha?
		Rcpp::StringVector x = data[ colIndex ];

		Rcpp::NumericVector alpha(1, 255.0);
		std::string palette = "viridis";
		std::string na_colour = "#808080FF";
		bool include_alpha = true;
		hex_strings = colourvalues::colours_hex::colour_value_hex( x, palette, na_colour, alpha, include_alpha );
		Rcpp::Rcout << hex_strings << std::endl;
		lst[ thisParam ] = hex_strings;
		break;
	}
	default: {
		Rcpp::NumericVector x = data[ colIndex ];

		Rcpp::NumericVector alpha(1, 255.0);

		std::string palette = "viridis";
		std::string na_colour = "#808080FF";
		bool include_alpha = true;
		hex_strings = colourvalues::colours_hex::colour_value_hex( x, palette, na_colour, alpha, include_alpha );
		Rcpp::Rcout << hex_strings << std::endl;
		lst[ thisParam ] = hex_strings;
		break;
	}

	}
}

/*
 * Resolve Fill Colour
 *
 * If the layer includes a 'fill_colour' (and opacity)
 * Check if user supplied a vector, constant or hex for
 * BOTH fill_colour and fill_opacity
 *
 */
void resolve_fill_colour( Rcpp::DataFrame& data, Rcpp::List lst_defaults ) {

	// defaults will have been initialised
	// find 'fill_colour'
	Rcpp::StringVector fill_colour_param = "fill_colour";
	Rcpp::StringVector fill_opacity_param = "fill_opacity";
	Rcpp::StringVector data_names = data.names();
	//int n_rows = data.nrows();

	int fill_colour_index = indexColumnName( fill_colour_param, data_names );
	int fill_opacity_index = indexColumnName( fill_opacity_param, data_names );

	// if != -1, it will exists in the data object supplied by the user
	//

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
	int colIndex = -1;
	Rcpp::StringVector data_names = data.names();

	for ( i = 0; i < n; i++ ) {
		if ( paramIsSingleString( params[i] ) ) {
		  Rcpp::StringVector param_value = params[i];
			//Rcpp::Rcout << "param value: " << param_value << std::endl;
			//colIndex = indexColumnName( param_value, data_names );
			//Rcpp::Rcout << "colIndex: " << colIndex << std::endl;
			//Rcpp::Rcout << "param: " << param_indexes[ param_value ] << std::endl;
		//   param_indexes[ param_value ] = indexColumnName( param_value, data.names() );
		}
	}

	//Rcpp::Rcout << "param indeces in data: " << param_indexes << std::endl;
}

/*
 * determins the data type in the list of argument parameters (not the data)
 */
int get_parameter_r_type( SEXP param ) {
	return TYPEOF( param );
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
		parameter_type = get_parameter_r_type( params[i] );
		parameter_r_types[i] = parameter_type;

		if ( parameter_type == STRSXP ) { // STRSXP (string vector)
			// is it a column index?
			Rcpp::StringVector param_value = params[i];
			data_column_index[i] = indexColumnName( param_value, data_names );

			// those with data_column_index >= 0 are VECTORS
			// those with data_column_index == -1 AND parameter_type == 14/15/16 are constants!

			if ( param_names[i] == "fill_colour"  ) {
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

// colour functions:
// Numeric Fill && Numeric Opacity && string palette
// Numeric Fill && Numeric Opacity && matrix palette

// Character fill && Numeric Opacity && string palette
// Character fill && Numeric Opacity && matrix palette

// need to return hex string of colours
// not using Function palettes inside Rcpp - this will be resolved at R level.
void call_colour_function( SEXP fill, SEXP opacity ) {

}

void resolve_fill(
		Rcpp::List& lst_params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		int& fill_colour_location, // locations of the paramter in the parameter list
		int& fill_opacity_location ) {
	// TODO
	// to create a column of colours with alpha component.
	// if fill_colour & fill_opacity
	// - iff VECTORS
  Rcpp::IntegerVector data_column_index = lst_params[ "data_column_index" ];
	Rcpp::IntegerVector parameter_type = lst_params[ "parameter_type" ];

	// data_column_index >= 0 are VECTORS
	// data_column_index == -1 && parameter_type

	// Rcpp::StringVector parameters = lst_params["parameter"];

	// TODO - iff a vector of hex strings; don't interpolate

	// Rcpp::NumericMatrix mat;
	// int mattype = TYPEOF( mat );
	// Rcpp::Rcout << "NumericMatrix type: " << mattype << std::endl;




	if ( fill_colour_location >= 0 && fill_opacity_location >= 0 ) {
		// both need resolving

		// no need to do anything with the values, becaues it exsits in the data object
		// the final fill_colour will be a hex string with ALPHA  : "#AABBCCFF"
		// in this instance, both fill_colour and fill_opacity exist on the data
		// need to work out their type, Switch, and call colourvalues::
		SEXP fill_colour_vec_type = data[ fill_colour_location ];
		SEXP fill_opacity_vec_type = data[ fill_opacity_location ];

		// TODO Get the type of column of data on the data object
		int thisType = TYPEOF( fill_colour_vec_type );
		Rcpp::Rcout << "fill colour column type: " << thisType << std::endl;
		// switch( TYPEOF( fill_colour_vec ) ) {
		// case 14: {
		// 	Rcpp::Rcout << "fill is 14 " << std::endl;
		// }
		// case 16: {
		// 	Rcpp::Rcout << "fill is 16" << std::endl;
		// }
		// }


	} else if ( fill_colour_location >= 0 && fill_opacity_location == -1 ) {
		// fill colour needs resolving, and opacity is default

		// Rcpp::NumericVector fill_colour = data[ fill_colour_location ];
		// need to use default fill_colour
		Rcpp::StringVector fill_colour = lst_defaults[ "fill_colour" ];

		SEXP fill_colour_vec_type = data[ fill_colour_location ];

		// TODO Get the type of column of data on the data object
		int thisType = TYPEOF( fill_colour_vec_type );
		Rcpp::Rcout << "fill colour column type: " << thisType << std::endl;

		switch ( TYPEOF( fill_colour_vec_type ) ) {
		case 16: {
			//Rcpp::StringVector fill_colour_vec = Rcpp::as< Rcpp::StringVector >( fill_colour_vec_type );
			Rcpp::Rcout << "fill_colour_location: " << fill_colour_location << std::endl;
			int colIndex = data_column_index[ fill_colour_location ];
			Rcpp::StringVector fill_colour_vec = data[ colIndex ];

			Rcpp::NumericVector alpha(1, 255.0);
			std::string palette = "viridis";
			std::string na_colour = "#808080FF";
			bool include_alpha = true;
			Rcpp::Rcout << fill_colour_vec << std::endl;
			Rcpp::StringVector hex_strings = colourvalues::colours_hex::colour_value_hex( fill_colour_vec, palette, na_colour, alpha, include_alpha );
			Rcpp::Rcout << hex_strings << std::endl;

		}
		default: {
			//Rcpp::NumericVector fill_colour_vec = Rcpp::as< Rcpp::NumericVector >( fill_colour_vec_type );

			Rcpp::Rcout << "fill_colour_location: " << fill_colour_location << std::endl;
			int colIndex = data_column_index[ fill_colour_location ];
			Rcpp::NumericVector fill_colour_vec = data[ colIndex ];

			Rcpp::NumericVector alpha(1, 255.0);
			std::string palette = "viridis";
			std::string na_colour = "#808080FF";
			bool include_alpha = true;
			Rcpp::Rcout << fill_colour_vec << std::endl;
			Rcpp::StringVector hex_strings = colourvalues::colours_hex::colour_value_hex( fill_colour_vec, palette, na_colour, alpha, include_alpha );
			Rcpp::Rcout << hex_strings << std::endl;

		}
		}



	} else if ( fill_opacity_location == -1 && fill_opacity_location >= 0 ) {
		// fill opacity needs resolving, and colour is default.

		// need to use default fill_opacity
		Rcpp::IntegerVector fill_opacity = lst_defaults[ "fill_opacity" ];

		SEXP fill_opacity_vec_type = data[ fill_opacity_location ];


	}

	// to resolve a paramter
	// if it's

}


// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot( Rcpp::DataFrame data, Rcpp::List params ) {

	// TODO()
	// loop over all the available columns of a scatterplot data object (e.g. scatterplot_available_columns)
	// If they are in the 'parameter' column, resolve the arguemnt based on the parameter_type & data_column_index argument:

	// if parameter_type %in% INTSXP, REALSXP, STRSXP && data_column_index == -1,
	// - it's not in the data, so treat it as a constant?
	// if parameter_type %in% INTSXP, REALSXP, STRSXP && data_column_index >= 0,
	// - it's a column of the data

	// do colours first
	//
	int fill_colour_location = -1 ;
	int fill_opacity_location = -1;
	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults

	Rcpp::List lst_params = construct_params( data, params, fill_colour_location, fill_opacity_location );

	resolve_fill( lst_params, data, lst_defaults, fill_colour_location, fill_opacity_location );

	return lst_params;

	/*
	if ( indexColumnName( "polyline", data.names() ) == -1 ) {
		Rcpp::stop("polyline column not found");
	}
	*/

	// TODO
	// the R function must allow viridisLite::palette functions as arguments...

	// return a list with attributes (to make it a data.frame)
	// we know the size of the list...

	int n_data_columns = data.ncol();
	bool fill_resolved = false;
	bool stroke_resolved = false;


	//Rcpp::NumericVector param_indexes = mapdeck::scatterplot_param_column_index;
	//param_data_column_index(param_indexes,params, data);

	Rcpp::StringVector param_names = params.names();
	Rcpp::StringVector sv = mapdeck::scatterplot_columns;
	Rcpp::NumericVector data_types( data.ncol() );

	Rcpp::List data_list = Rcpp::as< Rcpp::List >( data );

	size_t counter = 0;

	for ( Rcpp::List::iterator it = data_list.begin(); it != data_list.end(); ++it ) {
		data_types[ counter ] = TYPEOF( *it );
		counter++;
	}

	int n = params.size();
	int colIndex = -1;

// 	for (int i = 0; i < n; i ++ ) {
// 		// if the param element is length 1; check if it's a column name
//
// 		if( paramIsSingleString( params[i] ) ) {
// 			// it's a single string
// 			// is it also a column name
//
// 			Rcpp::StringVector param_value = params[i];
// 			colIndex = indexColumnName( param_value, data.names() );
//
// 			if ( colIndex >= 0) {
// 				// The param_value IS a column name
// 				// which 'sv' does it belong in?
// 				Rcpp::String thisParam = param_names[i];
// 				std::string this_string_param = thisParam;
//
// 				lst_defaults[ thisParam ] = data[ colIndex ];
// 				// TODO(if it's not a required column (e.g. tooltip), needs to append it to the list)
//
// 				// TODO(resolve colours)
// 				// - scatterplot requires fill_colour and fill_opacity.
// 				// - it will have been initialised with defaults
// 				// - if opacity has been provided, is it a vector or a constant?
// 				// - it has to be numeric.
//
//
// 				if ( (this_string_param == "fill_colour" || this_string_param == "fill_opacity") && !fill_resolved) {
//
// 					// need to resolve fill colour & opacity
// 					// if 'this_string_param == 'fill_colour', need to also find 'fill_opacity' in params,
// 					// then find it in data
//
//
// 					Rcpp::Rcout << "finding fill_colour" << std::endl;
//
// 					int this_data_type = data_types[ colIndex ];
//
// 					colour_values( data, lst_defaults, this_data_type, colIndex, thisParam );
//
// 					fill_resolved = true;
//
// 				}
// 			}
// 		} else {
// 				// TODO(if it's not a column name, but thisParam IS in sv, it's a value to use for the whole column))
// 				// get the type of 'params[i]'
// 				// create a vector of that type
// 				if( paramIsSingleString( params[i] ) ) {
//   				Rcpp::String thisString = params[i];
//    				Rcpp::StringVector sv(data_rows, thisString);
// 	  			lst_defaults[ thisString ] = sv;
// 				}
// 		}
// 	}
	return construct_df( lst_defaults, data_rows );
}
