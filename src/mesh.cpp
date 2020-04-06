#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List mesh_defaults(int n) {
	return Rcpp::List::create(
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
		//_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n)
	);
}

// [[Rcpp::export]]
Rcpp::List mesh_to_sf( Rcpp::List& mesh, Rcpp::StringVector vertices ) {
	// convert mesh3d object into a pseudo-sf.data.farme object
	// so it will go into all teh spatialwidget functions as-is

	Rcpp::String vertex_b = vertices[0];
	Rcpp::String vertex_i = vertices[1];
	Rcpp::NumericMatrix vb = mesh[ vertex_b ];
	Rcpp::NumericMatrix ib = mesh[ vertex_i ];

	// each column of each row of ib gives the row of vb containing coordinates which form the mesh
	// as we're working with polygons, we can turn the coordinates into list of matrices
	size_t n_row = ib.nrow();
	size_t n_col = ib.ncol();
	size_t n_coords = vb.nrow();

	Rcpp::List sfc( n_col );
	Rcpp::List z( n_col ); // for creating a list-column of the z attributes

	Rcpp::NumericVector avg_z( n_col );

	size_t i, j;

	Rcpp::NumericVector polygon_indeces( n_row );
	Rcpp::NumericVector polygon_coordinates( n_row );  // TODO always 4?

	for( i = 0; i < n_col; i++ ) {
		polygon_indeces = ib(_, i);
		Rcpp::NumericMatrix a_polygon( n_row, n_coords );
		Rcpp::List sfg(1);
		Rcpp::NumericVector z_values( n_row ); // each 'col' contains the index of the xyz1 coords

		for( j = 0; j < n_row; j++ ) {
			int this_index = polygon_indeces[j];
			this_index = this_index - 1;
			a_polygon(j, _) = vb(_, this_index);
			z_values[ j ] = a_polygon(j, 2);
		}
		avg_z[i] = Rcpp::mean( z_values );

		sfg[0] = a_polygon;
		sfg.attr("class") = Rcpp::CharacterVector::create("XYZM", "POLYGON", "sfg");
		sfc[i] = sfg;
		//z[i] = z_values;
	}


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

	Rcpp::List sf = Rcpp::List::create(
		_["geometry"] = sfc,
		//_["z"] = z
		_["average_z"] = avg_z
	);

	sf.attr("class") = Rcpp::CharacterVector::create("sf","data.frame");

	if ( n_col > 0 ) {
		Rcpp::IntegerVector nv = Rcpp::seq( 1, n_col );
		sf.attr("row.names") = nv;
	} else {
		sf.attr("row.names") = Rcpp::IntegerVector(0);
	}

	sf.attr("sf_column") = "geometry";
	return sf;
}

// [[Rcpp::export]]
Rcpp::List rcpp_mesh_geojson(
		Rcpp::List mesh,
		Rcpp::List params,
		Rcpp::StringVector vertices,
		int digits
	) {

	Rcpp::DataFrame data = mesh_to_sf( mesh, vertices );

	//return data;

	// can now create a data.frame of the vbt objc, and this new polygons list,
	// where polygons list is the sf_geometry column

	int data_rows = data.nrows();

	Rcpp::StringVector geometry_columns({"geometry"});

	Rcpp::List lst_defaults = mesh_defaults( data_rows );  // initialise with defaults
	std::unordered_map< std::string, std::string > mesh_colours = mapdeck::layer_colours::fill_colours;
	Rcpp::StringVector mesh_legend = mapdeck::layer_colours::fill_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		mesh_colours,
		mesh_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);

}


// [[Rcpp::export]]
Rcpp::StringVector rcpp_mesh_geojson2( Rcpp::List mesh, Rcpp::StringVector vertices ) {

	//Rcpp::DataFrame data = mesh_to_sf( mesh, vertices );

	//return data;

	// can now create a data.frame of the vbt objc, and this new polygons list,
	// where polygons list is the sf_geometry column

	// int data_rows = data.nrows();
	//
	// std::string geometry_columns = "geometry";
	//
	// Rcpp::List lst_defaults = mesh_defaults( data_rows );  // initialise with defaults
	// std::unordered_map< std::string, std::string > mesh_colours = mapdeck::mesh::mesh_colours;
	// Rcpp::StringVector mesh_legend = mapdeck::mesh::mesh_legend;
	// Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");
	//
	// return spatialwidget::api::create_geojson_downcast(
	// 	data,
	// 	params,
	// 	lst_defaults,
	// 	mesh_colours,
	// 	mesh_legend,
	// 	data_rows,
	// 	parameter_exclusions,
	// 	geometry_columns,
	// 	true,  // jsonify legend
	// 	digits
	// );

	return spatialwidget::api::create_geojson_mesh(
		mesh, vertices
	);

}
