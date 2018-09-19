#ifndef R_SCATTERPLOT_H
#define R_SCATTERPLOT_H

#include <Rcpp.h>
using namespace Rcpp;


namespace mapdeck {

  /*
   * scatterplot_attributes
   */
  Rcpp::StringVector scatterplot_columns = Rcpp::StringVector::create(
  	"polyline","elevation","radius"
  	);

  Rcpp::StringVector scatterplot_colours = Rcpp::StringVector::create(
  	"fill_colour", "fill_opacity"
  );

  // all the possible columns not needed in the default, including the extra ones which
  // can be passed to JS
  Rcpp::StringVector scatterplot_available_columns = Rcpp::StringVector::create(
  	"polyline","elevation","radius","fill_colour","tooltip"
  );

  Rcpp::NumericVector scatterplot_param_column_index = Rcpp::NumericVector::create(
  	_["polyline"] = -1.0,
  	_["elevation"] = -1.0,
  	_["radius"] = -1.0,
  	_["fill_colour"] = -1.0
  );

}



#endif
