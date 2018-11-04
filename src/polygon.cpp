#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/polygon.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List polygon_defaults(int n) {
	return Rcpp::List::create(
		//_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n)
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_polygon_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                              Rcpp::List params, Rcpp::StringVector geometry_columns  ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = polygon_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > polygon_colours = mapdeck::polygon::polygon_colours;
	Rcpp::StringVector polygon_legend = mapdeck::polygon::polygon_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		polygon_colours,
		polygon_legend,
		data_rows,
		geometry_columns
	);
}


// // [[Rcpp::export]]
// Rcpp::List rcpp_polygon( Rcpp::DataFrame data, Rcpp::List params ) {
//
// 	int data_rows = data.nrows();
//
// 	Rcpp::List lst_defaults = polygon_defaults( data_rows );  // initialise with defaults
// 	Rcpp::StringVector polygon_columns = mapdeck::polygon::polygon_columns;
// 	std::map< std::string, std::string > polygon_colours = mapdeck::polygon::polygon_colours;
// 	Rcpp::StringVector polygon_legend = mapdeck::polygon::polygon_legend;
//
// 	Rcpp::List lst = mapdeck::parameters_to_data(
// 		data, params, lst_defaults, polygon_columns, polygon_colours, polygon_legend, data_rows
// 	);
//
// 	Rcpp::DataFrame df = Rcpp::as< Rcpp::DataFrame >( lst["data"] );
// 	Rcpp::StringVector js_data = jsonify::dataframe::to_json( df );
//
// 	SEXP legend = lst[ "legend" ];
// 	Rcpp::StringVector js_legend = jsonify::vectors::to_json( legend );
//
// 	return Rcpp::List::create(
// 		Rcpp::_["data"] = js_data,
// 		Rcpp::_["legend"] = js_legend
// 	);
// }


// // [[Rcpp::export]]
// Rcpp::NumericVector rcpp_polygon_timer( Rcpp::DataFrame data, Rcpp::List params ) {
//
// 	int data_rows = data.nrows();
//
// 	Rcpp::List lst_defaults = polygon_defaults( data_rows );  // initialise with defaults
// 	Rcpp::StringVector polygon_columns = mapdeck::polygon::polygon_columns;
// 	std::map< std::string, std::string > polygon_colours = mapdeck::polygon::polygon_colours;
// 	Rcpp::StringVector polygon_legend = mapdeck::polygon::polygon_legend;
//
// 	Rcpp::NumericVector res = mapdeck::parameters_to_data_timer(
// 		data, params, lst_defaults, polygon_columns, polygon_colours, polygon_legend, data_rows
// 		);
//
// 	return res;
// }
