#include <Rcpp.h>
#include <algorithm>
using namespace Rcpp;

Rcpp::NumericVector m_diff(Rcpp::NumericVector x) {
	int n = x.size() - 1;
	Rcpp::NumericVector difference(n);
	int i = 0;
	for (i = 0; i < n; i++) {
		difference[i] = x[i+1] - x[i];
	}
	return difference;
}

Rcpp::NumericVector m_range(Rcpp::NumericVector x) {
	Rcpp::NumericVector rng(2);
	rng[0] = min(x);
	rng[1] = max(x);
	return rng;
}


Rcpp::NumericVector m_unique( Rcpp::NumericVector x) {
	return Rcpp::unique(x);
}

Rcpp::NumericVector m_seq( double x, double y, int length_out ) {

	// TODO(seq(x, y, length.out))
	// where length.out gives size of vector
	// so the difference between each element needs to divide into it
	Rcpp::NumericVector result(length_out);
	double step = (y - x) / (length_out - 1);
	int i = 1;
	result[0] = x;
	result[(length_out - 1)] = y;
	for (i = 1; i < (length_out - 1); i++ ) {
		result[i] = result[i - 1] + step;
	}

	return result;
	//return Rcpp::seq(x, y);
}

// Always rescales to (0, 1)
Rcpp::NumericVector m_rescale( Rcpp::NumericVector x) {
	int n = x.size();
	Rcpp::NumericVector rescaled(n);
	Rcpp::NumericVector rng = m_range(x);
	Rcpp::NumericVector diff_from = m_diff(rng); // should only be one value!
	int i = 0;

	for (i = 0; i < n; i++) {
		rescaled[i] = (x[i] - rng[0]) / diff_from[0];
	}
	// x / ()
	return rescaled;
}

Rcpp::IntegerVector m_findInterval(Rcpp::NumericVector x, Rcpp::NumericVector breaks) {
	IntegerVector out(x.size());

	NumericVector::iterator x_it = x.begin(), x_end = x.end(),
		breaks_it = breaks.begin(), breaks_end = breaks.end();
	IntegerVector::iterator out_it = out.begin();
	NumericVector::iterator ubound;

	for(; x_it != x_end; x_it++, out_it++) {
		ubound = std::upper_bound(breaks_it, breaks_end, *x_it);
		*out_it = std::distance(breaks_it, ubound);
	}

	return out;
}

// [[Rcpp::export]]
Rcpp::NumericVector rcpp_diff(Rcpp::NumericVector x) {
  return m_diff(x);
}

// [[Rcpp::export]]
Rcpp::NumericVector rcpp_range(Rcpp::NumericVector x) {
	return m_range(x);
}

// [[Rcpp::export]]
Rcpp::NumericVector rcpp_rescale(Rcpp::NumericVector x) {
	return m_rescale(x);
}

// [[Rcpp::export]]
Rcpp::NumericVector rcpp_unique(Rcpp::NumericVector x) {
	return m_unique(x);
}

// [[Rcpp::export]]
Rcpp::NumericVector rcpp_seq( double x, double y, int length_out) {
	return m_seq(x, y, length_out);
}

// https://github.com/wch/r-source/blob/5a156a0865362bb8381dcd69ac335f5174a4f60c/src/appl/interv.c#L39
// https://github.com/hadley/adv-r/blob/master/extras/cpp/find-interval.cpp
// [[Rcpp::export]]
Rcpp::IntegerVector rcpp_findInterval(NumericVector x, NumericVector breaks) {
	return m_findInterval(x, breaks);
}

// [[Rcpp::export]]
Rcpp::List rcpp_generate_palette(Rcpp::NumericVector x, Function pal) {
	//Rcpp::List out;
	Rcpp::NumericVector vals = m_unique(x);
	Rcpp::NumericVector scaledVals = m_rescale(vals);

	// add 1 to make the 'interval' inclusive
	//scaledVals.push_back(2);
	// NOPE

	//Rcpp::NumericVector rng = m_range(scaledVals);
	Rcpp::NumericVector rng(2);
	rng[0] = 0;
	rng[1] = 1; // This is always true

	int length_out = scaledVals.size() + 1;

	// Rcpp::Rcout << "length out: " << length_out << std::endl;
	// Rcpp::Rcout << "rng: " << rng << std::endl;

	Rcpp::NumericVector s = m_seq( rng[0], rng[1], length_out - 1 );

	// Rcpp::Rcout << "s: " << s << std::endl;
	// Rcpp::Rcout << "scaledVals: " << scaledVals << std::endl;

	Rcpp::IntegerVector f = m_findInterval(scaledVals, s);
	// decrease last item by 1?
	//f[scaledVals.size()] = f[scaledVals.size()-1] - 1;

	// Rcpp::Rcout << "f: " << f << std::endl;

	Rcpp::StringVector pal_colours = pal(length_out - 1);
	// Rcpp::Rcout << "pal_colours: " << pal_colours << std::endl;
	Rcpp::StringVector colours(f.size());
	colours = pal_colours[f-1];

  Rcpp::List lst;
	return lst;

	// Rcpp::List lst = Rcpp::List::create(
	// 	_["colours"] = colours,
	// 	_["variable"] = vals
	// );
	//
	// Rcpp::IntegerVector iv = Rcpp::seq(1, f.size());
	// lst.attr("class") = "data.frame";
	// lst.attr("row.names") = iv;
	// return lst;

	//return out;
}
