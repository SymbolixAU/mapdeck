#ifndef R_SCATTERPLOT_H
#define R_SCATTERPLOT_H

#include <Rcpp.h>
using namespace Rcpp;


namespace mapdeck {

  /*
   * scatterplot_columns
   * All the possible columns in the scatterplot data.frame object
   */
  Rcpp::StringVector scatterplot_columns = Rcpp::StringVector::create(
  	"polyline","elevation","radius","fill_colour","fill_opacity" // TODO(tooltip)?
  	);
}



#endif
