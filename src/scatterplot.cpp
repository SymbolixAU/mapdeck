#include <Rcpp.h>

#include "R_mapdeck.hpp"
#include "R_scatterplot.hpp"
#include "palette/palette.hpp"
#include "fill/fill.hpp"
#include "data_construction.hpp"

// [[Rcpp::depends(jsonify)]]
#include "jsonify/to_json.hpp"

// [[Rcpp::depends(googlePolylines)]]
//#include "googlePolylines/encode/encode_api.hpp"

Rcpp::List scatterplot_defaults(int n) {

	return Rcpp::List::create(
		_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["radius"] = mapdeck::defaults::default_radius(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
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

		mapdeck::fill::fill_colour( lst_params, params, data, lst_defaults, data_column_index, hex_strings,
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

		mapdeck::fill::fill_colour( lst_params, params, data, lst_defaults, data_column_index, hex_strings,
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

		mapdeck::fill::fill_colour( lst_params, params, data, lst_defaults, data_column_index, hex_strings,
               fill, alpha, fill_colour_location, fill_opacity_location );

	} else {
		// neither fill colour NOR fill_opacity are supplied on the data
		//Rcpp::Rcout << "no fill supplied: " << std::endl;
		// need to use defaults
		fill = lst_defaults[ "fill_colour" ];
		//Rcpp::NumericVector alpha(1, 255.0);  // opacity HAS to be numeric!

		mapdeck::fill::fill_colour( lst_params, params, data, lst_defaults, data_column_index, hex_strings,
               fill, alpha, fill_colour_location, fill_opacity_location );

	}

	//Rcpp::Rcout << "hex strings: " << hex_strings << std::endl;
	lst_defaults[ "fill_colour" ] = hex_strings;
}


// [[Rcpp::export]]
Rcpp::StringVector rcpp_scatterplot( Rcpp::DataFrame data, Rcpp::List params ) {

	int fill_colour_location = -1 ;
	int fill_opacity_location = -1;
	int data_rows = data.nrows();

	Rcpp::StringVector param_names = params.names();
	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults
	Rcpp::StringVector scatterplot_columns = mapdeck::scatterplot::scatterplot_columns;

	Rcpp::StringVector data_names = data.names();
	Rcpp::List lst_params = mapdeck::construct_params( data, params, fill_colour_location, fill_opacity_location );
	mapdeck::palette::resolve_palette( lst_params, params );

	resolve_fill( lst_params, params, data, lst_defaults, fill_colour_location, fill_opacity_location );

	Rcpp::StringVector cols_remove = mapdeck::scatterplot::scatterplot_colours;
	mapdeck::remove_parameters( params, param_names, mapdeck::scatterplot::scatterplot_colours );
	lst_params = mapdeck::construct_params( data, params, fill_colour_location, fill_opacity_location );


	Rcpp::DataFrame df = mapdeck::construction::construct_data(
		param_names,
		scatterplot_columns,
		params,
		data_names,
		lst_defaults,
		data,
		data_rows
	);

	return jsonify::dataframe::to_json( df );
}
