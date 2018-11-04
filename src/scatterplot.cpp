#include <Rcpp.h>


#include "mapdeck_defaults.hpp"
#include "layers/scatterplot.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List scatterplot_defaults(int n) {
	return Rcpp::List::create(
		//_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["radius"] = mapdeck::defaults::default_radius(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                                     Rcpp::List params, Rcpp::StringVector geometry_columns) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > scatterplot_colours = mapdeck::scatterplot::scatterplot_colours;
	Rcpp::StringVector scatterplot_legend = mapdeck::scatterplot::scatterplot_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		scatterplot_colours,
		scatterplot_legend,
		data_rows,
		geometry_columns
	);
}
//
// // [[Rcpp::export]]
// Rcpp::List rcpp_scatterplot_df( Rcpp::DataFrame data, Rcpp::List params, const char* lon, const char* lat) {
//
// 	int data_rows = data.nrows();
//
// 	Rcpp::List lst_defaults = scatterplot_defaults( data_rows );  // initialise with defaults
// 	std::map< std::string, std::string > scatterplot_colours = mapdeck::scatterplot::scatterplot_colours;
// 	Rcpp::StringVector scatterplot_legend = mapdeck::scatterplot::scatterplot_legend;
//
// 	return spatialwidget::api::create_geojson(
// 		data, params, lst_defaults,
// 		scatterplot_colours, scatterplot_legend,
// 		data_rows, lon, lat
// 	);
//
//
// }
