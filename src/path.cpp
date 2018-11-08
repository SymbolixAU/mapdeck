#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/path.hpp"
#include "spatialwidget/spatialwidget.hpp"
//#include "spatialwidget/parameters/parameters.hpp"
//#include "spatialwidget/geojson/geojson.hpp"

Rcpp::List path_defaults(int n) {
	return Rcpp::List::create(
		//_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour( n ),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width( n )
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_path_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                              Rcpp::List params, Rcpp::StringVector geometry_columns  ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = path_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > path_colours = mapdeck::path::path_colours;
	Rcpp::StringVector path_legend = mapdeck::path::path_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		path_colours,
		path_legend,
		data_rows,
		geometry_columns,
		true  // jsonify legend
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_path_polyline( Rcpp::DataFrame data, Rcpp::List data_types,
                               Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = path_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > path_colours = mapdeck::path::path_colours;
	Rcpp::StringVector path_legend = mapdeck::path::path_legend;

	return spatialwidget::api::create_polyline(
		data,
		data_types,
		params,
		lst_defaults,
		path_colours,
		path_legend,
		data_rows,
		geometry_columns,
		true  // jsonify legend
	);
}
