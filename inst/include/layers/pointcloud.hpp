#ifndef R_POINTCLOUD_H
#define R_POINTCLOUD_H

#include <Rcpp.h>
using namespace Rcpp;


namespace mapdeck {
namespace pointcloud {

	/*
	 * scatterplot_columns
	 * other parameters (not colours or geometries) which can be included
	 * on the data, and which were passed into the R function arguments.
	 * These will be included in the JSON data sent to the mapdeck JS functions
	 */
	Rcpp::StringVector pointcloud_columns = Rcpp::StringVector::create(
		"polyline","elevation","radius","tooltip"
	);

	Rcpp::StringVector pointcloud_colours = Rcpp::StringVector::create(
		"fill_colour", "fill_opacity","palette"
	);
} // namespace scatterplot
} // namespace mapdeck


#endif
