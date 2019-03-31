#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/greatcircle.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List greatcircle_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_from"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_to"] = mapdeck::defaults::default_stroke_colour(n),
		_["tilt"] = mapdeck::defaults::default_arc_tilt(n),
		_["height"] = mapdeck::defaults::default_arc_height(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_greatcircle_geojson(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::StringVector geometry_columns, int digits
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = greatcircle_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > greatcircle_colours = mapdeck::greatcircle::greatcircle_colours;
	Rcpp::StringVector greatcircle_legend = mapdeck::greatcircle::greatcircle_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		greatcircle_colours,
		greatcircle_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_greatcircle_geojson_df(
		Rcpp::DataFrame data, Rcpp::List params,
		Rcpp::List geometry_columns, int digits
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = greatcircle_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > greatcircle_colours = mapdeck::greatcircle::greatcircle_colours;
	Rcpp::StringVector greatcircle_legend = mapdeck::greatcircle::greatcircle_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		greatcircle_colours,
		greatcircle_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_greatcircle_polyline( Rcpp::DataFrame data,
                              Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = greatcircle_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > greatcircle_colours = mapdeck::greatcircle::greatcircle_colours;
	Rcpp::StringVector greatcircle_legend = mapdeck::greatcircle::greatcircle_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		greatcircle_colours,
		greatcircle_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
