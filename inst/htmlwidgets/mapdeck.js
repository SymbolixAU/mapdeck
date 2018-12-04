HTMLWidgets.widget({

  name: 'mapdeck',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    return {

      renderValue: function(x) {

      	//window.params = [];
      	//window.params.push({ 'map_id' : el.id });

      	window[el.id + 'layers'] = []; // keep track of layers for overlaying multiple
        window[el.id + 'legendPositions'] = [];     // array for keeping a referene to legend positions
        window[el.id + 'mapdeckBounds'] = [];       // store the bounding box of each layer
        window[el.id + 'globalBox'] = [];
        window[el.id + 'currentZoomLevel'] = 0;

      	// needs to be an array because .props takes an array of layers

        var mapDiv = document.getElementById(el.id);
        mapDiv.className = 'mapdeckmap';

        var legendContainer = document.createElement('div');
        legendContainer.className = "legendContainer";
        legendContainer.id = "legendContainer"+el.id;
        mapDiv.appendChild( legendContainer );

        var tooltipdiv = document.createElement('div');
        tooltipdiv.setAttribute("class", "mapdecktooltip");
        tooltipdiv.setAttribute("id", "mapdecktooltip"+el.id);
        mapDiv.appendChild(tooltipdiv);

        // INITIAL VIEW
        window[el.id + 'INITIAL_VIEW_STATE'] = {
        	longitude: x.location[0],
        	latitude: x.location[1],
        	zoom: x.zoom,
        	pitch: x.pitch,
        	bearing: x.bearing
        };

        const deckgl = new deck.DeckGL({
          	mapboxApiAccessToken: x.access_token,
            container: el.id,
			mapStyle: x.style,
            viewState: window[ el.id + 'INITIAL_VIEW_STATE' ],
			//initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			layers: []
        });

        window[el.id + 'map'] = deckgl;
        console.log(" initial map object");
        console.log( window[el.id + 'map']);

        md_initialise_map(el, x);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
      }

    };
  }
});

// following: https://codepen.io/vis-gl/pen/pLLQpN
// and: https://beta.observablehq.com/@pessimistress/deck-gl-geojsonlayer-example
function md_update_tooltip({x, y, object, layer, index}) {
    // object is the data object sent to the layer function

  const tooltip = document.getElementById('mapdecktooltip'+layer.props.map_id);
  var tt;

  if (object) {
  	//if(object.tooltip === undefined && object.properties.tooltip === undefined ) {
  	//	return;
  	//}
  	if ( object.properties.tooltip !== undefined ) {
	  	tt = object.properties.tooltip;
	  } else if ( object.tooltip !== undefined ) {
	  	tt = object.tooltip;
	  } else {
	  	return;
	  }

    tooltip.style.top = `${y}px`;
    tooltip.style.left = `${x}px`;
    tooltip.innerHTML = `<div>${tt}</div>`;
  } else {
    tooltip.innerHTML = '';
  }
}

if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler("mapdeckmap-calls", function (data) {

    var id = data.id,   // the div id of the map
      el = document.getElementById(id),
      map = el,
      call = [],
      i = 0;

    if (!map) {
      //console.log("Couldn't find map with id " + id);
      return;
    }

    for (i = 0; i < data.calls.length; i++) {

      call = data.calls[i];

      //push the mapId into the call.args
      call.args.unshift(id);

      if (call.dependencies) {
        Shiny.renderDependencies(call.dependencies);
      }

      if (window[call.method]) {
        window[call.method].apply(window[id + 'map'], call.args);
      } else {
        //console.log("Unknown function " + call.method);
      }
    }
  });
}

function md_initialise_map(el, x) {

	// call initial layers
  if (x.calls !== undefined) {

    for (layerCalls = 0; layerCalls < x.calls.length; layerCalls++) {

      //push the map_id into the call.args
      x.calls[layerCalls].args.unshift(el.id);

      if (window[x.calls[layerCalls].functions]) {

        window[x.calls[layerCalls].functions].apply(window[el.id + 'map'], x.calls[layerCalls].args);

      } else {
        //console.log("Unknown function " + x.calls[layerCalls]);
      }
    }
  }
}


function md_findObjectElementByKey(array, key, value ) {
    for ( var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return i;
        }
    }
    return -1;
}

