#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

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
