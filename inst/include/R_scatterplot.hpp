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

  Rcpp::NumericVector scatterplot_param_column_index = Rcpp::NumericVector::create(
  	_["polyline"] = -1.0,
  	_["elevation"] = -1.0,
  	_["radius"] = -1.0,
  	_["fill_colour"] = -1.0,
  	_["fill_opacity"] = -1.0
  );

}



#endif
