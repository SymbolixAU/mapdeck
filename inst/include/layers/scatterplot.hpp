#ifndef R_MAPDECK_LAYERS_SCATTERPLOT_H
#define R_MAPDECK_LAYERS_SCATTERPLOT_H

#include <Rcpp.h>

namespace mapdeck {
namespace scatterplot {

  const std::unordered_map< std::string, std::string > scatterplot_colours = {
  	{ "fill_colour", "fill_opacity" }
  };

  const Rcpp::StringVector scatterplot_legend = Rcpp::StringVector::create(
  	"fill_colour"
  );

} // namespace scatterplot
} // namespace mapdeck


#endif
