HTMLWidgets.widget({

  name: 'mapdeck',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    return {

      renderValue: function(x) {

      	window.params = [];
      	window.params.push({ 'map_id' : el.id });

      	window[el.id + 'layers'] = []; // keep track of layers for overlaying multiple
      	// needs to be an array because .props takes an array of layers

        var mapDiv = document.getElementById(el.id);
        mapDiv.className = 'mapdeckmap';

        // INITIAL VIEW
        window[el.id + 'INITIAL_VIEW_STATE'] = {
        	longitude: x.location[0],
        	latitude: x.location[1],
        	zoom: x.zoom,
        	pitch: x.pitch
        };

        window[el.id + 'VIEW_STATE_CHANGE'] = {

        };

        const	deckgl = new deck.DeckGL({
          	mapboxApiAccessToken: x.access_token,
			      container: el.id,
			      mapStyle: x.style,
			      initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      layers: []
			    });

			    window[el.id + 'map'] = deckgl;
			    initialise_map(el, x);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
      }

    };
  }
});


function change_location( map_id, location, duration, transition, zoom ) {

	window[map_id + 'map'].setProps({
    viewState: {
      longitude: location[0],
      latitude: location[1],
      zoom: zoom,
      pitch: 0,
      bearing: 0,
      transitionInterpolator: transition === "fly" ? new deck.FlyToInterpolator() : new deck.LinearInterpolator(),
      transitionDuration: duration
    },
  });
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

	console.log("initialising map");

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


function findObjectElementByKey(array, key, value, layer_data ) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return i;
        }
    }
    return -1;
}


function update_layer( map_id, layer_id, layer ) {
  var elem = findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', layer_id);
  if ( elem != -1 ) {
  	window[ map_id + 'layers'][elem] = layer;
  } else {
  	window[map_id + 'layers'].push( layer );
  }
  window[map_id + 'map'].setProps({ layers: [...window[map_id + 'layers'] ] });
}


/**
 * hex to rgb
 *
 * Converts hex colours to rgb
 */
const hexToRgb = hex =>
  hex.replace(/^#?([a-f\d])([a-f\d])([a-f\d])$/i
             ,(m, r, g, b) => '#' + r + r + g + g + b + b)
    .substring(1).match(/.{2}/g)
    .map(x => parseInt(x, 16));

/**
 * Converts a 'vector' of hex colours (with alpha) into an array
 */
function to_rgba( colour_range ) {
	var arr = [],
	i,
	n = colour_range.length;

	for (i = 0; i < n; i++) {
		arr.push( hexToRgb(colour_range[i]) );
	}
  console.log( arr );
  return arr;
}

function layer_click( map_id, layer, info ) {

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


