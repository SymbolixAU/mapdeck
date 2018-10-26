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

	std::string jsfunction = params["jsfunction"];
	Rcpp::Rcout << "cppjsfunction - " << jsfunction << std::endl;

	Rcpp::List lst = mapdeck::parameters_to_data(
		data, params, lst_defaults, path_columns, path_colours, path_legend, data_rows
	);

	Rcpp::Rcout << "now making data frame" << std::endl;

	Rcpp::DataFrame df = Rcpp::as< Rcpp::DataFrame >( lst["data"] );
	SEXP legend = lst[ "legend" ];
  Rcpp::StringVector js_legend = jsonify::vectors::to_json( legend );

  if ( jsfunction == "geojson" ) {
	  df.attr("sf_column") = "polyline";
	  Rcpp::StringVector js_data = rcpp_sf_to_geojson_atomise( df );

	  return Rcpp::List::create(
	  	Rcpp::_["data"] = js_data,
	  	Rcpp::_["legend"] = js_legend
	  );

  } else {
  	Rcpp::StringVector js_data = jsonify::dataframe::to_json( df );

  	return Rcpp::List::create(
  		Rcpp::_["data"] = js_data,
  		Rcpp::_["legend"] = js_legend
  	);

  }

	Rcpp::List resultlist;
  return resultlist; // never reached
}
