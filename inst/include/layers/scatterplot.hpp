#ifndef R_SCATTERPLOT_H
#define R_SCATTERPLOT_H

#include <Rcpp.h>
using namespace Rcpp;


namespace mapdeck {
namespace scatterplot {

  /*
   * scatterplot_columns
   * other parameters (not colours or geometries) which can be included
   * on the data, and which were passed into the R function arguments.
   * These will be included in the JSON data sent to the mapdeck JS functions
   */
  Rcpp::StringVector scatterplot_columns = Rcpp::StringVector::create(
  	"polyline","elevation","radius","tooltip"
  	);

  Rcpp::StringVector scatterplot_colours = Rcpp::StringVector::create(
  	"fill_colour", "fill_opacity","palette"
  );

  Rcpp::StringVector scatterplot_legend = Rcpp::StringVector::create(
  	"fill_colour"
  );

} // namespace scatterplot
} // namespace mapdeck


#endif
