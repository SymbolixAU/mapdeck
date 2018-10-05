#ifndef R_MAPDECK_PARAMETERS_TO_DATA_H
#define R_MAPDECK_PARAMETERS_TO_DATA_H

#include <Rcpp.h>
#include "palette/palette.hpp"
#include "fill/fill.hpp"
#include "stroke/stroke.hpp"
#include "data_construction.hpp"

namespace mapdeck {

  /*
   * paramters to data FILL ONLY
   */
  inline Rcpp::DataFrame parameters_to_data(
  		Rcpp::DataFrame& data,
  		Rcpp::List& params,
  		Rcpp::List& lst_defaults,
  		Rcpp::StringVector& layer_columns,
  		Rcpp::StringVector& fill_colours,
  		int& data_rows,
  		bool resolve_fill,
  		bool resolve_stroke) {

  	int fill_colour_location = -1;
  	int fill_opacity_location = -1;
  	int stroke_colour_location = -1;
  	int stroke_opacity_location = -1;

  	Rcpp::StringVector param_names = params.names();
  	Rcpp::StringVector data_names = data.names();

  	Rcpp::List lst_params = mapdeck::construct_params(
  		data, params,
  		fill_colour_location, fill_opacity_location,
  		stroke_colour_location, stroke_opacity_location
  		);
  	mapdeck::palette::resolve_palette( lst_params, params );

  	if ( resolve_fill ) {
  	  mapdeck::fill::resolve_fill( lst_params, params, data, lst_defaults, fill_colour_location, fill_opacity_location );
  	}

  	if ( resolve_stroke ) {
  		mapdeck::stroke::resolve_stroke( lst_params, params, data, lst_defaults, stroke_colour_location, stroke_opacity_location );
  	}

  	mapdeck::remove_parameters( params, param_names, fill_colours );
  	lst_params = mapdeck::construct_params(
  		data, params, fill_colour_location, fill_opacity_location,
  		stroke_colour_location, stroke_opacity_location
  		);

  	Rcpp::DataFrame df = mapdeck::construction::construct_data(
  		param_names,
  		layer_columns,
  		params,
  		data_names,
  		lst_defaults,
  		data,
  		data_rows
  	);

  	return df;
  }

} // namespace mapeck

#endif
