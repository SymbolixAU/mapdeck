
#include <Rcpp.h>
#include "geojsonsf/geojsonsf.h"


#include "geojsonsf/utils/utils.hpp"
#include "geojsonsf/writers/writers.hpp"
#include "geojsonsf/geometrycollection/geometrycollection.hpp"

#include "jsonify/jsonify.hpp"
#include "jsonify/to_json/dataframe.hpp"

template< typename Writer >
void write_geometry(Writer& writer, Rcpp::List& sfc, int i) {

	SEXP sfg = sfc[ i ];

	std::string geom_type;
	Rcpp::CharacterVector cls = geojsonsf::getSfClass(sfg);
	geom_type = cls[1];

	// need to keep track of GEOMETRYCOLLECTIONs so we can correctly close them
	bool isGeometryCollection = (geom_type == "GEOMETRYCOLLECTION") ? true : false;

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

			geom_type = (isGeometryCollection) ? "GEOMETRYCOLLECTION" : geom_type;
			geojsonsf::writers::end_geojson_geometry( writer, geom_type );
		}
	}
}

template< typename Writer >
void write_geojson(Writer& writer, SEXP sfg, std::string& geom_type, Rcpp::CharacterVector& cls ) {

	if (geom_type == "POINT") {
		geojsonsf::writers::points_to_geojson( writer, sfg );

	} else if (geom_type == "MULTIPOINT") {
		geojsonsf::writers::linestring_to_geojson( writer, sfg );

	} else if (geom_type == "LINESTRING") {
		geojsonsf::writers::linestring_to_geojson( writer, sfg );

	} else if (geom_type == "MULTILINESTRING") {
		Rcpp::List multiline = Rcpp::as< Rcpp::List >( sfg );
		geojsonsf::writers::polygon_to_geojson( writer, multiline );

	} else if (geom_type == "POLYGON") {
		Rcpp::List polygon = Rcpp::as< Rcpp::List >(sfg);
		geojsonsf::writers::polygon_to_geojson( writer, polygon );

	} else if (geom_type == "MULTIPOLYGON") {
		Rcpp::List multipolygon = Rcpp::as< Rcpp::List >( sfg );
		geojsonsf::writers::multi_polygon_to_geojson( writer, multipolygon );

	} else if (geom_type == "GEOMETRYCOLLECTION") {
		Rcpp::List gc = Rcpp::as< Rcpp::List >( sfg );
		Rcpp::List sfgi(1);
		for (int i = 0; i < gc.size(); i++) {
			sfgi[0] = gc[i];
			make_gc_type(writer, sfgi, geom_type, cls);
		}
	}
}

template< typename Writer >
void make_gc_type(Writer& writer, Rcpp::List& sfg,
                  std::string& geom_type, Rcpp::CharacterVector& cls) {

	bool isnull = false;

	for (Rcpp::List::iterator it = sfg.begin(); it != sfg.end(); it++) {

		switch( TYPEOF( *it ) ) {
		case VECSXP: {
			Rcpp::List tmp = Rcpp::as< Rcpp::List >(*it);
			if (!Rf_isNull(tmp.attr("class"))) {

				cls = tmp.attr("class");
				// TODO: error handle (there should aways be 3 elements as we're workgin wtih sfg objects)
				geom_type = cls[1];

				SEXP tst = *it;
				isnull = geojsonsf::utils::is_null_geometry( tst, geom_type );
				if ( isnull ) {
					//writer.Null();
				} else {
					geojsonsf::writers::begin_geojson_geometry(writer, geom_type);
					write_geojson(writer, tmp, geom_type, cls);
					geojsonsf::writers::end_geojson_geometry(writer, geom_type);
				}
			} else {
				make_gc_type(writer, tmp, geom_type, cls);
			}
			break;
		}
		case REALSXP: {
			Rcpp::NumericVector tmp = Rcpp::as< Rcpp::NumericVector >( *it );
			if (!Rf_isNull(tmp.attr("class"))) {

				cls = tmp.attr("class");
				geom_type = cls[1];

				SEXP tst = *it;
				isnull = geojsonsf::utils::is_null_geometry( tst, geom_type );
				if ( isnull ) {
					//writer.Null();
				} else {
					geojsonsf::writers::begin_geojson_geometry(writer, geom_type);
					write_geojson(writer, tmp, geom_type, cls);
					geojsonsf::writers::end_geojson_geometry(writer, geom_type);
				}
			}
			break;
		}
		default: {
			Rcpp::stop("Coordinates could not be found");
		}
		}
	}
}

