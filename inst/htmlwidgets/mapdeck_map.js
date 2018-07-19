HTMLWidgets.widget({

  name: 'mapdeck_map',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

      	window.params = [];
      	window.params.push({ 'map_id' : el.id });

        var mapDiv = document.getElementById(el.id);
        mapDiv.className = 'mapdeckmap';

       if (HTMLWidgets.shinyMode) {
       	// use setInterval to check if the map can be loaded
	      // the map is dependant on the mapdeck JS resource
	      // - usually implemented via callback

	      var checkExists = setInterval( function() {

	      	const deckgl = new deck.DeckGL({
          	mapboxApiAccessToken: x.access_token,
			      container: el.id,
			      mapStyle: x.style,
			      longitude: 0,
			      latitude: 0,
			      zoom: 1,
			      pitch: x.pitch
          });

          if (deck !== undefined) {
            //console.log("exists");
            clearInterval(checkExists);

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
			      longitude: 0,
			      latitude: 0,
			      zoom: 1,
			      pitch: x.pitch
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




