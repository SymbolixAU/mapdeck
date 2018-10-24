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

  	Rcpp::List lst_legend = construct_legend_list( lst_params, params, param_names, legend_types );

  	Rcpp::StringVector legend_names = lst_legend.names();
  	//Rcpp::Rcout << "legend_names: " <<  legend_names << std::endl;

  	std::map< std::string, std::string>::iterator it;

		bool include_legend;

		std::string colour_column;
		std::string opacity_column;
		for ( it = colour_columns.begin(); it != colour_columns.end(); ++it ) {

		  colour_column = it->first;
		  opacity_column = it->second;
		  include_legend = mapdeck::find_character_index_in_vector(legend_names, colour_column.c_str()) >= 0 ? true : false;
	    resolve_colour( lst_params, params, data, lst_defaults, colour_column.c_str(), opacity_column.c_str(),  lst_legend, include_legend );
		}


  	// legend optinos
  	// IT's a list
  	// iterate the names

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
