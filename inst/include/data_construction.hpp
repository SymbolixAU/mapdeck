#ifndef R_MAPDECK_DATA_CONSTRUCTION_H
#define R_MAPDECK_DATA_CONSTRUCTION_H

#include <Rcpp.h>
#include "R_mapdeck.hpp"

namespace mapdeck {
namespace construction {

  inline Rcpp::DataFrame construct_data(
  		Rcpp::StringVector& param_names,
  		Rcpp::StringVector& required_columns,
  		Rcpp::List& params,
  		Rcpp::StringVector& data_names,
  		Rcpp::List& lst_defaults,
  		Rcpp::DataFrame& data,
  		int& data_rows) {

  	int n = params.size();
  	int colIndex = -1;

  	// iterate each of the parameters
  	for (int i = 0; i < n; i ++ ) {
  		// if the param element is length 1; check if it's a column name

  		Rcpp::String this_param = param_names[i];
  		//Rcpp::Rcout << "this_param: " << this_param.get_cstring() << std::endl;
  		int idx = mapdeck::find_character_index_in_vector( required_columns, this_param.get_cstring() );
  		//Rcpp::Rcout << "index of this param: " << idx << std::endl;

  		if ( idx >= 0 ) {
  			// to get into this if statement the parameter passed into the R function is
  			// to be used as a column of data

  			if( mapdeck::param_is_string( params[i] ) ) {
  				// it's a string
  				// is it also a column name

  				Rcpp::StringVector param_value = params[i];

  				// returns -1 if length != 1
  				colIndex = mapdeck::data_column_index( param_value, data_names );

  				if ( colIndex >= 0 ) {
  					// The param_value IS a column name
  					lst_defaults[ this_param ] = data[ colIndex ];

  				} else {
  					// IT's not a column name, but it is still a string
  					// and needs to be applied to all rows
  					SEXP value = param_value[0];
  					mapdeck::fill_single_vector( lst_defaults, this_param, value, data_rows );

  				}
  			} else {
  				// paramter is not a string, so it can't be a column name
  				SEXP value = params[i];
  				mapdeck::fill_single_vector( lst_defaults, this_param, value, data_rows );
  			}
  		}
  	}

  	Rcpp::DataFrame df = mapdeck::construct_df( lst_defaults, data_rows );
  	return df;
  }

} // namespace construction
} // namespace mapdeck



#endif
