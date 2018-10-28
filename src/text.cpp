// #include <Rcpp.h>
//
// #include "mapdeck.hpp"
// #include "layers/text.hpp"
// #include "parameters.hpp"
//
// Rcpp::List text_defaults(int n) {
// 	return Rcpp::List::create(
// 		_["polyline"] = mapdeck::defaults::default_polyline(n),
// 		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
// 		_["anchor"] = mapdeck::defaults::default_text_anchor(n),
// 		_["angle"] = mapdeck::defaults::default_angle(n),
// 		_["alignment_baseline"] = mapdeck::defaults::default_text_alignment(n),
// 		_["size"] = mapdeck::defaults::default_text_size(n)
// 	);
// }
//
//
// // [[Rcpp::export]]
// Rcpp::List rcpp_text( Rcpp::DataFrame data, Rcpp::List params ) {
//
// 	int data_rows = data.nrows();
//
// 	Rcpp::List lst_defaults = text_defaults( data_rows );  // initialise with defaults
// 	Rcpp::StringVector text_columns = mapdeck::text::text_columns;
// 	std::map< std::string, std::string > text_colours = mapdeck::text::text_colours;
// 	Rcpp::StringVector text_legend = mapdeck::text::text_legend;
//
// 	Rcpp::List lst = mapdeck::parameters_to_data(
// 		data, params, lst_defaults, text_columns, text_colours, text_legend, data_rows
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
