#ifndef R_MAPDECK_LAYER_COLOURS_H
#define R_MAPDECK_LAYER_COLOURS_H

#include <Rcpp.h>

namespace mapdeck {
namespace layer_colours {

	const std::unordered_map< std::string, std::string > fill_stroke_colours({
		{ "fill_colour", "fill_opacity" },
		{ "stroke_colour", "stroke_opacity"}
	});

	const Rcpp::StringVector fill_stroke_legend = Rcpp::StringVector::create(
		"fill_colour","stroke_colour"
	);

	const std::unordered_map< std::string, std::string > fill_colours({
		{ "fill_colour", "fill_opacity" }
	});

	const Rcpp::StringVector fill_legend = Rcpp::StringVector::create(
		"fill_colour"
	);

	const std::unordered_map< std::string, std::string > stroke_colours({
		{ "stroke_colour", "stroke_opacity"}
	});

	const Rcpp::StringVector stroke_legend = Rcpp::StringVector::create(
		"stroke_colour"
	);

	const std::unordered_map< std::string, std::string > stroke_od_colours = {
		{ "stroke_from", "stroke_from_opacity" },
		{ "stroke_to", "stroke_to_opacity" }
	};

	const Rcpp::StringVector stroke_od_legend = Rcpp::StringVector::create(
		"stroke_from", "stroke_to"
	);

	const std::unordered_map< std::string, std::string > no_colours;

	const Rcpp::StringVector no_legend = Rcpp::StringVector::create();


} // namespace column
} // namespace mapdeck


#endif
