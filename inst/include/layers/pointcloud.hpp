#ifndef R_POINTCLOUD_H
#define R_POINTCLOUD_H

#include <Rcpp.h>

namespace mapdeck {
namespace pointcloud {

	Rcpp::StringVector pointcloud_columns = Rcpp::StringVector::create(
		"polyline","elevation","radius","tooltip"
	);

	Rcpp::StringVector pointcloud_colours = Rcpp::StringVector::create(
		"fill_colour", "fill_opacity","palette"
	);
} // namespace pointcloud
} // namespace mapdeck


#endif
