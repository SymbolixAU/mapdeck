#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List arc_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_from"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_to"] = mapdeck::defaults::default_stroke_colour(n),
		_["tilt"] = mapdeck::defaults::default_arc_tilt(n),
		_["height"] = mapdeck::defaults::default_arc_height(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_arc_geojson(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::StringVector geometry_columns, int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = arc_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > arc_colours = mapdeck::layer_colours::stroke_od_colours;
	Rcpp::StringVector arc_legend = mapdeck::layer_colours::stroke_od_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		arc_colours,
		arc_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits,
		"rgb"
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_arc_geojson_df(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::List geometry_columns, int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = arc_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > arc_colours = mapdeck::layer_colours::stroke_od_colours;
	Rcpp::StringVector arc_legend = mapdeck::layer_colours::stroke_od_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		arc_colours,
		arc_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits,
		"rgb"
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_arc_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params, Rcpp::StringVector geometry_columns
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = arc_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > arc_colours = mapdeck::layer_colours::stroke_od_colours;
	Rcpp::StringVector arc_legend = mapdeck::layer_colours::stroke_od_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		arc_colours,
		arc_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		"rgb"
	);
}
