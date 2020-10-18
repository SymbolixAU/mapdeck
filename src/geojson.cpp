#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List geojson_defaults(int n) {
	return Rcpp::List::create(
		_["fill_colour"] = mapdeck::defaults::default_fill_colour( n ),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour( n ),
		_["elevation"] = mapdeck::defaults::default_elevation( n ),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width( n ),
		_["dash_size"] = mapdeck::defaults::default_dash( n ),
		_["dash_gap"] = mapdeck::defaults::default_dash( n )
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_geojson_geojson(
		Rcpp::DataFrame data,
		Rcpp::List params,
		std::string geometry_column,
		int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = geojson_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > geojson_colours = mapdeck::layer_colours::fill_stroke_colours;
	Rcpp::StringVector geojson_legend = mapdeck::layer_colours::fill_stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		geojson_colours,
		geojson_legend,
		data_rows,
		parameter_exclusions,
		geometry_column,
		true,  // jsonify legend
		digits
	);
}

