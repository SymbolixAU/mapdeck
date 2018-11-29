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
			      initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      layers: [],
			      //onLayerHover: setTooltip
			  });

        // https://github.com/uber/deck.gl/issues/2114
        /*
			  const viewPort = WebMercartorViewport({
			  	width: 800,
				  height: 600,
				  longitude: -122.45,
				  latitude: 37.78,
				  zoom: 12,
				  pitch: 60,
				  bearing: 30
			  });
			  console.log( viewPort );
			  */


			    window[el.id + 'map'] = deckgl;

			    //console.log( window[el.id + 'map']);

			    initialise_map(el, x);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
      }

    };
  }
});

function change_location( map_id, location, zoom, pitch, bearing, duration, transition ) {

/*
  console.log( location );
  console.log( zoom );
  console.log( pitch );
  console.log( bearing );
  console.log( duration );
*/
  var currentLon = location === null ? window[ map_id + 'map'].viewState.longitude : location[0];
  var currentLat = location === null ? window[ map_id + 'map'].viewState.latitude : location[1];
  var currentPitch = pitch === null ? window[ map_id + 'map'].viewState.pitch : pitch;
  var currentBearing = bearing === null ? window[ map_id + 'map' ].viewState.bearing : bearing;
  var currentZoom = zoom === null ? window[ map_id + 'map'].viewState.zoom : zoom;

/*
  console.log( currentLon );
  console.log( currentLat );
  console.log( currentPitch );
  console.log( currentBearing );
  console.log( currentZoom );
*/

	window[map_id + 'map'].setProps({
    viewState: {
      longitude: currentLon,
      latitude: currentLat,
      zoom: currentZoom,
      pitch: currentPitch,
      bearing: currentBearing,
      transitionInterpolator: transition === "fly" ? new deck.FlyToInterpolator() : new deck.LinearInterpolator(),
      transitionDuration: duration
    },
  });
}

