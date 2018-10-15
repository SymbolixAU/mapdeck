#ifndef R_MAPDECK_PARAMETERS_TO_DATA_H
#define R_MAPDECK_PARAMETERS_TO_DATA_H

#include <Rcpp.h>
#include "palette/palette.hpp"
#include "fill/fill.hpp"
#include "stroke/stroke.hpp"
#include "data_construction.hpp"

// #include <Rcpp/Benchmark/Timer.h>

namespace mapdeck {

  /*
   * paramters to data
   */
  inline Rcpp::DataFrame parameters_to_data(
  		Rcpp::DataFrame& data,
  		Rcpp::List& params,
  		Rcpp::List& lst_defaults,
  		Rcpp::StringVector& layer_columns,
  		Rcpp::StringVector& colour_columns,
  		int& data_rows,
  		bool resolve_fill,
  		bool resolve_stroke) {

  	int fill_colour_location = -1;
  	int fill_opacity_location = -1;
  	int stroke_colour_location = -1;
  	int stroke_opacity_location = -1;

  	// Rcpp::Timer timer;
  	// timer.step("start");

  	Rcpp::StringVector param_names = params.names();
  	Rcpp::StringVector data_names = data.names();

  	// timer.step("construct_params");
  	Rcpp::List lst_params = mapdeck::construct_params(
  		data, params,
  		fill_colour_location, fill_opacity_location,
  		stroke_colour_location, stroke_opacity_location
  		);

  	// timer.step("resolve_palette");
  	mapdeck::palette::resolve_palette( lst_params, params );

  	// TODO( if stroke & fill colours are the same, don't 'colour values' twice );

  	if ( resolve_fill ) {
  	  // timer.step("resolve_fill");
  	  mapdeck::fill::resolve_fill( lst_params, params, data, lst_defaults, fill_colour_location, fill_opacity_location );
  	}

  	if ( resolve_stroke ) {
  		// timer.step("resolve_stroke");
  		mapdeck::stroke::resolve_stroke( lst_params, params, data, lst_defaults, stroke_colour_location, stroke_opacity_location );
  	}

  	// timer.step("remove_params");
  	mapdeck::remove_parameters( params, param_names, colour_columns );

  	// timer.step("construct_params 2");
  	lst_params = mapdeck::construct_params(
  		data, params, fill_colour_location, fill_opacity_location,
  		stroke_colour_location, stroke_opacity_location
  		);

  	// timer.step("construct_data");
  	Rcpp::DataFrame df = mapdeck::construction::construct_data(
  		param_names,
  		layer_columns,
  		params,
  		data_names,
  		lst_defaults,
  		data,
  		data_rows
  	);

  	// Rcpp::NumericVector timeresult( timer );
  	// int n =  1000000;
  	// for( int i = 0; i < timeresult.size(); i++ ) {
  	// 	timeresult[i] = timeresult[i] / n;
  	// }
  	// Rcpp::Rcout << timeresult << std::endl;
  	//
  	// Rcpp::List timeres(1);
  	// timeres[0] = timeresult;
  	// return timeres;

  	return df;
  }

} // namespace mapeck

#endif
