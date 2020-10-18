#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List text_defaults(int n) {
	return Rcpp::List::create(
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["anchor"] = mapdeck::defaults::default_text_anchor(n),
		_["angle"] = mapdeck::defaults::default_angle(n),
		_["alignment_baseline"] = mapdeck::defaults::default_text_alignment(n),
		_["size"] = mapdeck::defaults::default_text_size(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_text_geojson(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = text_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > text_colours = mapdeck::layer_colours::fill_colours;
	Rcpp::StringVector text_legend = mapdeck::layer_colours::fill_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		text_colours,
		text_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_text_geojson_df(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::List geometry_columns,
		int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = text_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > text_colours = mapdeck::layer_colours::fill_colours;
	Rcpp::StringVector text_legend = mapdeck::layer_colours::fill_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		text_colours,
		text_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_text_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params, Rcpp::StringVector geometry_columns
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = text_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > text_colours = mapdeck::layer_colours::fill_colours;
	Rcpp::StringVector text_legend = mapdeck::layer_colours::fill_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		text_colours,
		text_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