function md_change_location( map_id, location, zoom, pitch, bearing, duration, transition ) {
	
  var currentLon, currentLat, currentPitch, currentBearing, currentZoom;
    
    console.log(" md_change_location args ");
    console.log( location );
    console.log( zoom );
    console.log( pitch );
    console.log( bearing );
    
  if ( window[ map_id + 'map'].viewState["default-view"] !== undefined ) {
    console.log( "default view ");
  	currentLon = location === null ? window[ map_id + 'map'].viewState["default-view"].longitude : location[0];
  	currentLat = location === null ? window[ map_id + 'map'].viewState["default-view"].latitude : location[1];
    currentPitch = pitch === null ? window[ map_id + 'map'].viewState["default-view"].pitch : pitch;
    currentBearing = bearing === null ? window[ map_id + 'map' ].viewState["default-view"].bearing : bearing;
    currentZoom = zoom === null ? window[ map_id + 'map'].viewState["default-view"].zoom : zoom;
      
  } else {
    console.log("non-default view");
    console.log( window[ map_id + 'map'].viewState );
  	currentLon = location === null ? window[ map_id + 'map'].viewState.longitude : location[0];
  	currentLat = location === null ? window[ map_id + 'map'].viewState.latitude : location[1];
    currentPitch = pitch === null ? window[ map_id + 'map'].viewState.pitch : pitch;
    currentBearing = bearing === null ? window[ map_id + 'map' ].viewState.bearing : bearing;
    currentZoom = zoom === null ? window[ map_id + 'map'].viewState.zoom : zoom;
  }
    
    console.log( currentLon );
    console.log( currentLat );
    console.log( currentPitch );
    console.log( currentBearing );
    console.log( currentZoom );
    
    var state  = {
      longitude: currentLon,
      latitude: currentLat,
      zoom: currentZoom,
      pitch: currentPitch,
      bearing: currentBearing,
      transitionInterpolator: transition === "fly" ? new deck.FlyToInterpolator() : new deck.LinearInterpolator(),
      transitionDuration: duration  
    }

    window[map_id + 'map'].setProps({
    //state: this.viewState,
    viewState: state,
  });
	
    console.log( "updated map object ");
    console.log( window[ map_id + 'map' ] );
}


function md_layer_view( map_id, layer_id, focus_layer, bbox, update_view ) {
  console.log("md_layer_view");
  if( focus_layer ) {
    console.log("focusing layer");
  	md_clear_bounds( map_id );
  	update_view = true;     // force this
  }

  if( bbox !== undefined && update_view) {
      console.log("update_view");
	  md_add_to_bounds( map_id, bbox, layer_id );
	  var loc = md_center_location( window[ map_id + 'globalBox'] );
	  md_change_location( map_id, loc, window[ map_id + 'currentZoomLevel'], null, null, 0, "linear" );
  }
}

function md_layer_clear( map_id, layer_id, layer ) {
	console.log("md_layer_clear");
	md_clear_layer( map_id, layer+'-'+layer_id );
  md_clear_legend( map_id, layer_id );
  md_remove_from_bounds( map_id, layer_id );
  md_update_location( map_id );
}

function md_center_location( bbox ) {
	console.log("md_center_location");
	console.log( bbox );

	cLon = (bbox[0][0] + bbox[1][0]) / 2;
	cLat = (bbox[0][1] + bbox[1][1]) / 2;
	var location = [cLon, cLat];
	return location;
}


function md_add_to_bounds( map_id, bbox, layer_id ) {
  console.log("md_add_to_bounds");
  var thisBox = {
  	layer_id: layer_id,
  	bbox: bbox
  };

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
	console.log("md_remove_from_bounds");

	var elem = md_findObjectElementByKey( window[ map_id + 'mapdeckBounds'], 'layer_id', layer_id );
	if ( elem != -1 ) {
		window[ map_id + 'mapdeckBounds'].splice( elem, 1 );
	}
	md_calculate_bounds( map_id, window[ map_id + 'mapdeckBounds'] );
	window[ map_id + 'currentZoomLevel'] = md_get_zoom_level( window[ map_id + 'globalBox'] );
}

function md_clear_bounds( map_id ) {
	console.log("md_clear_bounds");

	window[ map_id + 'mapdeckBounds'] = [];
	window[ map_id + 'globalBox'] = [];
	window[ map_id + 'currentZoomLevel'] = 0;
}

function md_update_location( map_id ) {
	console.log("md_udpate_location");

	var loc = md_center_location( window[ map_id + 'globalBox' ] );
	var zoom =  window[ map_id + 'currentZoomLevel' ];
	console.log( "Loc" );
	console.log( loc );
    
	if ( Number.isNaN( loc[0] ) ) {
		return;
	}

  md_change_location( map_id, loc, zoom, null, null, 0, "linear" );
}


function md_calculate_bounds( map_id, mapdeckBounds ) {
	console.log("md_caululate_bounds");

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
	console.log("md_lon_diff");

  xmin = globalBox[0][0];
  xmax = globalBox[1][0];
  xdiff = Math.abs( xmax - xmin );
  return xdiff;
}

