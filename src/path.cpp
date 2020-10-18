#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

#include "interleave/primitives/primitives.hpp"

#include "geometries/utils/utils.hpp"

//#include "sfheaders/utils/lists/list.hpp"
//#include "sfheaders/interleave/interleave.hpp"

Rcpp::List path_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_colour"] = mapdeck::defaults::default_binary_colour( n ),
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
SEXP rcpp_path_interleaved(
		Rcpp::DataFrame sf,  // sf object
		Rcpp::List params,
		Rcpp::IntegerVector list_columns,
		int digits,
		std::string layer_name
	) {

	R_xlen_t i, j;

	// NOTES:
	// different to polygons, don't need to pass in list columns, they can remian on the
	// data object, because the coordinates don't get shuffled
	Rcpp::StringVector sf_names = sf.names();
	Rcpp::String sfc_column = sf.attr("sf_column");
	SEXP path = sf[ sfc_column.get_cstring() ];

	// R_xlen_t n_col = sf.ncol();
	// Rcpp::List data( n_col - 1 );  // so we don't keep the geometry columns
	// Rcpp::StringVector new_names( n_col - 1 );
	//
	// // unlist list columns
	// R_xlen_t col_counter = 0;
	// for( i = 0; i < n_col; ++i  ) {
	//
	// 	Rcpp::String this_name = sf_names[ i ];
	// 	if( strcmp( sfc_column.get_cstring(), this_name.get_cstring() ) != 0 ) {
	//
	// 		if( geometries::utils::where_is( i, list_columns ) >= 0 ) {
	// 			Rcpp::List this_list = sf[ i ];
	// 			data[ col_counter ] = geometries::utils::unlist_list( this_list );
	// 		} else {
	// 			// need to expand all the other vectors so we get a data.frame
	// 			// because spatialwidget expects data with the same length columns
	// 			data[ col_counter ] = sf[ i ];
	// 		}
	// 		new_names[ col_counter ] = this_name;
	// 		col_counter = col_counter + 1;
	// 	}
	//
	// 	//R_xlen_t name_position = geometries::utils::where_is( to_find, binary_names );
	// 	//SEXP v = new_df[ name_position ];
	// }
	// data.names() = new_names;


	//return data;

	//Rcpp::List dim = geometries::coordinates::geometry_dimensions( path );
	//Rcpp::IntegerMatrix sfc_coordinates = dim[ "dimensions" ];
	//R_xlen_t n_geometries = sfc_coordinates.nrow();
	//R_xlen_t stride = dim[ "max_dimension" ];

	//R_xlen_t total_coordinates = sfc_coordinates( n_geometries - 1 , 1 );

	//int stride = 2; // TODO
	Rcpp::List paths = interleave::primitives::interleave_primitive(
		path, interleave::primitives::INTERLEAVE_LINE
		);

	Rcpp::NumericVector coordinates = paths[ "coordinates" ];
	int total_coordinates = paths[ "total_coordinates" ];
	Rcpp::IntegerVector geometry_coordinates = paths[ "geometry_coordinates" ];
	Rcpp::IntegerVector start_indices = paths["start_indices"];
	int stride = paths[ "stride" ];


	// the object required for spatialwidget::create_interleaved
	// List(
	//  "data" (attributes / properties)
	//  IntegerVector "n_coordinates" (how many coordinates make up each path)
	//  R_xlen_t "total_coordinates"
	// )
	Rcpp::List interleaved = Rcpp::List::create(
		Rcpp::_["data"] = sf,  // TODO: remove the geometry column from data
		Rcpp::_["coordinates"] = coordinates,
		Rcpp::_["total_coordinates"] = total_coordinates,
		Rcpp::_["geometry_coordinates"] = geometry_coordinates,
		Rcpp::_["start_indices"] = start_indices,
		Rcpp::_["stride"] = stride
	);

	//return interleaved;
	//R_xlen_t total_coordinates = interleaved[ "total_coordinates" ];
	//Rcpp::IntegerVector n_coordinates = interleaved[ "n_coordinates" ];



	// these defaults need to be the length of the interleaved data, not the original.
	//int data_rows = data.nrow();

	Rcpp::List lst_defaults = get_path_defaults( layer_name, total_coordinates );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	std::string format = "interleaved";
	Rcpp::StringVector binary_columns = {"stroke_width","dash_size","dash_gap","offset"};

	Rcpp::List lst = spatialwidget::api::create_interleaved(
		interleaved,
		params,
		lst_defaults,
		binary_columns,
		path_colours,
		path_legend,
		total_coordinates,
		parameter_exclusions,
		true, // jsonify legend
		digits,
		format
	);


	return lst;

	// now expand the other binary attribute columns
	// only IFF they are not already the correct length
	// (need a way of passing list columns)
	// stroke_width
	//
	//Rcpp::List new_df = lst[ "data" ];

	//Rcpp::NumericVector stroke_width = new_df["stroke_width"];

	// Rcpp::NumericVector expanded_index( total_coordinates );
	// R_xlen_t counter = 0;
	//
	// R_xlen_t n_geometries = geometry_coordinates.length();
	//
	// for( i = 0; i < n_geometries; ++i ) {
	// 	R_xlen_t expand_by = geometry_coordinates[ i ];
	//
	// 	for( j = 0; j < expand_by; ++j ) {
	// 		expanded_index[ counter + j ] = i;
	// 	}
	// 	counter = counter + expand_by;
	// }
	//
	// Rcpp::StringVector binary_columns = {"stroke_width","dash_size","dash_gap","offset"};
	//
	// Rcpp::StringVector binary_names = new_df.names();
	//
	// for( i = 0; i < binary_columns.length(); ++i ) {
	//
	// 	Rcpp::String to_find = binary_columns[ i ];
	// 	R_xlen_t name_position = geometries::utils::where_is( to_find, binary_names );
	// 	SEXP v = new_df[ name_position ];
	// 	geometries::utils::expand_vector( new_df, v, expanded_index, name_position );
	// }

	//interleaved["data"] = new_df;
	//interleaved["legend"] = lst["legend"];

	//return interleaved;
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
