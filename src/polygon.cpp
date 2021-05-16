#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"

#include "geometries/coordinates/dimensions.hpp"
#include "interleave/primitives/primitives.hpp"

Rcpp::List polygon_defaults(int n) {
	return Rcpp::List::create(
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n)
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_polygon_geojson(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		int digits
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = polygon_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > polygon_colours = mapdeck::layer_colours::fill_stroke_colours;
	Rcpp::StringVector polygon_legend = mapdeck::layer_colours::fill_stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		polygon_colours,
		polygon_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_interleave_primitive_triangle(
		Rcpp::DataFrame data,
		Rcpp::IntegerVector list_columns
	) {

	Rcpp::StringVector sf_names = data.names();
	Rcpp::String sfc_column = data.attr("sf_column");
	SEXP polygons = data[ sfc_column.get_cstring() ];

	// any list-columns must have the same number of elements as cordinates
	// as they go through interleaving and get shuffled as per the triangulation of coords

	Rcpp::List dim = geometries::coordinates::geometry_dimensions( polygons );
	Rcpp::IntegerMatrix dimensions = dim[ "dimensions" ];

	// For triangles, this won't work because we have made new coordinates because of ear-cutting
	// so we've added vertices.
	//
	// so, we need to interleave the coordinates and return the indices, then
	// we can expand the data based on those indicies
	// the do all the formatting

	//Rcpp::IntegerVector start_indices = dimensions( Rcpp::_, 0 );
	R_xlen_t n_geometries = dimensions.nrow();

	Rcpp::List tri_properties( list_columns.length() );
	for( R_xlen_t i = 0; i < list_columns.length(); ++i ) {
		R_xlen_t idx = list_columns[ i ];
		Rcpp::Rcout << "idx: " << idx << std::endl;
		Rcpp::Rcout << "data ncol: " << data.ncol() << std::endl;
		Rcpp::List list_col = Rcpp::as< Rcpp::List >( data[ idx ] );
		tri_properties[ i ] = list_col;
	}
	//return tri_properties;
	Rcpp::Rcout << "made properties" << std::endl;


	Rcpp::List tri = interleave::primitives::interleave_triangle( polygons, tri_properties );
	Rcpp::Rcout << "interleaved" << std::endl;

	//return tri;

	Rcpp::NumericVector coordinates = tri[ "coordinates" ];
	Rcpp::IntegerVector indices = tri["input_index"];
	Rcpp::IntegerVector geometry_coordinates = tri[ "geometry_coordinates" ];
	Rcpp::IntegerVector start_indices = tri["start_indices"];
	int stride = tri[ "stride" ];

	Rcpp::Rcout << "shuffling properties " << std::endl;

	// put the properties back onto 'data'
	Rcpp::List shuffled_properties = tri["properties"];
	//return shuffled_properties;
	for( R_xlen_t i = 0; i < list_columns.length(); ++i ) {
		R_xlen_t idx = list_columns[ i ];
		data[ idx ] = shuffled_properties[ i ];
	}

	Rcpp::Rcout << "shuffled properties" << std::endl;

	//return data;

	// IFF any columns of 'data' are lists, where each element is a vector the same length as
	// the number of coordinates in that sfg_POLYGON, then that vector needs to be subset
	// according to `indices`, which will correctly align the value to the coordinate
	//

	int total_coordinates = indices.length();

	//Rcpp::Rcout << "total_coords: " << total_coordinates << std::endl;
	//Rcpp::IntegerVector geometry_coordinates = tri["geometry_coordinates"];

	// non-extruded polygons use the start index as the start of each geometry,
	// and NOT each triangle.
	// Rcpp::IntegerVector start_indices( geometry_coordinates.length() );
	// start_indices[0] = 0;
	// for( R_xlen_t i = 1; i < geometry_coordinates.length(); ++i ) {
	// 	start_indices[ i ] = geometry_coordinates[ i - 1 ] + start_indices[ i - 1 ];
	// }

	Rcpp::List interleaved = Rcpp::List::create(
		Rcpp::_["data"] = data,  // TODO: remove the geometry column from data
		Rcpp::_["coordinates"] = coordinates,
		Rcpp::_["total_coordinates"] = total_coordinates,
		Rcpp::_["geometry_coordinates"] = geometry_coordinates,
		Rcpp::_["start_indices"] = start_indices,
		Rcpp::_["stride"] = stride
	);

	return interleaved;
}


// [[Rcpp::export]]
Rcpp::List rcpp_triangle_interleaved(
		Rcpp::DataFrame data,  // sf object
		Rcpp::List params,
		Rcpp::IntegerVector list_columns,
		int digits,
		std::string layer_name
) {

	Rcpp::List interleaved = rcpp_interleave_primitive_triangle(data, list_columns);

	//return interleaved;

	int total_coordinates = interleaved[ "total_coordinates" ];

	Rcpp::List lst_defaults = polygon_defaults( total_coordinates );  // initialise with defaults

	std::unordered_map< std::string, std::string > polygon_colours = mapdeck::layer_colours::fill_stroke_colours;
	Rcpp::StringVector polygon_legend = mapdeck::layer_colours::fill_stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	std::string format = "interleaved";
	Rcpp::StringVector binary_columns = mapdeck::binary_columns::get_binary_columns( layer_name );

	//return Rcpp::List::create();

	Rcpp::List lst = spatialwidget::api::create_interleaved(
		interleaved,
		params,
		lst_defaults,
		binary_columns,
		polygon_colours,
		polygon_legend,
		total_coordinates,
		parameter_exclusions,
		true, // jsonify legend
		digits,
		format
	);

	return lst;

}

// // [[Rcpp::export]]
// Rcpp::List rcpp_polygon_quadmesh( Rcpp::DataFrame data,
//                                   Rcpp::List params,
//                                   Rcpp::List geometry_columns) {
//
// 	int data_rows = data.nrow();
//
// 	Rcpp::List lst_defaults = polygon_defaults( data_rows );  // initialise with defaults
// 	std::unordered_map< std::string, std::string > polygon_colours = mapdeck::polygon::polygon_colours;
// 	Rcpp::StringVector polygon_legend = mapdeck::polygon::polygon_legend;
// 	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");
//
//
// 	return spatialwidget::api::create_geojson_quadmesh(
// 		data,
// 		params,
// 		lst_defaults,
// 		polygon_colours,
// 		polygon_legend,
// 		geometry_columns,
// 		data_rows,
// 		parameter_exclusions,
// 		true  // jsonify legend
// 		);
// }


// [[Rcpp::export]]
Rcpp::List rcpp_polygon_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns
	) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = polygon_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > polygon_colours = mapdeck::layer_colours::fill_stroke_colours;
	Rcpp::StringVector polygon_legend = mapdeck::layer_colours::fill_stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
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
}

