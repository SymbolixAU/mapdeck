#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/mesh.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List mesh_defaults(int n) {
	return Rcpp::List::create(
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n)
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_mesh_geojson( Rcpp::List mesh ) {

	// TODO
	// convert mesh3d object into a pseudo-sf.data.farme object
	// so it will go into all teh spatialwidget functions as-is
	Rcpp::NumericMatrix vb = mesh["vb"];
	Rcpp::NumericMatrix ib = mesh["ib"];

	Rcpp::NumericMatrix vbt = transpose( vb );
	Rcpp::NumericMatrix ibt = transpose( ib );

	// each column of each row of ib gives the row of vb containing coordinates which form the mesh
	// as we're working with polygons, we can turn the coordinates into list of matrices
	size_t n_row = ibt.nrow();
	size_t n_col = ibt.ncol();

	Rcpp::List sfc( n_row );
	Rcpp::List z( n_row ); // for creating a list-column of the z attributes

	size_t i, j;

	Rcpp::NumericVector polygon_indeces( n_col );
	Rcpp::NumericVector polygon_coordinates( 4 );  // TODO always 4?

	for( i = 0; i < n_row; i++ ) {
		polygon_indeces = ibt(i, _);
		Rcpp::NumericMatrix a_polygon( n_col, 4 ); // the number of cols of ib teslls us the number of sets of coordinates
		Rcpp::List sfg(1);
		Rcpp::NumericVector z_values( n_col ); // each 'col' contains the index of the xyz1 coords

		for( j = 0; j < n_col; j++ ) {
			int this_index = polygon_indeces[j];
			this_index = this_index - 1;
			a_polygon(j, _) = vbt(this_index, _);
			z_values[ j ] = a_polygon(j, 2);
		}

		sfg[0] = a_polygon;
		sfg.attr("class") = Rcpp::CharacterVector::create("XYZM", "POLYGON", "sfg");
		sfc[i] = sfg;
		//Rcpp::Rcout << "z_values : " << z_values << std::endl;
		z[i] = z_values;
	}

	//return z;

	sfc.attr("class") = Rcpp::CharacterVector::create("sfc_POLYGON", "sfc");

	// TODO (for testing - can remove all these attributes once I know an sf object is correctly made)
	Rcpp::List crs = Rcpp::List::create(
		Rcpp::Named("epsg") = NA_REAL,
		Rcpp::Named("proj4string") = ""
	);

	crs.attr("class") = Rcpp::CharacterVector::create("crs");
	sfc.attr("crs") = crs;

	sfc.attr("precision") = 0;

	Rcpp::NumericVector bbox = Rcpp::NumericVector::create(0,0,0,0);
	bbox.attr("class") = Rcpp::CharacterVector::create("bbox");
	bbox.attr("names") = Rcpp::CharacterVector::create("xmin", "ymin", "xmax", "ymax");

	sfc.attr("bbox") = bbox;
	// polygons should now be similar in shape to `sfc` objects
	//return sfc;

	Rcpp::List z_column(1);
	z_column[0] = z;
	z_column.attr("class") = "AsIs";

	Rcpp::DataFrame sf = Rcpp::DataFrame::create(
		_["geometry"] = sfc
		//_["z"] = z_column
	);

	sf.attr("class") = Rcpp::CharacterVector::create("sf","data.frame");
	sf.attr("sf_column") = "geometry";
	return sf;

	// can now create a data.frame of the vbt objc, and this new polygons list,
	// where polygons list is the sf_geometry column



	//int data_rows = data.nrows();

	//Rcpp::List lst_defaults = polygon_defaults( data_rows );  // initialise with defaults
	//std::unordered_map< std::string, std::string > polygon_colours = mapdeck::polygon::polygon_colours;
	//Rcpp::StringVector polygon_legend = mapdeck::polygon::polygon_legend;
	//Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	//return spatialwidget::geojson::to_geojson_mesh( data );

	/*
	return spatialwidget::api::create_geojson_downcast(
		data,
		params,
		lst_defaults,
		polygon_colours,
		polygon_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
	 */
}
