#ifndef R_MAPDECK_LAYERS_COLUMN_H
#define R_MAPDECK_LAYERS_COLUMN_H

#include <Rcpp.h>

namespace mapdeck {
namespace column {

const std::unordered_map< std::string, std::string > column_colours({
	{ "fill_colour", "fill_opacity" }
});

const Rcpp::StringVector column_legend = Rcpp::StringVector::create(
	"fill_colour"
);


} // namespace column
} // namespace mapdeck


#endif
