#include <Rcpp.h>

#include "mapdeck.hpp"
#include "layers/screengrid.hpp"
#include "parameters.hpp"

Rcpp::List screengrid_defaults(int n) {
	return Rcpp::List::create(
		_["polyline"] = mapdeck::defaults::default_polyline(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_screengrid( Rcpp::DataFrame data, Rcpp::List params ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = screengrid_defaults( data_rows );  // initialise with defaults
	Rcpp::StringVector screengrid_columns = mapdeck::screengrid::screengrid_columns;
	std::map< std::string, std::string > screengrid_colours = mapdeck::screengrid::screengrid_colours;
	Rcpp::StringVector screengrid_legend = mapdeck::screengrid::screengrid_legend;

	Rcpp::List lst = mapdeck::parameters_to_data(
		data, params, lst_defaults, screengrid_columns, screengrid_colours, screengrid_legend, data_rows
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
