
#include <Rcpp.h>
#include "geojsonsf/geojsonsf.h"

#include "geojsonsf/utils/utils.hpp"
#include "geojsonsf/writers/writers.hpp"
#include "geojsonsf/geometrycollection/geometrycollection.hpp"

#include "jsonify/jsonify.hpp"
#include "jsonify/to_json/dataframe.hpp"


template< typename Writer >
void write_geometry(Writer& writer, SEXP sfg, Rcpp::CharacterVector& cls ) {

	std::string geom_type;
	geom_type = cls[1];

	int sfglength = geojsonsf::utils::get_sexp_length( sfg );

	if (sfglength == 0) {
		writer.Null();
	} else {

		bool isnull = geojsonsf::utils::is_null_geometry( sfg, geom_type );
		if ( isnull ) {
			writer.Null();
		} else {
			geojsonsf::writers::begin_geojson_geometry(writer, geom_type);
			write_geojson(writer, sfg, geom_type, cls );
			geojsonsf::writers::end_geojson_geometry( writer, geom_type );
		}
	}
}

template< typename Writer >
void write_geojson(Writer& writer, SEXP sfg, std::string& geom_type, Rcpp::CharacterVector& cls ) {

	if (geom_type == "POINT") {
		geojsonsf::writers::points_to_geojson( writer, sfg );
	} else {
		Rcpp::stop("df unknown geometry");
	}
}

// [[Rcpp::export]]
Rcpp::StringVector rcpp_df_to_geojson_atomise( Rcpp::DataFrame& df, const char* lon, const char* lat ) {

	size_t n_cols = df.ncol();
	size_t n_properties = n_cols - 2; // LON & LAT columns
	size_t n_rows = df.nrows();
	size_t i, j;
	Rcpp::StringVector column_names = df.names();
	Rcpp::StringVector property_names(df.size() - 1);

	// the sfc_POINT
	Rcpp::NumericVector nv_lon = df[lon];
	Rcpp::NumericVector nv_lat = df[lat];

	Rcpp::CharacterVector cls = Rcpp::CharacterVector::create("XY", "POINT", "sfg");

	int property_counter = 0;
	for (int i = 0; i < df.length(); i++) {
		if ( column_names[i] != lon && column_names[i] != lat ) {
			property_names[property_counter] = column_names[i];
			property_counter++;
		}
	}

	rapidjson::StringBuffer sb;
	rapidjson::Writer < rapidjson::StringBuffer > writer( sb );
	writer.StartArray();


	for( i = 0; i < n_rows; i++ ) {

		if ( n_properties > 0 ) {

			writer.StartObject();
			geojsonsf::writers::start_features( writer );
			geojsonsf::writers::start_properties( writer );

			writer.StartObject();

			// properties first, then sfc
			for( j = 0; j < n_properties; j++ ) {
				const char *h = property_names[ j ];

				SEXP this_vec = df[ h ];

				jsonify::writers::write_value( writer, h );
				jsonify::dataframe::dataframe_cell( writer, this_vec, i );
			}
			writer.EndObject();
		}

		// now geometries
		if( n_properties > 0 ) {
			writer.String("geometry");
		}

		SEXP sfg = Rcpp::NumericVector::create(nv_lon[i], nv_lat[i]);
		write_geometry( writer, sfg, cls );

		if( n_properties > 0 ) {
			writer.EndObject();
		}
	}
	writer.EndArray();

	Rcpp::StringVector geojson = sb.GetString();
	geojson.attr("class") = Rcpp::CharacterVector::create("geojson","json");
	return geojson;
}

// // [[Rcpp::export]]
// Rcpp::StringVector rcpp_df_to_geojson( Rcpp::DataFrame& sf, const char* lon, const char* lat ) {
// 	rapidjson::StringBuffer sb;
// 	rapidjson::Writer < rapidjson::StringBuffer > writer( sb );
//
// 	//std::string geom_column = sf.attr("sf_column");
//
// 	size_t n_cols = sf.ncol();
// 	size_t n_properties = n_cols - 2;  // LON & LAT columns
// 	size_t n_rows = sf.nrows();
// 	size_t i, j;
// 	Rcpp::StringVector column_names = sf.names();
// 	Rcpp::StringVector property_names(sf.size() - 1);
//
// 	// the sfc_POINT
// 	Rcpp::NumericVector nv_lon = sf[lon];
// 	Rcpp::NumericVector nv_lat = sf[lat];
//
// 	Rcpp::CharacterVector cls = Rcpp::CharacterVector::create("XY", "POINT", "sfg");
//
// 	int property_counter = 0;
//
// 	for ( int i = 0; i < sf.length(); i++ ) {
// 		if ( column_names[i] != lon && column_names[i] != lat ) {
// 			property_names[property_counter] = column_names[i];
// 			property_counter++;
// 		}
// 	}
//
// 	writer.StartObject();
// 	geojsonsf::writers::start_feature_collection( writer );
//
// 	writer.StartArray();
//
// 	for( i = 0; i < n_rows; i++ ) {
//
// 		writer.StartObject();
//
// 		geojsonsf::writers::start_features( writer );
// 		geojsonsf::writers::start_properties( writer );
// 		writer.StartObject();
// 		// properties first, then sfc
//
// 		for( j = 0; j < n_properties; j++ ) {
// 			const char *h = property_names[ j ];
// 			SEXP this_vec = sf[ h ];
//
// 			jsonify::writers::write_value( writer, h );
// 			jsonify::dataframe::dataframe_cell( writer, this_vec, i );
// 		}
// 		writer.EndObject();
//
// 		writer.String("geometry");
//
// 		SEXP sfg = Rcpp::NumericVector::create(nv_lon[i], nv_lat[i]);
// 		write_geometry( writer, sfg, cls );
//
// 		writer.EndObject();
// 	}
//
// 	writer.EndArray();
// 	writer.EndObject();
//
// 	Rcpp::StringVector geojson = sb.GetString();
// 	geojson.attr("class") = Rcpp::CharacterVector::create("geojson","json");
// 	return geojson;
// }
