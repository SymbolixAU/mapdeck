#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List line_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_line_geojson(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::StringVector geometry_columns, int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = line_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > line_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector line_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		line_colours,
		line_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_line_geojson_df(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::List geometry_columns, int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = line_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > line_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector line_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		line_colours,
		line_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}



