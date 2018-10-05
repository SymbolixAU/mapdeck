#ifndef R_MAPDECK_H
#define R_MAPDECK_H

#include <Rcpp.h>

namespace mapdeck {

  /*
   * find_parameter_index
   * Finds the location (index) of a string in the list of parameters (as given by the R function call)
   */
  inline int find_character_index_in_vector( Rcpp::StringVector& sv, const char* to_find ) {
  	//Rcpp::StringVector parameter_names = lst_params[ "parameter" ];
  	int pos = std::distance(
  		sv.begin(),
  		std::find( sv.begin(), sv.end(), to_find )
  	);
  	if ( pos >= sv.size() ) {
  		return -1;
  	}
  	//Rcpp::Rcout << "pos: " << pos << std::endl;
  	return pos;
  }


	/*
	 * indexColumnName
	 * Finds the index of the names of the input data which match the function argument values
	 */
	inline int data_column_index(Rcpp::StringVector& param_value, Rcpp::StringVector& data_names) {

		int n = data_names.size();
		for (int i = 0; i < n; i++ ) {

			if ( param_value.length() != 1 ) {
				return -1;
			}

			if (param_value[0] == data_names[i] ) {
				return i;
			}
		}
		return -1;
	}

  inline Rcpp::List construct_df(Rcpp::List df, int nrows) {

  	if (nrows < 1) {
  		Rcpp::stop("Error creating data layer");
  	}

  	Rcpp::IntegerVector nv = Rcpp::seq(1, nrows);

  	df.attr("class") = "data.frame";
  	df.attr("row.names") = nv;

  	return df;
  }

	inline void remove_parameters(
			Rcpp::List& params,
			Rcpp::StringVector& param_names,
			Rcpp::StringVector& to_remove ) {
		param_names = Rcpp::setdiff( param_names,  to_remove );
		params = params[ param_names ];
	}

  inline bool param_is_string( SEXP param ) {
  	return TYPEOF( param ) == STRSXP;  // string vectors
  }

	/*
	 * determins the data type in the list of argument parameters (not the data)
	 */
	inline int get_parameter_r_type( SEXP param ) {\
		return TYPEOF( param );
	}

	inline void fill_single_vector( Rcpp::List& lst_defaults, Rcpp::String& param_name, SEXP& value, int n_rows ) {
		switch( TYPEOF( value ) ) {
		case 10: { // LGLSXP
		Rcpp::LogicalVector l = Rcpp::as< Rcpp::LogicalVector >( value );
		Rcpp::LogicalVector lv(n_rows, l[0]);
		lst_defaults[ param_name ] = lv;
		return;
	}
		case 13: { // INTSXP
			Rcpp::IntegerVector i = Rcpp::as< Rcpp::IntegerVector >( value );
			Rcpp::IntegerVector iv(n_rows, i[0]);
			lst_defaults[ param_name ] = iv;
			return;
		}
		case 14: { // REALSXP
			Rcpp::NumericVector n = Rcpp::as< Rcpp::NumericVector >( value );
			Rcpp::NumericVector nv(n_rows, n[0]);
			lst_defaults[ param_name ] = nv;
			return;
		}
		default: {
			Rcpp::StringVector s = Rcpp::as< Rcpp::StringVector >( value );
			Rcpp::StringVector sv(n_rows, s[0]);
			lst_defaults[ param_name ] = sv;
			return;
		}
		}
	}


	inline Rcpp::List construct_params(
			Rcpp::DataFrame& data,
			Rcpp::List& params,
			int& fill_colour_location,
			int& fill_opacity_location
	) {

		int n_params = params.size();
		Rcpp::StringVector param_names = params.names();
		Rcpp::IntegerVector parameter_r_types( n_params );
		Rcpp::IntegerVector data_column_index( n_params, -1 );
		Rcpp::StringVector data_names = data.names();

		int i = 0;
		int parameter_type;

		for (i = 0; i < n_params; i++) {
			parameter_type = mapdeck::get_parameter_r_type( params[i] );
			parameter_r_types[i] = parameter_type;

			if ( parameter_type == STRSXP ) { // STRSXP (string vector)

				Rcpp::StringVector param_value = params[i];
				data_column_index[i] = mapdeck::data_column_index( param_value, data_names );

				// these colour values are stored for convenience
				// do I also need 'stroke_colour' as well?
				// OR, should I just have a function to find a variable in the 'paramter_names' vector
				// - there shouldn't be much overhead doing that each time for each var?
				if ( param_names[i] == "fill_colour" ) {
					fill_colour_location = i;
				} else if ( param_names[i] == "fill_opacity" ) {
					fill_opacity_location = i;
				}
			}
		}
		return Rcpp::List::create(
			Rcpp::_["parameter"] = param_names,
			Rcpp::_["parameter_type"] = parameter_r_types,
			Rcpp::_["data_column_index"] = data_column_index
		);
	}

} // namespace mapdeck


#endif
