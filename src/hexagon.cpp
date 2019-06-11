#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/hexagon.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List hexagon_defaults(int n) {
	return Rcpp::List::create();
}


// [[Rcpp::export]]
Rcpp::List rcpp_hexagon_geojson( Rcpp::DataFrame data, Rcpp::List params,
                                 std::string geometry_columns, int digits ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = hexagon_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > hexagon_colours = mapdeck::hexagon::hexagon_colours;
	Rcpp::StringVector hexagon_legend = mapdeck::hexagon::hexagon_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		hexagon_colours,
		hexagon_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_hexagon_geojson_df( Rcpp::DataFrame data, Rcpp::List params,
                                    Rcpp::List geometry_columns, int digits ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = hexagon_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > hexagon_colours = mapdeck::hexagon::hexagon_colours;
	Rcpp::StringVector hexagon_legend = mapdeck::hexagon::hexagon_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		hexagon_colours,
		hexagon_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,   // jsonify legend
		digits
	);

}

// [[Rcpp::export]]
Rcpp::List rcpp_hexagon_polyline( Rcpp::DataFrame data,
                                 Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = hexagon_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > hexagon_colours = mapdeck::hexagon::hexagon_colours;
	Rcpp::StringVector hexagon_legend = mapdeck::hexagon::hexagon_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		hexagon_colours,
		hexagon_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
