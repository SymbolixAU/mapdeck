#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"
//#include "sfheaders/df/sf.hpp"
#include "sfheaders/interleave/interleave.hpp"

Rcpp::List path_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour( n ),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width( n ),
		_["dash_size"] = mapdeck::defaults::default_dash( n ),
		_["dash_gap"] = mapdeck::defaults::default_dash( n )
	);
}

Rcpp::List trips_defaults(int n) {
	return Rcpp::List::create(
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour( n ),
		_["stroke_width"] = mapdeck::defaults::default_stroke_width( n )
	);
}

Rcpp::List get_path_defaults( std::string layer_name, int data_rows ) {
	if( layer_name == "path" ) {
		return path_defaults( data_rows );
	}
	// else trips
	return trips_defaults( data_rows );
}

// [[Rcpp::export]]
Rcpp::List rcpp_path_geojson(
		Rcpp::DataFrame data,  // sf object
		Rcpp::List params,
		SEXP unlist,
		int digits,
		std::string layer_name
	) {

	std::string sfc_column = data.attr("sf_column");

	Rcpp::StringVector unlist_cols;
	if( !Rf_isNull( unlist ) ) {
		unlist_cols = Rcpp::as< Rcpp::StringVector >( unlist );
	}

	Rcpp::List interleaved = sfheaders::interleave::interleave( data, unlist_cols );

	// these defaults need to be the length of the interleaved data, not hte original.
	//
	int data_rows = interleaved["n_coordinates"];
	Rcpp::List lst_defaults = get_path_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	std::string format = "rgb";

	Rcpp::DataFrame df = Rcpp::as< Rcpp::DataFrame >( interleaved["data"] );

	Rcpp::List lst = spatialwidget::api::format_data(
		df, params, lst_defaults, path_colours, path_legend, data_rows, parameter_exclusions, digits, format
	);

	// TODO: jsonify this list
	return Rcpp::List::create(
		Rcpp::_["coordinates"] = interleaved["coordinates"],
    Rcpp::_["start_indices"] = interleaved["start_indices"],
    Rcpp::_["stride"] = interleaved["stride"],
    Rcpp::_["data"] = lst["data"],
    Rcpp::_["legend"] = lst["legend"]
	);

}

// [[Rcpp::export]]
Rcpp::List rcpp_path_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		std::string layer_name
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_path_defaults( layer_name, data_rows );

	std::unordered_map< std::string, std::string > path_colours = mapdeck::layer_colours::stroke_colours;
	Rcpp::StringVector path_legend = mapdeck::layer_colours::stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		path_colours,
		path_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
