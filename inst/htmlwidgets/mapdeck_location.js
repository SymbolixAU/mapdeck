
function md_change_location( map_id, map_type, location, zoom, pitch, bearing, duration, transition ) {
  var currentLon, currentLat, currentPitch, currentBearing, currentZoom;

	var currentMaxZoom;
	var currentMinZoom;
	var currentMaxPitch;
	var currentMinPitch;

  if( map_type == "google_map" ) {
  	//console.log( location );
  	window[map_id + 'map'].setCenter( { lat: location[1], lng: location[0] } );
  	window[map_id + 'map'].setZoom( zoom );
  } else {

  	console.log( window[ map_id + 'map' ].viewState.longitude );

	  if ( window[ map_id + 'map'].viewState["default-view"] !== undefined ) {
	  	currentLon = (location === null || location.length == 0) ? window[ map_id + 'map'].viewState["default-view"].longitude : location[0];
	  	currentLat = (location === null || location.length == 0) ? window[ map_id + 'map'].viewState["default-view"].latitude : location[1];
	    currentPitch = pitch === null ? window[ map_id + 'map'].viewState["default-view"].pitch : pitch;
	    currentBearing = bearing === null ? window[ map_id + 'map' ].viewState["default-view"].bearing : bearing;
	    currentZoom = zoom === null ? window[ map_id + 'map'].viewState["default-view"].zoom : zoom;
	    currentMaxZoom = window[ map_id + 'map'].viewState["default-view"].maxZoom;
	    currentMinZoom = window[ map_id + 'map'].viewState["default-view"].minZoom;
	    currentMaxPitch = window[ map_id + 'map'].viewState["default-view"].maxPitch;
	    currentMinPitch = window[ map_id + 'map'].viewState["default-view"].minPitch;
	  } else {
	  	currentLon = (location === null || location.length == 0) ? window[ map_id + 'map'].viewState.longitude : location[0];
	  	currentLat = (location === null || location.length == 0) ? window[ map_id + 'map'].viewState.latitude : location[1];
	    currentPitch = pitch === null ? window[ map_id + 'map'].viewState.pitch : pitch;
	    currentBearing = bearing === null ? window[ map_id + 'map' ].viewState.bearing : bearing;
	    currentZoom = zoom === null ? window[ map_id + 'map'].viewState.zoom : zoom;
	    currentMaxZoom = window[ map_id + 'map'].viewState.maxZoom;
	    currentMinZoom = window[ map_id + 'map'].viewState.minZoom;
	  	currentMaxPitch = window[ map_id + 'map'].viewState.maxPitch;
	    currentMinPitch = window[ map_id + 'map'].viewState.minPitch;
	  }

	  console.log( currentLon );

		window[map_id + 'map'].setProps({
	    initialViewState: {
	      longitude: currentLon,
	      latitude: currentLat,
	      zoom: currentZoom,
	      maxZoom: currentMaxZoom,
	      minZoom: currentMinZoom,
	      maxPitch: currentMaxPitch,
	      minPitch: currentMinPitch,
	      pitch: currentPitch,
	      bearing: currentBearing,
	      transitionInterpolator: transition === "fly" ? new deck.FlyToInterpolator() : new deck.LinearInterpolator(),
	      transitionDuration: duration,
	      controller: true
	    }
	  });

  }
}

function md_update_style( map_id, style ) {

  var vs = window[ map_id + 'map'].viewState;
	var map = window[ map_id + 'map'].getMapboxMap();
	map.setStyle( style );

  window[ map_id + 'map' ].setProps({
  	layers: [...window[map_id + 'layers'] ],
  	map: map
  	//viewState: vs // issue 239 (& 322) - viewState no longer supported in deck.gl v8.0.8
  });
}

function md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view ) {

	if( focus_layer ) {
  	md_clear_bounds( map_id );
  	update_view = true;     // force this
  }

  if( bbox !== undefined && update_view) {

	  md_add_to_bounds( map_id, bbox, layer_id );
	  var loc = md_center_location( window[ map_id + 'globalBox'] );
	  md_change_location( map_id, map_type, loc, window[ map_id + 'currentZoomLevel'], null, null, 0, "linear" );
  }
}

function md_center_location( bbox ) {

	cLon = (bbox[0][0] + bbox[1][0]) / 2;
	cLat = (bbox[0][1] + bbox[1][1]) / 2;
	var location = [cLon, cLat];
	return location;
}


