// #include <Rcpp.h>
//
// #include "mapdeck.hpp"
// #include "layers/arc.hpp"
// #include "parameters.hpp"
//
// Rcpp::List arc_defaults(int n) {
// 	return Rcpp::List::create(
// 		_["origin"] = mapdeck::defaults::default_polyline(n),
// 		_["destination"] = mapdeck::defaults::default_polyline(n),
// 		_["stroke_from"] = mapdeck::defaults::default_stroke_colour(n),
// 		_["stroke_to"] = mapdeck::defaults::default_stroke_colour(n)
// 	);
// }
//
//
// // [[Rcpp::export]]
// Rcpp::List rcpp_arc( Rcpp::DataFrame data, Rcpp::List params ) {
//
// 	int data_rows = data.nrows();
//
// 	Rcpp::List lst_defaults = arc_defaults( data_rows );  // initialise with defaults
// 	Rcpp::StringVector arc_columns = mapdeck::arc::arc_columns;
// 	std::map< std::string, std::string > arc_colours = mapdeck::arc::arc_colours;
// 	Rcpp::StringVector arc_legend = mapdeck::arc::arc_legend;
//
// 	Rcpp::List lst = mapdeck::parameters_to_data(
// 		data, params, lst_defaults, arc_columns, arc_colours, arc_legend, data_rows
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
//