// following: https://codepen.io/vis-gl/pen/pLLQpN
// and: https://beta.observablehq.com/@pessimistress/deck-gl-geojsonlayer-example
function updateTooltip({x, y, object, layer, index}) {
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

function initialise_map(el, x) {

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


function findObjectElementByKey(array, key, value ) {
    for ( var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return i;
        }
    }
    return -1;
}

function layer_view(map_id, layer_id, focus_layer, bbox, update_view ) {
	if( focus_layer ) {
  	clear_bounds( map_id );
  	update_view = true;     // force this
  }

  if( bbox !== undefined && update_view) {
	  add_to_bounds( map_id, bbox, layer_id );
	  var loc = center_location( window[ map_id + 'globalBox'] );
	  change_location( map_id, loc, window[ map_id + 'currentZoomLevel'], null, null, 0, "linear" );
  }
}

function layer_clear( map_id, layer_id, layer ) {
	clear_layer( map_id, layer+'-'+layer_id );
  clear_legend( map_id, layer_id );
  remove_from_bounds( map_id, layer_id );
  update_location( map_id );
}

function center_location( bbox ) {
	cLon = (bbox[0][0] + bbox[1][0]) / 2;
	cLat = (bbox[0][1] + bbox[1][1]) / 2;
	var location = [cLon, cLat];
	console.log( "center location ");
	console.log( location  );
	return location;
}


function add_to_bounds( map_id, bbox, layer_id ) {
  var thisBox = {
  	layer_id: layer_id,
  	bbox: bbox
  };

  var elem = findObjectElementByKey( window[ map_id + 'mapdeckBounds'], 'layer_id', layer_id );
	if ( elem != -1 ) {
		window[ map_id + 'mapdeckBounds' ][elem] = thisBox;
	} else {
		window[ map_id + 'mapdeckBounds'].push( thisBox );
	}
	console.log( window[ map_id + 'mapdeckBounds'] );
	calculate_bounds( map_id, window[ map_id + 'mapdeckBounds'] );

	console.log( "add_to_bounds() global box: " ) ;
	console.log( window[ map_id + 'globalBox'] );

	window[ map_id + 'currentZoomLevel'] = get_zoom_level( window[ map_id + 'globalBox'] );
}

function remove_from_bounds( map_id, layer_id ) {
	var elem = findObjectElementByKey( window[ map_id + 'mapdeckBounds'], 'layer_id', layer_id );
	if ( elem != -1 ) {
		window[ map_id + 'mapdeckBounds'].splice( elem, 1 );
	}
	calculate_bounds( map_id, window[ map_id + 'mapdeckBounds'] );

	console.log( "remove_from_bounds() global box: ");
	console.log( window[ map_id + 'globalBox'] );

	window[ map_id + 'currentZoomLevel'] = get_zoom_level( window[ map_id + 'globalBox'] );
}

function clear_bounds( map_id ) {
	window[ map_id + 'mapdeckBounds'] = [];
	window[ map_id + 'globalBox'] = [];
	window[ map_id + 'currentZoomLevel'] = 0;
}

function update_location( map_id ) {
	var loc = center_location( window[ map_id + 'globalBox' ] );
	var zoom =  window[ map_id + 'currentZoomLevel' ];

	//console.log("updating location:");
	//console.log( loc );
	//console.log( zoom );
  change_location( map_id, loc, zoom, null, null, 0, "linear" );
}


function calculate_bounds( map_id, mapdeckBounds ) {

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

function lon_diff( globalBox ) {
  xmin = globalBox[0][0];
  xmax = globalBox[1][0];
  xdiff = Math.abs( xmax - xmin );
  console.log( "londiff: " + xdiff );
  //return get_zoom_level( xdiff );
  return xdiff;
}

function get_zoom_level( globalBox ) {

  var londiff = lon_diff( globalBox );
  console.log( "londiff: " + londiff );

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
    //console.log( "thisZoom: " + thisZoom );
    //console.log( "londiff: " + londiff );
    if ( thisZoom >= londiff && londiff > nextZoom ) {
      return i;
    }
  }
  console.log( "zoom level: " + i );
  return i;
}


function update_layer( map_id, layer_id, layer ) {
  var elem = findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', layer_id );
  if ( elem != -1 ) {
  	window[ map_id + 'layers'][elem] = layer;
  } else {
  	window[map_id + 'layers'].push( layer );
  }
  window[map_id + 'map'].setProps({ layers: [...window[map_id + 'layers'] ] });
}

function clear_layer( map_id, layer_id ) {
  var elem = findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', layer_id);
  if ( elem != -1 ) {
  	window[ map_id + 'layers'].splice( elem, 1 );
  }
  window[map_id + 'map'].setProps({ layers: [...window[map_id + 'layers'] ] });
}


/**
 * hex to rgb
 *
 * Converts hex colours to rgb
 */
const hexToRgb_simple = hex =>
  hex.replace(/^#?([a-f\d])([a-f\d])([a-f\d])$/i
             ,(m, r, g, b) => '#' + r + r + g + g + b + b)
    .substring(1).match(/.{2}/g)
    .map(x => parseInt(x, 16));

const hexToRGBA = (hex, alpha = 255) => {
    let parseString = hex;
    if (hex.startsWith('#')) {parseString = hex.slice(1, 7);}
    if (parseString.length !== 6) {return null;}
    const r = parseInt(parseString.slice(0, 2), 16);
    const g = parseInt(parseString.slice(2, 4), 16);
    const b = parseInt(parseString.slice(4, 6), 16);
    if (isNaN(r) || isNaN(g) || isNaN(b)) {return null;}
    return [r, g, b, alpha];
    //return `rgba(${r}, ${g}, ${b}, ${alpha})`;
};


const hexToRGBA2 = ( hex ) => {
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


function to_rgb( colour_range ) {
	var arr = [],
	i,
	n = colour_range.length;

	for (i = 0; i < n; i++) {
		arr.push( hexToRgb_simple( colour_range[i]) );
	}
  return arr;
}

/**
 * Converts a 'vector' of hex colours (with alpha) into an array
 */
function to_rgba( colour_range ) {
	var arr = [],
	i,
	n = colour_range.length;

	for (i = 0; i < n; i++) {
		arr.push( hexToRGBA( colour_range[i]) );
	}
  return arr;
}

function layer_click( map_id, layer, info ) {

  if ( !HTMLWidgets.shinyMode ) {
    return;
  }

  //console.log( info );

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

function decode_points( polyline ) {
	var coordinates = decode_polyline( polyline ) ;
	return coordinates[0];
}

function decode_polyline(str, precision) {
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

function get_point_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.geometry.coordinates;
}

function get_origin_coordinates ( obj ) {
	if ( obj.geometry.origin === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.origin.coordinates;
}

function get_destination_coordinates ( obj ) {
	if ( obj.geometry.destination === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.destination.coordinates;
}


function get_line_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [[-179.999,-89.999],[-179.999,-89.999]];
	}
	return obj.geometry.geometry.coordinates;
}

function get_polygon_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [[-179.999,-89.999],[-179.999,-89.999],[-179.999,-89.999]];
	}
	return obj.geometry.geometry.coordinates;
}




