#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/contour.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List contour_defaults(int n) {
	return Rcpp::List::create(
		//_["polyline"] = mapdeck::defaults::default_polyline(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_contour_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                              Rcpp::List params, std::string geometry_column ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = contour_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > contour_colours = mapdeck::contour::contour_colours;
	Rcpp::StringVector contour_legend = mapdeck::contour::contour_legend;

	return spatialwidget::api::create_geojson_downcast(
		data,
		data_types,
		params,
		lst_defaults,
		contour_colours,
		contour_legend,
		data_rows,
		geometry_column,
		true  // jsonify legend
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_contour_geojson_df( Rcpp::DataFrame data, Rcpp::List data_types,
                                 Rcpp::List params, Rcpp::List geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = contour_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > contour_colours = mapdeck::contour::contour_colours;
	Rcpp::StringVector contour_legend = mapdeck::contour::contour_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		contour_colours,
		contour_legend,
		data_rows,
		geometry_columns,
		true  // jsonify legend
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_contour_polyline( Rcpp::DataFrame data, Rcpp::List data_types,
                               Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = contour_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > contour_colours = mapdeck::contour::contour_colours;
	Rcpp::StringVector contour_legend = mapdeck::contour::contour_legend;

	return spatialwidget::api::create_polyline(
		data,
		data_types,
		params,
		lst_defaults,
		contour_colours,
		contour_legend,
		data_rows,
		geometry_columns,
		true  // jsonify legend
	);
}

