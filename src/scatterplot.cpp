#include <Rcpp.h>
#include "R_mapdeck.hpp"
#include "R_scatterplot.hpp"
#include "googlePolylines.h"  // TODO(use 'rcpp_encodeSfGeometry()' directly)

// [[Rcpp::depends(RcppViridis)]]
#include "RcppViridis/colours/colours_hex.hpp"

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::StringVector viridis_test(Rcpp::NumericVector x) {
	Rcpp::NumericVector alpha(1);
	alpha[0] = 255;
	std::string palette = "viridis";
	std::string na_colour = "#808080FF";
	bool include_alpha = true;
  return rcppviridis::colours_hex::colour_value_hex( x, palette, na_colour, alpha, include_alpha );
//	return rcppviridis::colours::colour_value_hex(x, "viridis", "#808080");
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
		_["fill_colour"] = default_fill_colour(n)
		//_["fill_opacity"] = default_fill_opacity(n)
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
		hex_strings = rcppviridis::colours_hex::colour_value_hex( x, palette, na_colour, alpha, include_alpha );
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
		hex_strings = rcppviridis::colours_hex::colour_value_hex( x, palette, na_colour, alpha, include_alpha );
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
			Rcpp::Rcout << "param value: " << param_value << std::endl;
			colIndex = indexColumnName( param_value, data_names );
			Rcpp::Rcout << "colIndex: " << colIndex << std::endl;
			//Rcpp::Rcout << "param: " << param_indexes[ param_value ] << std::endl;
		//   param_indexes[ param_value ] = indexColumnName( param_value, data.names() );
		}
	}

	Rcpp::Rcout << "param indeces in data: " << param_indexes << std::endl;
}


// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot(Rcpp::DataFrame data, Rcpp::List params) {

	/*
	if ( indexColumnName( "polyline", data.names() ) == -1 ) {
		Rcpp::stop("polyline column not found");
	}
	*/

	// TODO
	// the R function must allow viridisLite::palette functions as arguments...

	// return a list with attributes (to make it a data.frame)
	// we know the size of the list...
  int data_rows = data.nrows();
	bool fill_resolved = false;
	bool stroke_resolved = false;

	Rcpp::List lst = scatterplot_defaults( data_rows );  // initialise with defaults

	Rcpp::NumericVector param_indexes = mapdeck::scatterplot_param_column_index;


	param_data_column_index(param_indexes,params, data) ;

	Rcpp::StringVector param_names = params.names();
	Rcpp::StringVector sv = mapdeck::scatterplot_columns;
	Rcpp::NumericVector data_types( data.ncol() );

	Rcpp::List data_list = Rcpp::as< Rcpp::List >( data );

	size_t counter = 0;

	for ( Rcpp::List::iterator it = data_list.begin(); it != data_list.end(); ++it ) {
		data_types[ counter ] = TYPEOF(*it);
		counter++;
	}

	int n = params.size();
	int colIndex = -1;

	for (int i = 0; i < n; i ++ ) {
		// if the param element is length 1; check if it's a column name

		if( paramIsSingleString( params[i] ) ) {
			// it's a single string
			// is it also a column name

			Rcpp::StringVector param_value = params[i];
			colIndex = indexColumnName( param_value, data.names() );

			if ( colIndex >= 0) {
				// The param_value IS a column name
				// which 'sv' does it belong in?
				Rcpp::String thisParam = param_names[i];
				std::string this_string_param = thisParam;

				lst[ thisParam ] = data[ colIndex ];
				// TODO(if it's not a required column (e.g. tooltip), needs to append it to the list)

				// TODO(resolve colours)
				// - scatterplot requires fill_colour and fill_opacity.
				// - it will have been initialised with defaults
				// - if opacity has been provided, is it a vector or a constant?
				// - it has to be numeric.


				if ( (this_string_param == "fill_colour" || this_string_param == "fill_opacity") && !fill_resolved) {

					// need to resolve fill colour & opacity
					// if 'this_string_param == 'fill_colour', need to also find 'fill_opacity' in params,
					// then find it in data


					Rcpp::Rcout << "finding fill_colour" << std::endl;

					int this_data_type = data_types[ colIndex ];

					colour_values( data, lst, this_data_type, colIndex, thisParam );

					fill_resolved = true;

				}
			}
		} else {
				// TODO(if it's not a column name, but thisParam IS in sv, it's a value to use for the whole column))
				// get the type of 'params[i]'
				// create a vector of that type
				if( paramIsSingleString( params[i] ) ) {
  				Rcpp::String thisString = params[i];
   				Rcpp::StringVector sv(data_rows, thisString);
	  			lst[ thisString ] = sv;
				}
		}
	}
	return construct_df( lst, data_rows );
}
