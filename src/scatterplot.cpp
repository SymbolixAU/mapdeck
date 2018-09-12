#include <Rcpp.h>
#include "R_mapdeck.hpp"
#include "R_scatterplot.hpp"
#include "googlePolylines.h"  // TODO(use 'rcpp_encodeSfGeometry()' directly)

// [[Rcpp::depends(RcppViridis)]]
#include "RcppViridis/colours/colours_hex.hpp"

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::StringVector viridis_test(Rcpp::NumericVector x) {
	Rcpp::NumericVector alpha(1);
	alpha[0] = 255;
	std::string palette = "viridis";
	std::string na_colour = "#808080FF";
  return rcppviridis::colours_hex::colour_value_hex( x, palette, na_colour, alpha );
//	return rcppviridis::colours::colour_value_hex(x, "viridis", "#808080");
}

// TODO
// 1. define which columns are to be in the final data.frame object
// 2. which of 'params' are column names
// - of column name
//

Rcpp::List scatterplot_defaults(int n) {

	// TODO(initialise with defaults, OR, test if column of data exists and
	// initialise with that instead? )

	// e.g.
	// _["polyline"] = param[i] %in% data_names ? data["polyline"] : default_polyline(n);

	return Rcpp::List::create(
		_["polyline"] = default_polyline(n),
		_["elevation"] = default_elevation(n),
		_["radius"] = default_radius(n),
		_["fill_colour"] = default_fill_colour(n),
		_["fill_opacity"] = default_fill_opacity(n)
	);
}

// [[Rcpp::export]]
Rcpp::StringVector test_palette(int data_rows, Function f) {
	Rcpp::StringVector sv = f(data_rows);
	return sv;
}


// [[Rcpp::export]]
Rcpp::List rcpp_scatterplot(Rcpp::DataFrame data, Rcpp::List params) {

	/*
	if ( indexColumnName( "polyline", data.names() ) == -1 ) {
		Rcpp::stop("polyline column not found");
	}
	*/

	// TODO
	// the R function must allow viridisLite::palette functions as arguments...

	// return a list with attributes (to make it a data.frame)
	// we know the size of the list...
  int data_rows = data.nrows();

	Rcpp::List lst = scatterplot_defaults( data_rows );  // initialise with defaults

	Rcpp::StringVector param_names = params.names();
	Rcpp::StringVector sv = mapdeck::scatterplot_columns;

	int n = params.size();
	int colIndex = -1;

	for (int i = 0; i < n; i ++ ) {
		// if the param element is length 1; check if it's a column name

		//std::string s = thisParam;
		//Rcpp::Rcout << "thisParam : " << s << std::endl;

		if( paramIsSingleString( params[i] ) ) {
			// it's a single string
			// is it also a column name

			Rcpp::StringVector param_value = params[i];
			colIndex = indexColumnName( param_value, data.names() );

			if ( colIndex >= 0) {
				// The param_value IS a column name
				// which 'sv' does it belong it?
				Rcpp::String thisParam = param_names[i];
				lst[ thisParam ] = data[ colIndex ];
				// TODO(if it's not a required column (e.g. tooltip), needs to append it to the list)
			}
		} else {
				// TODO(if it's not a column name, but thisParam IS in sv, it's a value to use for the whole column))
				// get the type of 'params[i]'
				// create a vector of that type
				if( paramIsSingleString( params[i] ) ) {
  				Rcpp::String thisString = params[i];
   				Rcpp::StringVector sv(data_rows, thisString);
	  			lst[ thisString ] = sv;
				}
		}
	}
	return construct_df( lst, data_rows );
}
