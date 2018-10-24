#ifndef R_MAPDECK_LAYERS_POINTCLOUD_H
#define R_MAPDECK_LAYERS_POINTCLOUD_H

#include <Rcpp.h>

namespace mapdeck {
namespace pointcloud {

	Rcpp::StringVector pointcloud_columns = Rcpp::StringVector::create(
		"polyline","elevation","radius","tooltip"
	);

	// Rcpp::StringVector pointcloud_colours = Rcpp::StringVector::create(
	// 	"fill_colour", "fill_opacity","palette"
	// );

	std::map< std::string, std::string > pointcloud_colours = {
		{ "fill_colour", "fill_opacity" }
	};

	Rcpp::StringVector pointcloud_legend = Rcpp::StringVector::create(
		"fill_colour"
	);
} // namespace pointcloud
} // namespace mapdeck


#endif
