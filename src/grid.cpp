#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/grid.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List grid_defaults(int n) {
	return Rcpp::List::create(
		_["polyline"] = mapdeck::defaults::default_polyline(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_grid_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                              Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = grid_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > grid_colours = mapdeck::grid::grid_colours;
	Rcpp::StringVector grid_legend = mapdeck::grid::grid_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		grid_colours,
		grid_legend,
		data_rows,
		geometry_columns,
		true  // jsonify legend
	);

}

// [[Rcpp::export]]
Rcpp::List rcpp_grid_geojson_df( Rcpp::DataFrame data, Rcpp::List data_types,
                              Rcpp::List params, Rcpp::List geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = grid_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > grid_colours = mapdeck::grid::grid_colours;
	Rcpp::StringVector grid_legend = mapdeck::grid::grid_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		grid_colours,
		grid_legend,
		data_rows,
		geometry_columns,
		true  // jsonify legend
	);

}
