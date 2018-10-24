#ifndef R_MAPDECK_PARAMETERS_TO_DATA_H
#define R_MAPDECK_PARAMETERS_TO_DATA_H

#include <Rcpp.h>
#include "palette/palette.hpp"
#include "colour/colour.hpp"
#include "data_construction.hpp"
#include "legend/legend.hpp"

#include <Rcpp/Benchmark/Timer.h>

namespace mapdeck {

  /*
   * paramters to data
   */
  inline Rcpp::List parameters_to_data(
  		Rcpp::DataFrame& data,                // user-supplied data
  		Rcpp::List& params,                   // list of parameters from calling function
  		Rcpp::List& lst_defaults,
  		Rcpp::StringVector& layer_columns,
  		//Rcpp::StringVector& colour_columns,
  		std::map< std::string, std::string > colour_columns,
  		Rcpp::StringVector& legend_types,
  		int& data_rows) {

  	Rcpp::StringVector param_names = params.names();
  	Rcpp::StringVector data_names = data.names();

  	Rcpp::List lst_params = mapdeck::construct_params( data, params);

  	mapdeck::palette::resolve_palette( lst_params, params );

  	// determine if a legend is required
  	// if legend == T, for each of the possible legend types for htis plot (scatter, polygon)
  	// create a list. e.g.,
  	// lst_legend[ "fill_colour" ] = true;
  	// lst_legend[ "stroke_colour" ] = false;

  	// TODO(polygon can do fill & stroke. and the user may only supply one, but say 'legend = T')
  	// so we need to only use a legend IFF the user supplied it as a colour option

  	Rcpp::List lst_legend = construct_legend_list( lst_params, params, param_names, legend_types );

  	Rcpp::StringVector legend_names = lst_legend.names();
  	//Rcpp::Rcout << "legend_names: " <<  legend_names << std::endl;

  	//Rcpp::Rcout << "finished legend" << std::endl;
  	// lst_legend contains the 'true/false' values for the legends required (fill, stroke, stroke_to, stroke_from)
  	// for each of the 'trues', make another legend, the size of the TRUEs, and populate

  	// for each element in 'lst_legend', if the value is TRUE, resolve given the type of fill:
  	// int i = 0;
  	// int n = legend_names.size();
  	// std::map< std::string, std::string>::iterator it;
  	//
  	// for ( i = 0; i < n; i++ ) {
  	// 	const char* this_name = legend_names[i];
  	// 	bool include_legend = lst_legend[ this_name ];
  	//
  	// 	std::string opacity_column;
  	// 	for ( it = colour_columns.begin(); it != colour_columns.end(); ++it ) {
  	// 	  if ( it->first == this_name ) {
  	// 	    opacity_column = it->second;
  	// 	  }
  	// 	}
  	// 	resolve_colour( lst_params, params, data, lst_defaults, this_name, opacity_column.c_str(),  lst_legend, include_legend );
  	// }

  	// TODO
  	// regardless whether it's in the legend or not, the colours stil lneed sorting
  	int i = 0;
  	//int n = colour_columns.size();
  	std::map< std::string, std::string>::iterator it;

  	//for ( i = 0; i < n; i++ ) {
  		//const char* this_name = legend_names[i];
  		bool include_legend;

  		std::string colour_column;
  		std::string opacity_column;
  		for ( it = colour_columns.begin(); it != colour_columns.end(); ++it ) {

  			colour_column = it->first;
  			opacity_column = it->second;

  			// TODO( if 'colour_column' NOT IN lst_legend.names() ), include_legend == false
  			//include_legend = lst_legend[ colour_column ];
  			include_legend = mapdeck::find_character_index_in_vector(legend_names, colour_column) >= 0 ? true : false;
  			Rcpp::Rcout << "include legend: " << include_legend << std::endl;
  		  resolve_colour( lst_params, params, data, lst_defaults, colour_column.c_str(), opacity_column.c_str(),  lst_legend, include_legend );
  		}
  	//}

  	// legend optinos
  	// IT's a list
  	// iterate the names
  	//


  	// TODO( if stroke & fill colours are the same, don't 'colour values' twice );

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

  	// need to remove any paramters which won't be used in the data being plotted
  	Rcpp::StringVector legend_params = Rcpp::StringVector::create("legend","legend_options");
  	mapdeck::remove_parameters( params, param_names, legend_params );
  	Rcpp::StringVector colours_remove = Rcpp::StringVector::create("stroke_from","stroke_to","stroke_colour","fill_colour","stroke_from_opacity","stroke_to_opacity","stroke_opacity","fill_opacity","palette");
  	mapdeck::remove_parameters( params, param_names, colours_remove ); // TODO

  	lst_params = mapdeck::construct_params( data, params );

  	Rcpp::DataFrame df = mapdeck::construction::construct_data(
  		param_names,
  		layer_columns,
  		params,
  		data_names,
  		lst_defaults,
  		data,
  		data_rows
  	);

  	Rcpp::List result = Rcpp::List::create(
  		Rcpp::_["data"] = df,
  		Rcpp::_["legend"] = lst_legend
  	);

  	return result;
  }
} // namespace mapeck

#endif
