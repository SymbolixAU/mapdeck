#include <Rcpp.h>

#include "mapdeck.hpp"
#include "layers/path.hpp"
#include "parameters.hpp"

#include "sf_geojson.hpp"

Rcpp::List path_defaults(int n) {
	return Rcpp::List::create(
		_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width(n)
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_path_geo( Rcpp::DataFrame data, Rcpp::List params ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = path_defaults( data_rows );  // initialise with defaults
	Rcpp::StringVector path_columns = mapdeck::path::path_columns;
	std::map< std::string, std::string > path_colours = mapdeck::path::path_colours;
	Rcpp::StringVector path_legend = mapdeck::path::path_legend;

	return create_data(
		data, params, lst_defaults,
    path_columns, path_colours, path_legend,
		 data_rows
		);
 }
