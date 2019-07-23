#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List pointcloud_defaults(int n) {
	return Rcpp::List::create(
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_pointcloud_geojson(
		Rcpp::DataFrame data, Rcpp::List params,
		std::string geometry_columns, int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = pointcloud_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > pointcloud_colours = mapdeck::layer_colours::fill_colours;
	Rcpp::StringVector pointcloud_legend = mapdeck::layer_colours::fill_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		pointcloud_colours,
		pointcloud_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits,
		"rgb"
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_pointcloud_geojson_df(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::List geometry_columns, int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = pointcloud_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > pointcloud_colours = mapdeck::layer_colours::fill_colours;
	Rcpp::StringVector pointcloud_legend = mapdeck::layer_colours::fill_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		pointcloud_colours,
		pointcloud_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		true,  // elevation
		digits,
		"rgb"
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_pointcloud_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params, Rcpp::StringVector geometry_columns
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = pointcloud_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > pointcloud_colours = mapdeck::layer_colours::fill_colours;
	Rcpp::StringVector pointcloud_legend = mapdeck::layer_colours::fill_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		pointcloud_colours,
		pointcloud_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		"rgb"
	);
}
