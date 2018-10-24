#include <Rcpp.h>
#include "legend/legend.hpp"


Rcpp::List construct_legend_list( Rcpp::List& lst_params,
                                  Rcpp::List& params,
                                  Rcpp::StringVector& param_names,
                                  Rcpp::StringVector& legend_types ) {

	// Rcpp::Rcout << "n: " << n << std::endl;
	// Rcpp::Rcout << "param names: " << param_names << std::endl;

	// Only include legends if the user supplied it as a paramter
	legend_types = Rcpp::intersect(legend_types, param_names);

	int n = legend_types.size();
	//n = legend_types.size();
	//Rcpp::Rcout << "n: " << n << std::endl;

	int i;
	Rcpp::List legend( n );

	// if ( n == 0 ) {
	// 	return legend;
	// }

	Rcpp::String this_legend;

	Rcpp::IntegerVector parameter_type = lst_params[ "parameter_type" ];

	for ( i = 0; i < n; i++ ) {
		//this_legend = legend_types[i];
		legend[ i ] = false;
	}
	legend.names() = legend_types;

	//Rcpp::Rcout << "legend types: " << legend_types << std::endl;

	// find the 'legend' argument
	int legend_location = mapdeck::find_character_index_in_vector( param_names, "legend" );
	//Rcpp::Rcout << "legend location: " << legend_location << std::endl;

	// Rcpp::Rcout << "legend - n: " << n << std::endl;
	// Rcpp::Rcout << "legend location: " << legend_location << std::endl;

	if ( legend_location > -1 ) {
		// switch on the typ e of legend/
		// if it's a Logical Vector, create a lsit with all the possible legend types


		SEXP lege = params[ legend_location ];

		//int tp = TYPEOF( lege ) ;
		//Rcpp::Rcout << "type: " << tp << std::endl;

		switch( TYPEOF( lege ) ) {
		case LGLSXP: { // logical
			// the user supplied either legend = T or legend = F
			// if T, switch all the 'false' elements to true
			for ( i = 0; i < n; i++ ) {  // TODO( dont' swithc the FALSEs to TRUE)
			  //bool use_legend = lege[i];
		    //Rcpp::Rcout << "use_legend: " << use_legend;
			  legend[ i ] = lege;
		  }
			//Rcpp::Rcout << "lglsxp legend" << std::endl;
			break;
		}
		case VECSXP: { // list
			//Rcpp::Rcout << "list legend " << std::endl;
			// iterate the list, and, if the item is true, switch the element of the list to true
			Rcpp::List lege_list = Rcpp::as< Rcpp::List >( lege );
			n = lege_list.size();
			Rcpp::StringVector lege_list_names = lege_list.names();
			//Rcpp::Rcout << "names: " << lege_list_names << std::endl;
			for (i = 0; i < n; i++ ) {
			  this_legend = lege_list_names[ i ];
				//Rcpp::Rcout << "this_legend " << this_legend.get_cstring() << std::endl;
				legend[ this_legend ] = lege_list[ i ];
			}
			break;
		}
		default: {
			Rcpp::stop("unknown legend type");
		}
		}

	}
  return legend;
}
