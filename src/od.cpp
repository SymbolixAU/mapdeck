#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List line_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width(n),
		_["height"] = mapdeck::defaults::default_arc_height(n)
	);
}

Rcpp::List arc_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_from"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_to"] = mapdeck::defaults::default_stroke_colour(n),
		_["tilt"] = mapdeck::defaults::default_arc_tilt(n),
		_["height"] = mapdeck::defaults::default_arc_height(n)
	);
}

Rcpp::List greatcircle_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_from"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_to"] = mapdeck::defaults::default_stroke_colour(n),
		_["tilt"] = mapdeck::defaults::default_arc_tilt(n),
		_["height"] = mapdeck::defaults::default_arc_height(n)
	);
}

Rcpp::List get_od_defaults( std::string layer_name, int data_rows ) {
	if( layer_name == "line" ) {
		return line_defaults( data_rows );
	} else if ( layer_name == "arc" ) {
		return arc_defaults( data_rows );
	}
	return greatcircle_defaults( data_rows );
}




std::unordered_map< std::string, std::string > get_od_colours( std::string layer_name ) {

	if( layer_name == "line" ) {
	  return mapdeck::layer_colours::stroke_colours;
	}

	// else arc, greatcircle
	return mapdeck::layer_colours::stroke_od_colours;
}

Rcpp::StringVector get_od_legend( std::string layer_name ) {

	if( layer_name == "line" ) {
		return mapdeck::layer_colours::stroke_legend;;
	}
	// else arc, greatcircle
	return mapdeck::layer_colours::stroke_od_legend;

}

// [[Rcpp::export]]
Rcpp::List rcpp_od_geojson(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		int digits,
		std::string layer_name
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_od_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > od_colours = get_od_colours( layer_name );
	Rcpp::StringVector od_legend = get_od_legend( layer_name );

	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		od_colours,
		od_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_od_geojson_df(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::List geometry_columns,
		int digits,
		std::string layer_name
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_od_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > od_colours = get_od_colours( layer_name );
	Rcpp::StringVector od_legend = get_od_legend( layer_name );

	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		od_colours,
		od_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		true,  // elevation
		digits
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_od_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		std::string layer_name
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_od_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > od_colours = get_od_colours( layer_name );
	Rcpp::StringVector od_legend = get_od_legend( layer_name );

	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		od_colours,
		od_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