function md_get_zoom_level( globalBox ) {
	//console.log("md_get_zoom_level");

  var londiff = md_lon_diff( globalBox );

  var zoomLevel = [
    360, 180, 90, 45, 22.5, 11.25, 5.65,2.813, 1.406,
    0.703, 0.352, 0.176, 0.088, 0.044, 0.022, 0.011, 0.005
  ];

  if ( londiff >= zoomLevel[0] ) {
    return 0;
  }
  var maxIndex = zoomLevel.length - 2;
  var currentValue = zoomLevel[0];
  var i;
  var thisZoom, nextZoom;
  for ( i = 0; i < maxIndex; i++ ) {
    thisZoom = zoomLevel[i];
    nextZoom = zoomLevel[(i+1)];
    if ( thisZoom >= londiff && londiff > nextZoom ) {
      return i;
    }
  }
  return i;
}


function md_update_layer( map_id, layer_id, layer ) {
	//console.log("md_update_layer");

  var elem = md_findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', layer_id );
  if ( elem != -1 ) {
  	window[ map_id + 'layers'][elem] = layer;
  } else {
  	window[map_id + 'layers'].push( layer );
  }
  window[map_id + 'map'].setProps({ layers: [...window[map_id + 'layers'] ] });
    console.log( "updated layer" );
}

function md_clear_layer( map_id, layer_id ) {
	//console.log("md_clear_layer");

  var elem = md_findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', layer_id);
  if ( elem != -1 ) {
  	window[ map_id + 'layers'].splice( elem, 1 );
  }
  window[map_id + 'map'].setProps({ layers: [...window[map_id + 'layers'] ] });
}

const md_hexToRGBA = ( hex ) => {
    let parseString = hex;
    if (hex.startsWith('#')) { parseString = hex.slice(1, 9); }
    if (parseString.length !== 8) {return null;}
    const r = parseInt(parseString.slice(0, 2), 16);
    const g = parseInt(parseString.slice(2, 4), 16);
    const b = parseInt(parseString.slice(4, 6), 16);
    const a = parseInt(parseString.slice(6, 8), 16);
    if (isNaN(r) || isNaN(g) || isNaN(b)) {return null;}
    return [r, g, b, a];
    //return `rgba(${r}, ${g}, ${b}, ${alpha})`;
};


/**
 * Converts a 'vector' of hex colours (with alpha) into an array
 */
function md_to_rgba( colour_range ) {
	var arr = [],
	i,
	n = colour_range.length;

	for (i = 0; i < n; i++) {
		arr.push( hexToRGBA( colour_range[i]) );
	}
  return arr;
}

function md_layer_click( map_id, layer, info ) {

  if ( !HTMLWidgets.shinyMode ) {
    return;
  }

  var eventInfo = {
  	index: info.index,
  	color: info.color,
  	object: info.object,
  	layerId: info.layer_id,
  	lat: info.lngLat[1],
  	lon: info.lngLat[0]
  };

  eventInfo = JSON.stringify( eventInfo );
  Shiny.onInputChange(map_id + "_" + layer + "_click", eventInfo);
}

function md_decode_points( polyline ) {
	var coordinates = md_decode_polyline( polyline ) ;
	return coordinates[0];
}

function md_decode_polyline(str, precision) {
  var index = 0,
      lat = 0,
      lng = 0,
      coordinates = [],
      shift = 0,
      result = 0,
      byte = null,
      latitude_change,
      longitude_change,
      factor = Math.pow(10, precision || 5);

  // Coordinates have variable length when encoded, so just keep
  // track of whether we've hit the end of the string. In each
  // loop iteration, a single coordinate is decoded.
  while (index < str.length) {

    // Reset shift, result, and byte
    byte = null;
    shift = 0;
    result = 0;

    do {
      byte = str.charCodeAt(index++) - 63;
      result |= (byte & 0x1f) << shift;
      shift += 5;
    } while (byte >= 0x20);

    latitude_change = ((result & 1) ? ~(result >> 1) : (result >> 1));

    shift = result = 0;

    do {
      byte = str.charCodeAt(index++) - 63;
      result |= (byte & 0x1f) << shift;
      shift += 5;
    } while (byte >= 0x20);

    longitude_change = ((result & 1) ? ~(result >> 1) : (result >> 1));

    lat += latitude_change;
    lng += longitude_change;

    coordinates.push([lng / factor, lat / factor]);
  }
  return coordinates;
}

function md_get_point_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.geometry.coordinates;
}

function md_get_origin_coordinates ( obj ) {
	if ( obj.geometry.origin === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.origin.coordinates;
}

function md_get_destination_coordinates ( obj ) {
	if ( obj.geometry.destination === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.destination.coordinates;
}


function md_get_line_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [[-179.999,-89.999],[-179.999,-89.999]];
	}
	return obj.geometry.geometry.coordinates;
}

function md_get_polygon_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [[-179.999,-89.999],[-179.999,-89.999],[-179.999,-89.999]];
	}
	return obj.geometry.geometry.coordinates;
}




