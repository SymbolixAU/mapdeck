#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/text.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List text_defaults(int n) {
	return Rcpp::List::create(
		//_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["anchor"] = mapdeck::defaults::default_text_anchor(n),
		_["angle"] = mapdeck::defaults::default_angle(n),
		_["alignment_baseline"] = mapdeck::defaults::default_text_alignment(n),
		_["size"] = mapdeck::defaults::default_text_size(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_text_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                      Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = text_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > text_colours = mapdeck::text::text_colours;
	Rcpp::StringVector text_legend = mapdeck::text::text_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		text_colours,
		text_legend,
		data_rows,
		geometry_columns
	);
}
