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


       } else {

         	console.log("loading map");
          const deckgl = new deck.DeckGL({
          	mapboxApiAccessToken: x.access_token,
			      container: el.id,
			      longitude: 144.5,
			      latitude: -37.9,
			      zoom: 4
        });

        window[el.id + 'map'] = deckgl;

        initialise_map(el, x);
       }

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
