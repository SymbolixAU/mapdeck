#include <Rcpp.h>


#include "mapdeck_defaults.hpp"
#include "layers/scatterplot.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List scatterplot_defaults(int n) {
	return Rcpp::List::create(
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                                     Rcpp::List params, std::string geometry_columns) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > scatterplot_colours = mapdeck::scatterplot::scatterplot_colours;
	Rcpp::StringVector scatterplot_legend = mapdeck::scatterplot::scatterplot_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		data_types,
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


// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot_geojson_df( Rcpp::DataFrame data, Rcpp::List data_types,
                                     Rcpp::List params, Rcpp::List geometry_columns) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > scatterplot_colours = mapdeck::scatterplot::scatterplot_colours;
	Rcpp::StringVector scatterplot_legend = mapdeck::scatterplot::scatterplot_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		data_types,
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

// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot_polyline( Rcpp::DataFrame data, Rcpp::List data_types,
                                     Rcpp::List params, Rcpp::StringVector geometry_columns) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > scatterplot_colours = mapdeck::scatterplot::scatterplot_colours;
	Rcpp::StringVector scatterplot_legend = mapdeck::scatterplot::scatterplot_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		data_types,
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
