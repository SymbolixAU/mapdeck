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
Rcpp::List rcpp_triangle_columnar(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		int digits
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = polygon_defaults( data_rows );  // initialise with defaults

	// TODO
	// call geometries:::rcpp_geometry_dimensions()
	// and the first column is the binaryStartIndices
	// which is the first 'row' where each matrix (ring) starts
	//
	// then 'binaryIndices' is a sequence 0:(n_coordinates-1)

	Rcpp::String poly_column = geometry_columns[0];
	SEXP poly = data[ poly_column.get_cstring() ];

	// remove teh poly column?
	// because it can't be used

	Rcpp::List dim = geometries::coordinates::geometry_dimensions( poly );
	Rcpp::IntegerMatrix dimensions = dim[ "dimensions" ];

	// For triangles, this won't work because we have made new coordinates because of ear-cutting
	// so we've added vertices.
	//
	// so, we need to interleave the coordinates and return the indices, then
	// we can expand the data based on those indicies
	// the do all the formatting

	//Rcpp::IntegerVector start_indices = dimensions( Rcpp::_, 0 );
	//R_xlen_t n_geometries = dimensions.nrow();
	//R_xlen_t total_coordinates = dimensions( n_geometries - 1, 1 );

	// TODO:
	// this is the 'repeats' vector

	Rcpp::List tri = interleave::primitives::interleave_triangle( poly );

	Rcpp::IntegerVector indices = tri["indices"];

	// IFF any columns of 'data' are lists, where each element is a vector the same length as
	// the number of coordinates in that sfg_POLYGON, then that vector needs to be subset
	// according to `indices`, which will correctly align the value to the coordinate
	//

	R_xlen_t total_coordinates = indices.length();
	Rcpp::IntegerVector n_coordinates( total_coordinates, 3 );


	std::unordered_map< std::string, std::string > polygon_colours = mapdeck::layer_colours::fill_stroke_colours;
	Rcpp::StringVector polygon_legend = mapdeck::layer_colours::fill_stroke_legend;
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");


	Rcpp::List interleaved = Rcpp::List::create(
		Rcpp::_["data"] = data,
		Rcpp::_["n_coordinates"] = n_coordinates,
		Rcpp::_["total_coordinates"] = total_coordinates
	);

	Rcpp::StringVector js_tri = jsonify::api::to_json(
		tri, false, digits,
		true, true, "column" // numeric_dates, factors_as_strin, by -- not used on interleaved data
	);

	Rcpp::List processed = spatialwidget::api::create_interleaved(
		interleaved,
		params,
		lst_defaults,
		polygon_colours,
		polygon_legend,
		data_rows,
		parameter_exclusions,
		true, // jsonify legend
		digits,
		"interleaved"
	);

	Rcpp::List res = Rcpp::List::create(
		Rcpp::_["interleaved"] = js_tri,
		Rcpp::_["data"] = processed
	);

	return res;

	// Rcpp::List formatted_data = spatialwidget::api::format_data(
	// 		data,
	// 		params,
	// 		lst_defaults,
	// 		polygon_colours,
	// 		polygon_legend,
	// 		data_rows,
	// 		parameter_exclusions,
	// 		digits,
	// 		"interleaved"
	// );
	//
	// return formatted_data;

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

