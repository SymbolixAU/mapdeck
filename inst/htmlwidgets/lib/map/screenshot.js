
function add_screenshot( map_id, map_type ) {
	'use strict';

	if( !md_div_exists( 'mapScreenshotButtonContainer'+map_id ) ) {
  	md_setup_screenshot( map_id );

  	if( map_type == "google_map" ) {
  		var mapbox_ctrl = document.getElementById( "mapScreenshotButtonContainer"+map_id );
    	// if the titleContainer already exists on the element, we don't need to push it to the map
    	window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_CENTER].push( mapbox_ctrl );
     }

  }

  var mapScreenshotButton = document.createElement("button");
  mapScreenshotButton.innerHTML = "screenshot";

  var screenshotContainer = document.getElementById( "mapScreenshotButtonContainer"+map_id);
  screenshotContainer.appendChild( mapScreenshotButton );

  mapScreenshotButton.addEventListener("click", function() {
  	//alert("button");

  	let deckCanvas = window[ map_id + 'map'].canvas;
  	console.log( deckCanvas );
  	let a = document.createElement('a');
  	a.href = deckCanvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
  	a.download = 'screenshot.png';
  	a.click();


  });
}
