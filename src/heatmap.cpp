#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List heatmap_defaults(int n) {
	return Rcpp::List::create(
		_["weight"] = mapdeck::defaults::default_weight(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_heatmap_geojson(
		Rcpp::DataFrame data, Rcpp::List params,
		std::string geometry_columns, int digits
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = heatmap_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > heatmap_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector heatmap_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		heatmap_colours,
		heatmap_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_heatmap_geojson_df(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::List geometry_columns, int digits
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = heatmap_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > heatmap_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector heatmap_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		heatmap_colours,
		heatmap_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_heatmap_polyline(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::StringVector geometry_columns
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = heatmap_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > heatmap_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector heatmap_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		heatmap_colours,
		heatmap_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