function md_add_to_bounds( map_id, bbox, layer_id ) {

  var thisBox = {
  	layer_id: layer_id,
  	bbox: bbox
  };

  if( window[ map_id + 'mapdeckBounds'] == null ) {
  	window[ map_id + 'mapdeckBounds'] = [];
  }

  if( window[ map_id + 'currentZoomLevel'] == null ) {
  	window[ map_id + 'currentZoomLevel'] = [];
  }

  if( window[ map_id + 'globalBox'] == null ) {
  	window[ map_id + 'globalBox'] = [];
  }

  var elem = md_findObjectElementByKey( window[ map_id + 'mapdeckBounds'], 'layer_id', layer_id );
	if ( elem != -1 ) {
		window[ map_id + 'mapdeckBounds' ][elem] = thisBox;
	} else {
		window[ map_id + 'mapdeckBounds'].push( thisBox );
	}

	md_calculate_bounds( map_id, window[ map_id + 'mapdeckBounds'] );

	window[ map_id + 'currentZoomLevel'] = md_get_zoom_level( window[ map_id + 'globalBox'] );
}

function md_remove_from_bounds( map_id, layer_id ) {

	var elem = md_findObjectElementByKey( window[ map_id + 'mapdeckBounds'], 'layer_id', layer_id );
	if ( elem != -1 ) {
		window[ map_id + 'mapdeckBounds'].splice( elem, 1 );
	}
	md_calculate_bounds( map_id, window[ map_id + 'mapdeckBounds'] );
	window[ map_id + 'currentZoomLevel'] = md_get_zoom_level( window[ map_id + 'globalBox'] );
}

function md_clear_bounds( map_id ) {

	window[ map_id + 'mapdeckBounds'] = [];
	window[ map_id + 'globalBox'] = [];
	window[ map_id + 'currentZoomLevel'] = 0;
}

function md_update_location( map_id, map_type ) {

	var loc = md_center_location( window[ map_id + 'globalBox' ] );
	var zoom =  window[ map_id + 'currentZoomLevel' ];

	if ( Number.isNaN( loc[0] ) ) {
		return;
	}

  md_change_location( map_id, map_type, loc, zoom, null, null, 0, "linear" );
}


function md_calculate_bounds( map_id, mapdeckBounds ) {

  var ymin, xmin, ymax, xmax, thisBox;
  for( var i = 0; i < mapdeckBounds.length; i++ ) {
    thisBox = mapdeckBounds[i].bbox;

    if ( i === 0 ) {
      xmin = thisBox[0][0];
      ymin = thisBox[0][1];
      xmax = thisBox[1][0];
      ymax = thisBox[1][1];
    } else {
      xmin = Math.min( xmin, thisBox[0][0] );
      ymin = Math.min( ymin, thisBox[0][1] );
      xmax = Math.max( xmax, thisBox[1][0] );
      ymax = Math.max( ymax, thisBox[1][1] );
    }
  }
  window[ map_id + 'globalBox'] = [[xmin, ymin],[xmax,ymax]];
}

function md_lon_diff( globalBox ) {

  xmin = globalBox[0][0];
  xmax = globalBox[1][0];
  xdiff = Math.abs( xmax - xmin );
  return xdiff;
}

function md_lat_diff( globalBox ) {

  ymin = globalBox[0][1];
  ymax = globalBox[1][1];
  ydiff = Math.abs( ymax - ymin );
  return ydiff;
}

function md_lon_zoom( londiff ) {

  var lonZoomLevel = [
    360, 180, 90, 45, 22.5, 11.25, 5.65,2.813, 1.406,
    0.703, 0.352, 0.176, 0.088, 0.044, 0.022, 0.011, 0.005
  ];

  if ( londiff >= lonZoomLevel[0] ) {
    return 0;
  }
  var maxIndex = lonZoomLevel.length - 2;
  var currentValue = lonZoomLevel[0];
  var i;
  var thisZoom, nextZoom;

  for ( i = 0; i < maxIndex; i++ ) {
    thisZoom = lonZoomLevel[ i ];
    nextZoom = lonZoomLevel[ (i+1) ];

    if ( thisZoom >= londiff && londiff > nextZoom ) {
      return i;
    }
  }
  return i;
}

function md_lat_zoom( latdiff ) {

  var latZoomLevel = [
    90, 45, 22.5, 11.25, 5.65,2.813, 1.406,
    0.703, 0.352, 0.176, 0.088, 0.044, 0.022, 0.011, 0.005, 0.0025, 0.000175
  ];

  if ( latdiff >= latZoomLevel[0] ) {
    return 0;
  }
  var maxIndex = latZoomLevel.length - 2;
  var currentValue = latZoomLevel[0];
  var i;
  var thisZoom, nextZoom;

  for ( i = 0; i < maxIndex; i++ ) {
    thisZoom = latZoomLevel[ i ];
    nextZoom = latZoomLevel[ (i+1) ];

    if ( thisZoom >= latdiff && latdiff > nextZoom ) {
      return i;
    }
  }
  return i;
}

function md_get_zoom_level( globalBox ) {

  var londiff = md_lon_diff( globalBox );
  var latdiff = md_lat_diff( globalBox );

  var lonZoom = md_lon_zoom( londiff );
  var latZoom = md_lat_zoom( latdiff );

  var diff = Math.min( lonZoom, latZoom );

  return diff;
}

