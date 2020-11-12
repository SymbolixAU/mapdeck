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
		_["stroke_colour"] = mapdeck::defaults::default_binary_colour( n ),
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
Rcpp::List rcpp_path_geojson(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		int digits,
		std::string layer_name
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_path_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		path_colours,
		path_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,   // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
SEXP rcpp_path_interleaved(
		Rcpp::DataFrame sf,  // sf object
		Rcpp::List params,
		Rcpp::IntegerVector list_columns,
		int digits,
		std::string layer_name
	) {

	// NOTES:
	// different to polygons, don't need to pass in list columns, they can remian on the
	// data object, because the coordinates don't get shuffled
	Rcpp::StringVector sf_names = sf.names();
	Rcpp::String sfc_column = sf.attr("sf_column");
	SEXP path = sf[ sfc_column.get_cstring() ];

	Rcpp::List paths = interleave::primitives::interleave_primitive(
		path, interleave::primitives::INTERLEAVE_LINE
		);

	Rcpp::NumericVector coordinates = paths[ "coordinates" ];
	int total_coordinates = paths[ "total_coordinates" ];
	int n_coordinates = coordinates.length();
	int stride = paths[ "stride" ];

	Rcpp::IntegerVector geometry_coordinates = paths[ "geometry_coordinates" ];
	Rcpp::IntegerVector start_indices = paths["start_indices"];


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

	// these defaults need to be the length of the interleaved data, not the original.
	Rcpp::List lst_defaults = get_path_defaults( layer_name, total_coordinates );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	std::string format = "interleaved";
	Rcpp::StringVector binary_columns = lst_defaults.names();

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
}


// [[Rcpp::export]]
SEXP rcpp_trips_interleaved(
		Rcpp::DataFrame sf,  // sf object
		Rcpp::List params,
		Rcpp::IntegerVector list_columns,
		int digits,
		std::string layer_name,
		int start_time
) {

	// NOTES:
	// different to polygons, don't need to pass in list columns, they can remian on the
	// data object, because the coordinates don't get shuffled
	Rcpp::StringVector sf_names = sf.names();
	Rcpp::String sfc_column = sf.attr("sf_column");
	SEXP path = sf[ sfc_column.get_cstring() ];

	Rcpp::List paths = interleave::primitives::interleave_primitive(
		path, interleave::primitives::INTERLEAVE_LINE
	);

	Rcpp::NumericVector coordinates = paths[ "coordinates" ];
	int total_coordinates = paths[ "total_coordinates" ];
	int n_coordinates = coordinates.length();
	int stride = paths[ "stride" ];

	// TRIPS
	// - every 4th value needs to be put into its own vector and appended to the final df[] as a coulmn 'timestamps'
	Rcpp::NumericVector new_coordinates( total_coordinates * 3 );
	Rcpp::NumericVector timestamps( total_coordinates );
	int i;
	int time_counter = 0;
	int coord_counter = 0;
	for( i = 0; i < n_coordinates; ++i ) {
		if( ( i + 1 ) % 4 == 0 ) {
			timestamps[ time_counter ] = coordinates[ i ] - start_time;
			time_counter = time_counter + 1;
		} else {
			new_coordinates[ coord_counter ] = coordinates[ i ];
			coord_counter = coord_counter + 1;
		}
	}
	coordinates = new_coordinates;
	stride = 3;

	Rcpp::IntegerVector geometry_coordinates = paths[ "geometry_coordinates" ];
	Rcpp::IntegerVector start_indices = paths["start_indices"];


	// the object required for spatialwidget::create_interleaved
	// List(
	//  "data" (attributes / properties)
	//  IntegerVector "n_coordinates" (how many coordinates make up each path)
	//  R_xlen_t "total_coordinates"
	// )
	Rcpp::List interleaved = Rcpp::List::create(
		Rcpp::_["data"] = sf,  // TODO: remove the geometry column from data
		//Rcpp::_["timestamps"] = timestamps,
		Rcpp::_["coordinates"] = coordinates,
		Rcpp::_["total_coordinates"] = total_coordinates,
		Rcpp::_["geometry_coordinates"] = geometry_coordinates,
		Rcpp::_["start_indices"] = start_indices,
		Rcpp::_["stride"] = stride
	);

	// these defaults need to be the length of the interleaved data, not the original.
	Rcpp::List lst_defaults = get_path_defaults( layer_name, total_coordinates );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	std::string format = "interleaved";
	Rcpp::StringVector binary_columns = lst_defaults.names();

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

	int n = lst.size() + 1;
	Rcpp::List res( n );
	for( i = 0; i < lst.size(); ++i ) {
		res[ i ] = lst[ i ];
	}
	res[ lst.size() ] = jsonify::api::to_json( timestamps );
	res.names() = Rcpp::StringVector({"data","legend","timestamps"});
	return res;

	//return lst;
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
