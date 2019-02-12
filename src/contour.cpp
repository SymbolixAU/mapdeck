#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/contour.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List contour_defaults(int n) {
	return Rcpp::List::create();
}


// [[Rcpp::export]]
Rcpp::List rcpp_contour_geojson( Rcpp::DataFrame data, Rcpp::List params,
                                 std::string geometry_column, int digits ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = contour_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > contour_colours = mapdeck::contour::contour_colours;
	Rcpp::StringVector contour_legend = mapdeck::contour::contour_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		contour_colours,
		contour_legend,
		data_rows,
		parameter_exclusions,
		geometry_column,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_contour_geojson_df( Rcpp::DataFrame data, Rcpp::List params,
                                    Rcpp::List geometry_columns, int digits ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = contour_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > contour_colours = mapdeck::contour::contour_colours;
	Rcpp::StringVector contour_legend = mapdeck::contour::contour_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		contour_colours,
		contour_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_contour_polyline( Rcpp::DataFrame data, Rcpp::List params,
                                  Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = contour_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > contour_colours = mapdeck::contour::contour_colours;
	Rcpp::StringVector contour_legend = mapdeck::contour::contour_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		contour_colours,
		contour_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}

