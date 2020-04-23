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
		_["dash_gap"] = mapdeck::defaults::default_dash( n )
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

	Rcpp::IntegerVector n_coordinates = interleaved["n_coordinates"];
	R_xlen_t total_coordinates = interleaved["total_coordinates"];

	// these defaults need to be the length of the interleaved data, not the original.
	int data_rows = data.nrow();

	Rcpp::List lst_defaults = get_path_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	std::string format = "rgb";

	Rcpp::DataFrame df = Rcpp::as< Rcpp::DataFrame >( interleaved["data"] );

	Rcpp::List lst = spatialwidget::api::format_data(
		df, params, lst_defaults, path_colours, path_legend, data_rows, parameter_exclusions, digits, format
	);

	// after formatting the data, the colour columns are named "stroke_colour" (and "fill_colour")
	// so I can do the interleaving of the colour matrices here

	Rcpp::DataFrame new_df = Rcpp::as< Rcpp::DataFrame >( lst["data"] );

	Rcpp::NumericMatrix stroke_mat = Rcpp::as< Rcpp::NumericMatrix >( new_df["stroke_colour"] );

	R_xlen_t n_geometries = new_df.nrow();

	new_df.attr("class") = R_NilValue;
	new_df.attr("row.names") = R_NilValue;
	// TODO
	// expand the vector and interleave
	// can't use sfheaders::utils::expand_vector()
	// because that only works on vectors.
	// --------
	R_xlen_t i, j;
	Rcpp::NumericVector colour_vec( total_coordinates * 4 );

	R_xlen_t geometry_counter = 0;
	for( i = 0; i < data_rows; ++i ) {
		R_xlen_t reps = n_coordinates[ i ];
		for( j = 0; j < reps; ++j ) {
			colour_vec[ geometry_counter ] = stroke_mat( i, 0 );
			colour_vec[ geometry_counter + 1] = stroke_mat( i, 1 );
			colour_vec[ geometry_counter + 2 ] = stroke_mat( i, 2 );
			colour_vec[ geometry_counter + 3 ] = stroke_mat( i, 3 );
			geometry_counter = geometry_counter + 4;
		}
	}

	new_df["stroke_colour"] = colour_vec;

	// other binary attributes need to be 'expanded'
	Rcpp::StringVector binary_columns = {"stroke_width","dash_size","dash_gap"};


	Rcpp::NumericVector expanded_index( total_coordinates );
	R_xlen_t counter = 0;


	for( i = 0; i < n_geometries; ++i ) {
		R_xlen_t expand_by = n_coordinates[ i ];

		for( j = 0; j < expand_by; ++j ) {
			expanded_index[ counter + j ] = i;
		}
		counter = counter + expand_by;
	}

	R_xlen_t n_col = binary_columns.length();
	//Rcpp::List res( n_col - 1 );
	//Rcpp::StringVector res_names( n_col - 1 );

	//R_xlen_t name_position = 0;
	Rcpp::StringVector binary_names = new_df.names();

	for( i = 0; i < n_col; ++i ) {

		Rcpp::String to_find = binary_columns[ i ];
		R_xlen_t name_position = sfheaders::utils::where_is( to_find, binary_names );
		SEXP v = new_df[ name_position ];
		sfheaders::df::expand_vector( new_df, v, expanded_index, name_position );

	}

	// Rcpp::StringVector js_data = jsonify::api::to_json( lst["data"] );
	// Rcpp::StringVector js_interleaved = jsonify::api::to_json( interleaved );

	// TODO: jsonify this list
	return Rcpp::List::create(
		Rcpp::_["coordinates"] = interleaved["coordinates"],
    Rcpp::_["start_indices"] = interleaved["start_indices"],
    Rcpp::_["stride"] = interleaved["stride"],
    Rcpp::_["data"] = lst["data"],
    Rcpp::_["legend"] = lst["legend"]
	);

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
