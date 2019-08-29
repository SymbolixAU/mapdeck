#include <Rcpp.h>


#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

#include "wasm.hpp"

Rcpp::List scatterplot_defaults(int n) {

	Rcpp::NumericVector nv = Rcpp::NumericVector(n);  // initalised to 0

	return Rcpp::List::create(
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_width"] = nv
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot_geojson(
		Rcpp::DataFrame data, Rcpp::List params,
		std::string geometry_columns, int digits
	) {

  int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > scatterplot_colours = mapdeck::layer_colours::fill_stroke_colours;
	Rcpp::StringVector scatterplot_legend = mapdeck::layer_colours::fill_stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		scatterplot_colours,
		scatterplot_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}




// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot_geojson_df(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::List geometry_columns, int digits
	) {

	Rcpp::Rcout << "calling js function" << std::endl;

	//return Rcpp::List::create();

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > scatterplot_colours = mapdeck::layer_colours::fill_stroke_colours;
	Rcpp::StringVector scatterplot_legend = mapdeck::layer_colours::fill_stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		scatterplot_colours,
		scatterplot_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot_polyline(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::StringVector geometry_columns
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > scatterplot_colours = mapdeck::layer_colours::fill_stroke_colours;
	Rcpp::StringVector scatterplot_legend = mapdeck::layer_colours::fill_stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		scatterplot_colours,
		scatterplot_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
