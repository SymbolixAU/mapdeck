#include <Rcpp.h>

#include "mapdeck.hpp"
#include "layers/scatterplot.hpp"
#include "layers/pointcloud.hpp"
#include "parameters.hpp"

// [[Rcpp::depends(jsonify)]]
#include "jsonify/to_json.hpp"

// [[Rcpp::depends(googlePolylines)]]
//#include "googlePolylines/encode/encode_api.hpp"

Rcpp::List scatterplot_defaults(int n) {
	return Rcpp::List::create(
		_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["radius"] = mapdeck::defaults::default_radius(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
}


// [[Rcpp::export]]
Rcpp::StringVector rcpp_scatterplot( Rcpp::DataFrame data, Rcpp::List params ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults
	Rcpp::StringVector scatterplot_columns = mapdeck::scatterplot::scatterplot_columns;
	Rcpp::StringVector scatterplot_colours = mapdeck::scatterplot::scatterplot_colours;

	Rcpp::DataFrame df = mapdeck::parameters_to_data(
		data, params, lst_defaults, scatterplot_columns, scatterplot_colours, data_rows
	);

	return jsonify::dataframe::to_json( df );
}




Rcpp::List pointcloud_defaults(int n) {
	return Rcpp::List::create(
		_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["radius"] = mapdeck::defaults::default_radius(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
}


// [[Rcpp::export]]
Rcpp::StringVector rcpp_pointcloud( Rcpp::DataFrame data, Rcpp::List params ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = pointcloud_defaults( data_rows );  // initialise with defaults
	Rcpp::StringVector pointcloud_columns = mapdeck::pointcloud::pointcloud_columns;
	Rcpp::StringVector scatterplot_colours = mapdeck::pointcloud::pointcloud_colours;

	Rcpp::DataFrame df = mapdeck::parameters_to_data(
		data, params, lst_defaults, pointcloud_columns, scatterplot_colours, data_rows
	);

	return jsonify::dataframe::to_json( df );
}
