#ifndef MAPDECK_GEOJSONSF_H
#define MAPDECK_GEOJSONSF_H

#include <Rcpp.h>

Rcpp::StringVector rcpp_sf_to_geojson_atomise( Rcpp::DataFrame& sf );

Rcpp::StringVector rcpp_sf_to_geojson( Rcpp::DataFrame& sf );

#endif
