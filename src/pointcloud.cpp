#include <Rcpp.h>

#include "mapdeck.hpp"
#include "layers/pointcloud.hpp"
#include "parameters.hpp"

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
	Rcpp::StringVector pointcloud_colours = mapdeck::pointcloud::pointcloud_colours;
	Rcpp::StringVector pointcloud_legend = mapdeck::pointcloud::pointcloud_legend;

	Rcpp::DataFrame df = mapdeck::parameters_to_data(
		data, params, lst_defaults, pointcloud_columns, pointcloud_colours, pointcloud_legend,
		data_rows, true, false
	);

	return jsonify::dataframe::to_json( df );
}