/*
 * a variation on the atomise function to return an array of atomised features
 */
Rcpp::StringVector rcpp_sf_to_geojson_atomise( Rcpp::DataFrame& sf ) {

	//Rcpp::Rcout << "atomising" << std::endl;
	std::string geom_column = sf.attr("sf_column");
	// Rcpp::Rcout << "got the geom column " << std::endl;

	size_t n_cols = sf.ncol();
	size_t n_properties = n_cols - 1;
	size_t n_rows = sf.nrows();
	size_t i, j;
	Rcpp::StringVector column_names = sf.names();
	Rcpp::StringVector property_names(sf.size() - 1);

	//Rcpp::StringVector geojson( n_rows );

	int property_counter = 0;
	for (int i = 0; i < sf.length(); i++) {
		if (column_names[i] != geom_column) {
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

				SEXP this_vec = sf[ h ];

				jsonify::writers::write_value( writer, h );
				jsonify::dataframe::dataframe_cell( writer, this_vec, i );
			}

			writer.EndObject();
		}

		// now geometries
		if( n_properties > 0 ) {
			writer.String("geometry");
		}

		Rcpp::List sfc = sf[ geom_column ];
		write_geometry( writer, sfc, i );

		if( n_properties > 0 ) {
			writer.EndObject();
		}

		//geojson[i] = sb.GetString();
	}
	writer.EndArray();

	Rcpp::StringVector geojson = sb.GetString();
	geojson.attr("class") = Rcpp::CharacterVector::create("geojson","json");
	return geojson;
}

Rcpp::StringVector rcpp_sf_to_geojson( Rcpp::DataFrame& sf ) {
	rapidjson::StringBuffer sb;
	rapidjson::Writer < rapidjson::StringBuffer > writer( sb );

	std::string geom_column = sf.attr("sf_column");

	size_t n_cols = sf.ncol();
	size_t n_properties = n_cols - 1;
	size_t n_rows = sf.nrows();
	size_t i, j;
	Rcpp::StringVector column_names = sf.names();
	Rcpp::StringVector property_names(sf.size() - 1);

	int property_counter = 0;
	for (int i = 0; i < sf.length(); i++) {
		if (column_names[i] != geom_column) {
			property_names[property_counter] = column_names[i];
			property_counter++;
		}
	}

	writer.StartObject();
	geojsonsf::writers::start_feature_collection( writer );

	writer.StartArray();

	for( i = 0; i < n_rows; i++ ) {

		writer.StartObject();

		geojsonsf::writers::start_features( writer );
		geojsonsf::writers::start_properties( writer );
		writer.StartObject();

		for( j = 0; j < n_properties; j++ ) {
			const char *h = property_names[ j ];

			SEXP this_vec = sf[ h ];

			jsonify::writers::write_value( writer, h );
			jsonify::dataframe::dataframe_cell( writer, this_vec, i );
		}
		writer.EndObject();

		writer.String("geometry");
		Rcpp::List sfc = sf[ geom_column ];
		write_geometry( writer, sfc, i );

		writer.EndObject();
	}

	writer.EndArray();
	writer.EndObject();

	Rcpp::StringVector geojson = sb.GetString();
	geojson.attr("class") = Rcpp::CharacterVector::create("geojson","json");
	return geojson;
}
