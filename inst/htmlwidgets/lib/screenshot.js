
function md_screenshot( el ) {

	console.log( el );
	let cv = document.querySelector("#deckgl-overlay");
	console.log( cv );

	setTimeout( function() {
		var gl = cv.getContext("webgl2");

		html2canvas( cv ).then( canvas => {
			document.body.appendChild( canvas );
		});

	}, 200 );

	//html2canvas( document.querySelector("#deckgl-overlay") ).then( canvas => {
		//var gl = canvas.getContext("webgl2");
	  //console.log( gl );
		//document.body.appendChild( canvas );
	//});
}
