#ifndef R_MAPDECK_LAYERS_POINTCLOUD_H
#define R_MAPDECK_LAYERS_POINTCLOUD_H

#include <Rcpp.h>

namespace mapdeck {
namespace pointcloud {

	const std::unordered_map< std::string, std::string > pointcloud_colours = {
		{ "fill_colour", "fill_opacity" }
	};

	const Rcpp::StringVector pointcloud_legend = Rcpp::StringVector::create(
		"fill_colour"
	);

} // namespace pointcloud
} // namespace mapdeck


#endif
