#ifndef MAPDECK_GEOJSONSF_H
#define MAPDECK_GEOJSONSF_H

#include <Rcpp.h>

Rcpp::StringVector rcpp_sf_to_geojson_atomise( Rcpp::DataFrame& sf );

Rcpp::StringVector rcpp_sf_to_geojson( Rcpp::DataFrame& sf );

Rcpp::StringVector rcpp_df_to_geojson_atomise( Rcpp::DataFrame& sf, const char* lon, const char* lat );

Rcpp::StringVector rcpp_df_to_geojson( Rcpp::DataFrame& sf, const char* lon, const char* lat );

#endif
