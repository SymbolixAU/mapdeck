#include <Rcpp.h>


#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

// Rcpp::List grid_defaults(int n) {
// 	return Rcpp::List::create();
// }

Rcpp::List heatmap_defaults(int n) {
	return Rcpp::List::create(
		_["weight"] = mapdeck::defaults::default_weight(n)
	);
}

Rcpp::List hexagon_defaults(int n) {
	return Rcpp::List::create();
}

Rcpp::List screengrid_defaults(int n) {
	return Rcpp::List::create(
		_["weight"] = mapdeck::defaults::default_weight(n)
	);
}

Rcpp::List get_aggregate_defaults( std::string layer_name, int data_rows ) {
	if( layer_name == "heatmap" ) {
		return heatmap_defaults( data_rows );
	// } else if ( layer_name == "grid" ) {
	// 	return grid_defaults( data_rows );
	} else if ( layer_name == "hexagon" ) {
		return hexagon_defaults( data_rows );
	}
	return screengrid_defaults( data_rows );
}


// [[Rcpp::export]]
Rcpp::List rcpp_aggregate_geojson(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_column,
		int digits,
		std::string layer_name
) {

	int data_rows = data.nrows();


	Rcpp::List lst_defaults = get_aggregate_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > aggregate_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector aggregate_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		aggregate_colours,
		aggregate_legend,
		data_rows,
		parameter_exclusions,
		geometry_column,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_aggregate_geojson_df(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::List geometry_columns,
		int digits,
		std::string layer_name
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_aggregate_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > aggregate_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector aggregate_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		aggregate_colours,
		aggregate_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_aggregate_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		std::string layer_name
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_aggregate_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > aggregate_colours = mapdeck::layer_colours::no_colours;
	Rcpp::StringVector aggregate_legend = mapdeck::layer_colours::no_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		aggregate_colours,
		aggregate_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}

