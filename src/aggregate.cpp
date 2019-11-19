#include <Rcpp.h>


#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List aggregate_defaults(int n) {
	return Rcpp::List::create();
}


// [[Rcpp::export]]
Rcpp::List rcpp_aggregate_geojson(
		Rcpp::DataFrame data,
		Rcpp::List params,
		std::string geometry_column,
		int digits
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = aggregate_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > aggregate_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector aggregate_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		aggregate_colours,
		aggregate_legend,
		data_rows,
		parameter_exclusions,
		geometry_column,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_aggregate_geojson_df(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::List geometry_columns,
		int digits
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = aggregate_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > aggregate_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector aggregate_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		aggregate_colours,
		aggregate_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_aggregate_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = aggregate_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > aggregate_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector aggregate_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		aggregate_colours,
		aggregate_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}

