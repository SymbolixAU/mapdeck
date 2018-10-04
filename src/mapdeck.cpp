#include <Rcpp.h>
#include "R_mapdeck.hpp"
using namespace Rcpp;


/*
 * indexColumnName
 * Finds the index of the names of the input data which match the function argument values
 */
int indexColumnName(Rcpp::StringVector& param_value, Rcpp::StringVector& data_names) {

	//Rcpp::Rcout << "finding: " << param_value << std::endl;
	//Rcpp::Rcout << "in: " << data_names << std::endl;

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


