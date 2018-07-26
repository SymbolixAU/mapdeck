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

       if (HTMLWidgets.shinyMode) {
       	// use setInterval to check if the map can be loaded
	      // the map is dependant on the mapdeck JS resource
	      // - usually implemented via callback

	      console.log(" re-initialising map ");

	      var checkExists = setInterval( function() {

	      	const deckgl = new deck.DeckGL({
          	mapboxApiAccessToken: x.access_token,
			      container: el.id,
			      mapStyle: x.style,
			      longitude: x.location[1],
			      latitude: x.location[0],
			      zoom: x.zoom,
			      pitch: x.pitch,
			      layers: []
			    });

          if (deck !== undefined) {
            //console.log("exists");
            clearInterval(checkExists);

            window[el.id + 'map'] = deckgl;

            initialise_map(el, x);

          } else {
            //console.log("does not exist!");
          }

	      }, 100);

       } else {

         	console.log("loading map");
          const deckgl = new deck.DeckGL({
          	mapboxApiAccessToken: x.access_token,
			      container: el.id,
			      mapStyle: x.style,
			      longitude: x.location[0],
			      latitude: x.location[1],
			      zoom: x.zoom,
			      pitch: x.pitch,
			      layers: []
          });

          window[el.id + 'map'] = deckgl;

          initialise_map(el, x);
       }

       //console.log(hexToRgb("#0F0F0F"));

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});


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


function change_location( map_id, location ) {

	console.log( location );
	console.log( location[0] );

	window[map_id + 'map'].setProps({
    viewState: {
      longitude: location[0],
      latitude: location[1],
      zoom: 10,
      pitch: 0,
      bearing: 0
    },
    transitionInterpolator: new deck.experimental.ViewportFlyToInterpolator(),
    transitionDuration: 5000
  });

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

        //coordinates.push([lat / factor, lng / factor]);
        coordinates.push([lng / factor, lat / factor]);
    }

    return coordinates;
}


