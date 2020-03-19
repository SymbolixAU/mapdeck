#include <Rcpp.h>
#include "mapdeck_defaults.hpp"
#include "layers/layer_colours.hpp"
#include "spatialwidget/spatialwidget.hpp"
#include "sfheaders/df/sf.hpp"


Rcpp::List column_defaults(int n) {
	Rcpp::NumericVector nv = Rcpp::NumericVector(n);  // initalised to 0

	return Rcpp::List::create(
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_width"] = nv
	);
}

Rcpp::List scatterplot_defaults(int n) {

	Rcpp::NumericVector nv = Rcpp::NumericVector(n);  // initalised to 0

	return Rcpp::List::create(
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n),
		_["stroke_colour"] = mapdeck::defaults::default_stroke_colour(n),
		_["stroke_width"] = nv,
		_["radius"] = mapdeck::defaults::default_radius(n)
	);
}

Rcpp::List pointcloud_defaults(int n) {
	return Rcpp::List::create(
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
}

Rcpp::List grid_defaults(int n) {
	return Rcpp::List::create();
}


Rcpp::List get_point_defaults( std::string layer_name, int data_rows ) {
	if( layer_name == "column" ) {
		return column_defaults( data_rows );
	} else if ( layer_name == "scatterplot" ) {
		return scatterplot_defaults( data_rows );
	} else if (layer_name == "grid" ) {
		return grid_defaults( data_rows );
	}
	return pointcloud_defaults( data_rows );
}


Rcpp::StringVector get_point_legend_colours( std::string layer_name ) {

	Rcpp::StringVector point_legend;

	if( layer_name == "column" || layer_name == "scatterplot" ) {
		point_legend = mapdeck::layer_colours::fill_stroke_legend;
	} else if ( layer_name == "pointcloud" ) {
		point_legend = mapdeck::layer_colours::fill_legend;
	} else if ( layer_name == "grid" ) {
		point_legend = mapdeck::layer_colours::no_legend;
	}
	return point_legend;
}

std::unordered_map< std::string, std::string > get_point_colours( std::string layer_name ) {

	std::unordered_map< std::string, std::string > point_colours;

	if( layer_name == "column" || layer_name == "scatterplot" ) {
		point_colours = mapdeck::layer_colours::fill_stroke_colours;
	} else if ( layer_name == "pointcloud" ) {
		point_colours = mapdeck::layer_colours::fill_colours;
	} else if ( layer_name == "grid" ) {
		point_colours = mapdeck::layer_colours::no_colours;
	}
	return point_colours;
}

// [[Rcpp::export]]
Rcpp::List rcpp_point_df_columnar(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::List geometry_columns,
		int digits,
		std::string layer_name
) {

	int data_rows = data.nrows();


	Rcpp::List lst_defaults = get_point_defaults( layer_name, data_rows );

	Rcpp::StringVector point_legend = get_point_legend_colours( layer_name );
	std::unordered_map< std::string, std::string > point_colours = get_point_colours( layer_name );
	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	std::string format = "rgb";

	return spatialwidget::api::create_columnar(
		data,
		params,
		lst_defaults,
		point_colours,
		point_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits,
		format
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_point_sf_columnar(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::List geometry_columns,  // passed in from R; the geometry columns used by the plotting layer (e.g., scatter = x,y, pointcloud = x,y,z)
		int digits,
		std::string layer_name
	){

	Rcpp::DataFrame df = sfheaders::df::sf_to_df( data, true );
	Rcpp::StringVector geometry_cols = df.attr("sfc_columns");  // will be x, y, (z), (m)

	// can't directly use `geometry_cols[0]; because it's a CHARSXP,
	// but in spatialwidget it looks for STRSXP
	// TODO:
	// this needs to loop over the geometry_cols, because there may be elevation and time as well, right?

	int n_cols = geometry_cols.length();
	int i;
	Rcpp::StringVector param_names({"lon","lat","elevation","time"});  // need to match those incoming from R

	for( i = 0; i < n_cols; ++i ) {
		Rcpp::String this_geom = geometry_cols[i];
		Rcpp::String this_param = param_names[i];
		params[ this_param ] = this_geom;
	}

	return rcpp_point_df_columnar(df, params, geometry_columns, digits, layer_name );
}


// // [[Rcpp::export]]
// Rcpp::List rcpp_point_geojson(
// 		Rcpp::DataFrame data,
// 		Rcpp::List params,
// 		std::string geometry_columns,
// 		int digits,
// 		std::string layer_name
// ) {
//
// 	int data_rows = data.nrows();
//
// 	Rcpp::List lst_defaults = get_point_defaults( layer_name, data_rows );
//
// 	Rcpp::StringVector point_legend = get_point_legend_colours( layer_name );
// 	std::unordered_map< std::string, std::string > point_colours = get_point_colours( layer_name );
//
// 	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");
//
// 	return spatialwidget::api::create_geojson(
// 		data,
// 		params,
// 		lst_defaults,
// 		point_colours,
// 		point_legend,
// 		data_rows,
// 		parameter_exclusions,
// 		geometry_columns,
// 		true,  // jsonify legend
// 		digits
// 	);
// }

// [[Rcpp::export]]
Rcpp::List rcpp_point_geojson_df(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::List geometry_columns,
		int digits,
		std::string layer_name
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_point_defaults( layer_name, data_rows );

	Rcpp::StringVector point_legend = get_point_legend_colours( layer_name );
	std::unordered_map< std::string, std::string > point_colours = get_point_colours( layer_name );

	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	bool elevation = layer_name == "pointcloud" ? true : false;


	if( elevation ) {
		return spatialwidget::api::create_geojson(
			data,
			params,
			lst_defaults,
			point_colours,
			point_legend,
			data_rows,
			parameter_exclusions,
			geometry_columns,
			true,  // jsonify legend
			true,  // elevation
			digits
		);
	}

	return spatialwidget::api::create_geojson(
		data,
		params,
		lst_defaults,
		point_colours,
		point_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true,  // jsonify legend
		digits
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_point_polyline(
		Rcpp::DataFrame data,
		Rcpp::List params,
		Rcpp::StringVector geometry_columns,
		std::string layer_name
) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = get_point_defaults( layer_name, data_rows );

	Rcpp::StringVector point_legend = get_point_legend_colours( layer_name );
	std::unordered_map< std::string, std::string > point_colours = get_point_colours( layer_name );

	Rcpp::StringVector parameter_exclusions = Rcpp::StringVector::create("legend","legend_options","palette","na_colour");

	return spatialwidget::api::create_polyline(
		data,
		params,
		lst_defaults,
		point_colours,
		point_legend,
		data_rows,
		parameter_exclusions,
		geometry_columns,
		true  // jsonify legend
	);
}
