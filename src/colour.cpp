#include <Rcpp.h>

#include "mapdeck.hpp"
#include "palette/palette.hpp"
#include "legend/legend.hpp"


Rcpp::List make_colours(
		Rcpp::List& lst_params,
		Rcpp::List& params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		Rcpp::IntegerVector& data_column_index,
		SEXP& palette_type,                // string or matrix
		Rcpp::NumericVector& alpha,
		const char* colour_name,
		bool include_legend) {

	std::string na_colour = params.containsElementNamed("na_colour") ? params["na_colour" ] : mapdeck::defaults::default_na_colour;
	bool include_alpha = true;            // always true - deck.gl supports alpha

	SEXP pal = mapdeck::palette::resolve_palette( lst_params, params );

	switch ( TYPEOF( palette_type ) ) {
	case 16: {
		Rcpp::StringVector colour_vec = Rcpp::as< Rcpp::StringVector >( palette_type );
		Rcpp::List legend = mapdeck::palette::colour_with_palette( pal, colour_vec, alpha, na_colour, include_alpha );
		if ( include_legend ) {
			legend[ "colour_type" ] = colour_name;
			legend[ "type" ] = "category";
		}
		return legend;
		break;
	}
	default: {
		Rcpp::NumericVector colour_vec = Rcpp::as< Rcpp::NumericVector >( palette_type );
		// Rcpp::Rcout << "colour_vec: " << colour_vec << std::endl;
		Rcpp::List legend = mapdeck::palette::colour_with_palette( pal, colour_vec, alpha, na_colour, include_alpha );
		// Rcpp::StringVector colours = legend["colours"];
		// Rcpp::Rcout << "colours: " << colours << std::endl;
		// Rcpp::NumericVector summary = legend["summary_values"];
		// Rcpp::Rcout << "summary" << summary << std::endl;
		if ( include_legend ) {
			legend[ "colour_type" ] = colour_name;
			legend[ "type" ] = "gradient";
		}
		return legend;
		break;
	}
	}
}

void resolve_colour(
		Rcpp::List& lst_params,
		Rcpp::List& params,
		Rcpp::DataFrame& data,
		Rcpp::List& lst_defaults,
		const char* colour_name,
		const char* opacity_name,
		Rcpp::List& lst_legend,
		bool include_legend ) {

	Rcpp::IntegerVector data_column_index = lst_params[ "data_column_index" ];
	Rcpp::IntegerVector parameter_type = lst_params[ "parameter_type" ];
	Rcpp::StringVector param_names = params.names();

	Rcpp::StringVector hex_strings( data.nrows() );

	Rcpp::NumericVector alpha( 1, 255.0 ); // can be overwritten by user

	SEXP this_colour = lst_defaults[ colour_name ];

	int colour_location = mapdeck::find_character_index_in_vector( param_names, colour_name );
	int opacity_location = mapdeck::find_character_index_in_vector( param_names, opacity_name );

	int colourColIndex = colour_location >= 0 ? data_column_index[ colour_location ] : -1;
	int alphaColIndex = opacity_location >= 0 ? data_column_index[ opacity_location ] : -1;

	if ( colourColIndex >= 0 ) {
		this_colour = data[ colourColIndex ];
	} else {
		// TODO ( if it's a hex string, apply it to all rows of data )
		// i.e., when not a column of data, but ISS a hex string
		// so this will be
		// } else if (is_hex_string() ) {
		// Rcpp::StringVector hex( data_rows, hex );
		//}
	}

	if ( alphaColIndex >= 0 ) {
		alpha = data[ alphaColIndex ];
	} else {

		int find_opacity = mapdeck::find_character_index_in_vector( param_names, opacity_name );
		if (find_opacity >= 0 ) {
			int a = params[ find_opacity ]; // will throw an error if not correct type
			alpha.fill( a );
		}
	}

	Rcpp::List legend = make_colours(
		lst_params, params, data, lst_defaults, data_column_index, //hex_strings,
		this_colour, alpha, colour_name, include_legend
	);

	lst_defaults[ colour_name ] = legend[ "colours" ];

	if (lst_legend.containsElementNamed( colour_name ) ) {

		if ( include_legend ) {

			std::string title = params[ colour_name ];
			std::string css = "";

			if ( params.containsElementNamed("legend_options") ) {

				Rcpp::List opts = params[ "legend_options" ];
				set_legend_option( opts, "title", title, colour_name );
				set_legend_option( opts, "css", css, colour_name );
			}

			Rcpp::List summary = Rcpp::List::create(
				Rcpp::_["colour"] = legend[ "summary_colours" ],
        Rcpp::_["variable"] = legend[ "summary_values" ],
        Rcpp::_["colourType"] = legend[ "colour_type" ],
        Rcpp::_["type"] = legend["type"],
        Rcpp::_["title"] = title,
        Rcpp::_["css"] = css
			);
			lst_legend[ colour_name ] = summary;
		}
	}
}
