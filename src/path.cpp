#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

#include "sfheaders/utils/lists/list.hpp"
#include "sfheaders/interleave/interleave.hpp"

Rcpp::List path_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour( n ),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width( n ),
		_["dash_size"] = mapdeck::defaults::default_dash( n ),
		_["dash_gap"] = mapdeck::defaults::default_dash( n ),
		_["offset"] = mapdeck::defaults::default_offset( n )
	);
}

Rcpp::List trips_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour( n ),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width( n )
	);
}

Rcpp::List get_path_defaults( std::string layer_name, int data_rows ) {
	if( layer_name == "path" ) {
		return path_defaults( data_rows );
	}
	// else trips
	return trips_defaults( data_rows );
}

// [[Rcpp::export]]
SEXP rcpp_path_geojson(
		Rcpp::DataFrame data,  // sf object
		Rcpp::List params,
		int digits,
		std::string layer_name
	) {

	std::string sfc_column = data.attr("sf_column");

	Rcpp::List interleaved = sfheaders::interleave::interleave( data );

	// these defaults need to be the length of the interleaved data, not the original.
	int data_rows = data.nrow();

	Rcpp::List lst_defaults = get_path_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	std::string format = "interleaved";

	Rcpp::List lst = spatialwidget::api::create_interleaved(
		interleaved,
		params,
		lst_defaults,
		path_colours,
		path_legend,
		data_rows,
		parameter_exclusions,
		true, // jsonify legend
		digits,
		format
	);

	// now expand the other binary attribute columns
	// only IFF they are not already the correct lenght
	// (need a way of passing list columns)
	// stroke_width
	//
	Rcpp::List new_df = lst[ "data" ];

	Rcpp::NumericVector stroke_width = new_df["stroke_width"];

	R_xlen_t total_coordinates = interleaved[ "total_coordinates" ];
	Rcpp::IntegerVector n_coordinates = interleaved["n_coordinates"];
	Rcpp::NumericVector expanded_index( total_coordinates );
	R_xlen_t counter = 0;

	R_xlen_t n_geometries = n_coordinates.length();
	R_xlen_t i, j;

	for( i = 0; i < n_geometries; ++i ) {
		R_xlen_t expand_by = n_coordinates[ i ];

		for( j = 0; j < expand_by; ++j ) {
			expanded_index[ counter + j ] = i;
		}
		counter = counter + expand_by;
	}

	Rcpp::StringVector binary_columns = {"stroke_width","dash_size","dash_gap"};
	R_xlen_t n_col = binary_columns.length();

	Rcpp::StringVector binary_names = new_df.names();

	for( i = 0; i < n_col; ++i ) {

		Rcpp::String to_find = binary_columns[ i ];
		R_xlen_t name_position = sfheaders::utils::where_is( to_find, binary_names );
		SEXP v = new_df[ name_position ];
		sfheaders::df::expand_vector( new_df, v, expanded_index, name_position );

	}

	interleaved["data"] = new_df;
	interleaved["legend"] = lst["legend"];

	return interleaved;
}

// [[Rcpp::export]]
Rcpp::List rcpp_path_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		std::string layer_name
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_path_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		path_colours,
		path_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
