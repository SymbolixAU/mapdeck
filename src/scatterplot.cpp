#include <Rcpp.h>

#include "mapdeck.hpp"
#include "layers/scatterplot.hpp"
#include "parameters.hpp"

Rcpp::List scatterplot_defaults(int n) {
	return Rcpp::List::create(
		_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["radius"] = mapdeck::defaults::default_radius(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot( Rcpp::DataFrame data, Rcpp::List params ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults
	Rcpp::StringVector scatterplot_columns = mapdeck::scatterplot::scatterplot_columns;
	Rcpp::StringVector scatterplot_colours = mapdeck::scatterplot::scatterplot_colours;
	Rcpp::StringVector scatterplot_legend = mapdeck::scatterplot::scatterplot_legend;

	Rcpp::List lst = mapdeck::parameters_to_data(
		data, params, lst_defaults, scatterplot_columns, scatterplot_colours, scatterplot_legend,
		data_rows, true, false
	);

	//Rcpp::StringVector res(2);
	Rcpp::DataFrame df = Rcpp::as< Rcpp::DataFrame >( lst["data"] );
	//Rcpp::Rcout << "here" << std::endl;
	Rcpp::StringVector js_data = jsonify::dataframe::to_json( df );
	//Rcpp::Rcout << "res0: " << js_data << std::endl;

	SEXP legend = lst[ "legend" ];
	Rcpp::StringVector js_legend = jsonify::vectors::to_json( legend );
	//Rcpp::Rcout << "res1: " << js_legend << std::endl;

	//return js_data;
	return Rcpp::List::create(
		Rcpp::_["data"] = js_data,
		Rcpp::_["legend"] = js_legend
	);
}


