// #include <Rcpp.h>
//
// #include "mapdeck.hpp"
// #include "layers/grid.hpp"
// #include "parameters.hpp"
//
// Rcpp::List grid_defaults(int n) {
// 	return Rcpp::List::create(
// 		_["polyline"] = mapdeck::defaults::default_polyline(n)
// 	);
// }
//
//
// // [[Rcpp::export]]
// Rcpp::List rcpp_grid( Rcpp::DataFrame data, Rcpp::List params ) {
//
// 	int data_rows = data.nrows();
//
// 	Rcpp::List lst_defaults = grid_defaults( data_rows );  // initialise with defaults
// 	Rcpp::StringVector grid_columns = mapdeck::grid::grid_columns;
// 	std::map< std::string, std::string > grid_colours = mapdeck::grid::grid_colours;
// 	Rcpp::StringVector grid_legend = mapdeck::grid::grid_legend;
//
// 	Rcpp::List lst = mapdeck::parameters_to_data(
// 		data, params, lst_defaults, grid_columns, grid_colours, grid_legend, data_rows
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
