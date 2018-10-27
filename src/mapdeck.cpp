#include <Rcpp.h>
#include "mapdeck.hpp"
#include "parameters.hpp"

#include "sf_geojson.hpp"

Rcpp::List create_data(
		Rcpp::DataFrame& data,
		Rcpp::List& params, Rcpp::List& lst_defaults,
		Rcpp::StringVector& layer_columns,
		std::map< std::string, std::string >& layer_colours,
		Rcpp::StringVector& layer_legend,
		int& data_rows) {

	std::string jsfunction = params["jsfunction"];
	std::string geoconversion = params["geoconversion"];

	Rcpp::List lst = mapdeck::parameters_to_data(
		data, params, lst_defaults, layer_columns, layer_colours, layer_legend, data_rows
	);

	Rcpp::DataFrame df = Rcpp::as< Rcpp::DataFrame >( lst["data"] );
	SEXP legend = lst[ "legend" ];
	Rcpp::StringVector js_legend = jsonify::vectors::to_json( legend );

	if ( jsfunction == "geojson" ) {

		// TODO( if POINT data.frame, use rcpp_df_to_geojson_atomise )

		if ( geoconversion == "sf" ) {
			df.attr("sf_column") = "polyline";
			Rcpp::StringVector js_data = rcpp_sf_to_geojson_atomise( df );

			return Rcpp::List::create(
				Rcpp::_["data"] = js_data,
				Rcpp::_["legend"] = js_legend
			);
		} else if ( geoconversion == "dataframe" ) {

			const char* lon = params["lon"];
			const char* lat = params["lat"];
			Rcpp::StringVector js_data = rcpp_df_to_geojson_atomise( df, lon, lat );

			return Rcpp::List::create(
				Rcpp::_["data"] = js_data,
				Rcpp::_["legend"] = js_legend
			);
		}

	} else if ( jsfunction == "decode" ) {
		Rcpp::StringVector js_data = jsonify::dataframe::to_json( df );

		return Rcpp::List::create(
			Rcpp::_["data"] = js_data,
			Rcpp::_["legend"] = js_legend
		);
	} else {
		Rcpp::stop("not yet supported");
	}

	Rcpp::List resultlist;
	return resultlist; // never reached
}
