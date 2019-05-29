#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/column.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List column_defaults(int n) {
	return Rcpp::List::create(
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_column_geojson( Rcpp::DataFrame data,
                                 Rcpp::List params, std::string geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = column_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > column_colours = mapdeck::column::column_colours;
	Rcpp::StringVector column_legend = mapdeck::column::column_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		column_colours,
		column_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_column_geojson_df( Rcpp::DataFrame data,
                                    Rcpp::List params, Rcpp::List geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = column_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > column_colours = mapdeck::column::column_colours;
	Rcpp::StringVector column_legend = mapdeck::column::column_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		column_colours,
		column_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);

}

// [[Rcpp::export]]
Rcpp::List rcpp_column_polyline( Rcpp::DataFrame data,
                                  Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = column_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > column_colours = mapdeck::column::column_colours;
	Rcpp::StringVector column_legend = mapdeck::column::column_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		column_colours,
		column_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
