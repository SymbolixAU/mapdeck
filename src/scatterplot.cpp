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

	Rcpp::NumericVector alpha( 1, 255.0 ); // TODO: the user can supply a single value [0,255] to use in place of this

	SEXP fill = lst_defaults[ "fill_colour" ];

	int alphaColIndex = fill_opacity_location >= 0 ? data_column_index[ fill_opacity_location ] : -1;
	int fillColIndex = fill_colour_location >= 0 ? data_column_index[ fill_colour_location ] : -1;

	if ( fillColIndex >= 0 ) {
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

	mapdeck::fill::fill_colour(
		lst_params, params, data, lst_defaults, data_column_index, hex_strings,
		fill, alpha, fill_colour_location, fill_opacity_location
		);

	lst_defaults[ "fill_colour" ] = hex_strings;
}


// [[Rcpp::export]]
Rcpp::StringVector rcpp_scatterplot( Rcpp::DataFrame data, Rcpp::List params ) {

	int fill_colour_location = -1;
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
	mapdeck::remove_parameters( params, param_names, cols_remove );
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
