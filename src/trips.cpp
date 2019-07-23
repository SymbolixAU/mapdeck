#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List trips_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour( n ),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width( n )
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_trips_geojson(
		Rcpp::DataFrame data,
		Rcpp::List params,
		std::string geometry_columns,
		int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = trips_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > trips_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector trips_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		trips_colours,
		trips_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits,
		"rgb"
	);
}
