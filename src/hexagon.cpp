// #include <Rcpp.h>
//
// #include "mapdeck.hpp"
// #include "layers/hexagon.hpp"
// #include "parameters.hpp"
//
// Rcpp::List hexagon_defaults(int n) {
// 	return Rcpp::List::create(
// 		_["polyline"] = mapdeck::defaults::default_polyline(n)
// 	);
// }
//
//
// // [[Rcpp::export]]
// Rcpp::List rcpp_hexagon( Rcpp::DataFrame data, Rcpp::List params ) {
//
// 	int data_rows = data.nrows();
//
// 	Rcpp::List lst_defaults = hexagon_defaults( data_rows );  // initialise with defaults
// 	Rcpp::StringVector hexagon_columns = mapdeck::hexagon::hexagon_columns;
// 	std::map< std::string, std::string > hexagon_colours = mapdeck::hexagon::hexagon_colours;
// 	Rcpp::StringVector hexagon_legend = mapdeck::hexagon::hexagon_legend;
//
// 	Rcpp::List lst = mapdeck::parameters_to_data(
// 		data, params, lst_defaults, hexagon_columns, hexagon_colours, hexagon_legend, data_rows
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
