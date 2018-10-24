#include <Rcpp.h>

#include "mapdeck.hpp"
#include "layers/line.hpp"
#include "parameters.hpp"

Rcpp::List line_defaults(int n) {
	return Rcpp::List::create(
		_["origin"] = mapdeck::defaults::default_polyline(n),
		_["destination"] = mapdeck::defaults::default_polyline(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_line( Rcpp::DataFrame data, Rcpp::List params ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = line_defaults( data_rows );  // initialise with defaults
	Rcpp::StringVector line_columns = mapdeck::line::line_columns;
	std::map< std::string, std::string > line_colours = mapdeck::line::line_colours;
	Rcpp::StringVector line_legend = mapdeck::line::line_legend;

	Rcpp::List lst = mapdeck::parameters_to_data(
		data, params, lst_defaults, line_columns, line_colours, line_legend, data_rows
	);

	Rcpp::DataFrame df = Rcpp::as< Rcpp::DataFrame >( lst["data"] );
	Rcpp::StringVector js_data = jsonify::dataframe::to_json( df );

	SEXP legend = lst[ "legend" ];
	Rcpp::StringVector js_legend = jsonify::vectors::to_json( legend );

	return Rcpp::List::create(
		Rcpp::_["data"] = js_data,
		Rcpp::_["legend"] = js_legend
	);
}
