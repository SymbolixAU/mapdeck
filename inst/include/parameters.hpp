#ifndef R_MAPDECK_PARAMETERS_TO_DATA_H
#define R_MAPDECK_PARAMETERS_TO_DATA_H

#include <Rcpp.h>
#include "palette/palette.hpp"
#include "fill/fill.hpp"
#include "stroke/stroke.hpp"
#include "data_construction.hpp"
#include "legend/legend.hpp"

// #include <Rcpp/Benchmark/Timer.h>

namespace mapdeck {

  /*
   * paramters to data
   */
  inline Rcpp::List parameters_to_data(
  		Rcpp::DataFrame& data,                // user-supplied data
  		Rcpp::List& params,                   // list of parameters from calling function
  		Rcpp::List& lst_defaults,
  		Rcpp::StringVector& layer_columns,
  		Rcpp::StringVector& colour_columns,
  		Rcpp::StringVector& legend_types,
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
  	// lst_params contain
  	// - paramter names ("fill_colour", "lat", "lon")
  	// - parameter types (String, String, )
  	// - data column index

  	// timer.step("resolve_palette");
  	mapdeck::palette::resolve_palette( lst_params, params );

  	// determine if a legend is required
  	// if legend == T, for each of the possible legend types for htis plot (scatter, polygon)
  	// create a list. e.g.,
  	// lst_legend[ "fill_colour" ] = true;
  	// lst_legend[ "stroke_colour" ] = false;
  	Rcpp::List lst_legend = construct_legend_list( lst_params, params, param_names, legend_types );
  	//Rcpp::Rcout << "finished legend" << std::endl;
  	// lst_legend contains the 'true/false' values for the legends required (fill, stroke, stroke_to, stroke_from)
  	// for each of the 'trues', make another legend, the size of the TRUEs, and populate


  	// just creating a bit of JSON to view the result of the legend construction
  	// Rcpp::StringVector js = jsonify::vectors::to_json( legend );
  	// Rcpp::Rcout << "js: " << js << std::endl;

  	// TODO( if stroke & fill colours are the same, don't 'colour values' twice );

  	if ( resolve_fill ) {
  	  // timer.step("resolve_fill");
  	  mapdeck::fill::resolve_fill( lst_params, params, data, lst_defaults, fill_colour_location, fill_opacity_location, lst_legend );
  	}

  	//Rcpp::Rcout << "fill done" << std::endl;

  	if ( resolve_stroke ) {
  		// timer.step("resolve_stroke");
  		mapdeck::stroke::resolve_stroke( lst_params, params, data, lst_defaults, stroke_colour_location, stroke_opacity_location, lst_legend );
  	}

  	//Rcpp::Rcout << "stroke done " << std::endl;

  	// make legends (if required)
  	// logic:
  	// - check if any of the fill || stroke(s) require a legend. If so, include in the 'resolve_stroke / resolve_fill' funcitons
  	// - and return a summary (if numeric)
  	// - IF any( legend  == TRUE ) (because it can be legend( fill_colour = T, stroke_colour = F, stroke_from = T ) )
  	// -- for each of the TRUE legends, construct it, and sort out the options
  	// the colours are stored in... lst_params[ "fill_colour" ] / lst_params[ "stroke_colour" ]
  	//
  	// required:
  	// - legend values
  	//
  	// list(
  	//  colourType ("fill_colour", "stroke_colour", "stroke_from", "stroke_to")
  	//  type = ("gradient","category")
  	//  title = "title"
  	//  legend = data.frame( colour = "#", variable = x)
  	//  css = ""
  	//  position = NULL <<---- NOT USED IN MAPDECK
  	//)

  	// timer.step("remove_params");
  	// need to remove any paramters which won't be used in the data being plotted
  	Rcpp::StringVector legend_params = Rcpp::StringVector::create("legend","legend_options");
  	mapdeck::remove_parameters( params, param_names, legend_params );
  	mapdeck::remove_parameters( params, param_names, colour_columns );

  	//Rcpp::Rcout << "parameters moved" << std::endl;

  	// timer.step("construct_params 2");
  	lst_params = mapdeck::construct_params(
  		data, params, fill_colour_location, fill_opacity_location,
  		stroke_colour_location, stroke_opacity_location
  		);

  	//Rcpp::Rcout << "parameters reconstructed " << std::endl;

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

  	// TODO, convert legend to JSON
  	Rcpp::List result = Rcpp::List::create(
  		Rcpp::_["data"] = df,
  		Rcpp::_["legend"] = lst_legend
  	);

  	//Rcpp::Rcout << "dataframe constructed" << std::endl;

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

  	return result;
  }

} // namespace mapeck

#endif
