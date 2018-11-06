#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/line.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List line_defaults(int n) {
	return Rcpp::List::create(
		//_["origin"] = mapdeck::defaults::default_polyline(n),
		//_["destination"] = mapdeck::defaults::default_polyline(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_line_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                              Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = line_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > line_colours = mapdeck::line::line_colours;
	Rcpp::StringVector line_legend = mapdeck::line::line_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		line_colours,
		line_legend,
		data_rows,
		geometry_columns,
		true  // jsonify legend
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_line_geojson_df( Rcpp::DataFrame data, Rcpp::List data_types,
                              Rcpp::List params, Rcpp::List geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = line_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > line_colours = mapdeck::line::line_colours;
	Rcpp::StringVector line_legend = mapdeck::line::line_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		line_colours,
		line_legend,
		data_rows,
		geometry_columns,
		true  // jsonify legend
	);
}
