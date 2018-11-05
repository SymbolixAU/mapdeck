#include <Rcpp.h>

#include "mapdeck_defaults.hpp"
#include "layers/pointcloud.hpp"
#include "spatialwidget/spatialwidget.hpp"

Rcpp::List pointcloud_defaults(int n) {
	return Rcpp::List::create(
		//_["polyline"] = mapdeck::defaults::default_polyline(n),
		_["elevation"] = mapdeck::defaults::default_elevation(n),
		_["radius"] = mapdeck::defaults::default_radius(n),
		_["fill_colour"] = mapdeck::defaults::default_fill_colour(n)
	);
}


// [[Rcpp::export]]
Rcpp::List rcpp_pointcloud_geojson( Rcpp::DataFrame data, Rcpp::List data_types,
                            Rcpp::List params, Rcpp::StringVector geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = pointcloud_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > pointcloud_colours = mapdeck::pointcloud::pointcloud_colours;
	Rcpp::StringVector pointcloud_legend = mapdeck::pointcloud::pointcloud_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		pointcloud_colours,
		pointcloud_legend,
		data_rows,
		geometry_columns
	);
}

// [[Rcpp::export]]
Rcpp::List rcpp_pointcloud_geojson_df( Rcpp::DataFrame data, Rcpp::List data_types,
                                    Rcpp::List params, Rcpp::List geometry_columns ) {

	int data_rows = data.nrows();

	Rcpp::List lst_defaults = pointcloud_defaults( data_rows );  // initialise with defaults

	std::unordered_map< std::string, std::string > pointcloud_colours = mapdeck::pointcloud::pointcloud_colours;
	Rcpp::StringVector pointcloud_legend = mapdeck::pointcloud::pointcloud_legend;

	return spatialwidget::api::create_geojson(
		data,
		data_types,
		params,
		lst_defaults,
		pointcloud_colours,
		pointcloud_legend,
		data_rows,
		geometry_columns
	);
}
