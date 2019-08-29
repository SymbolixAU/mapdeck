
//#include <Rcpp.h>
// TODO
// cpp code to call wasm to call javascript
// .wasm file will be in /inst/htmlwidgets/lib
// compiler steps....
// in src/ emcc -I../inst/include  wasm.cpp --js-library ../inst/htmlwidgets/wasm_calls.js


//#include "wasm.hpp"

#ifdef __cplusplus
extern "C" {
#endif

	extern void my_js() {};

#ifdef __cplusplus
}
#endif

//[[Rcpp::export]]
void call_js() {
	//Rcpp::Rcout << "call_js()" << std::endl;
	//my_js();
}
