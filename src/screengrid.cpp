#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/screengrid.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List screengrid_defaults(int n) {
	return Rcpp::List::create(
		//_["polyline"] = mapdeck::defaults::default_polyline(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_screengrid_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                            Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = screengrid_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > screengrid_colours = mapdeck::screengrid::screengrid_colours;
	Rcpp::StringVector screengrid_legend = mapdeck::screengrid::screengrid_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		screengrid_colours,
		screengrid_legend,
		data_rows,
		geometry_columns
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_screengrid_geojson_df( Rcpp::DataFrame data, Rcpp::List data_types,
                                    Rcpp::List params, Rcpp::List geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = screengrid_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > screengrid_colours = mapdeck::screengrid::screengrid_colours;
	Rcpp::StringVector screengrid_legend = mapdeck::screengrid::screengrid_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		screengrid_colours,
		screengrid_legend,
		data_rows,
		geometry_columns
	);
}
