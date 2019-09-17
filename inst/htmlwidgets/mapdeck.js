HTMLWidgets.widget({

  name: 'mapdeck',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    return {

      renderValue: function(x) {

				console.log( x );

				//if (typeof x.callback === 'function') {

				//}

        window.mapdeck = [];
        window.mapdeck.globals = [];

      	md_setup_window( el.id );
      	window.mapdeck.globals.push( x.callback );
      	//window.my_radius = x.callback;

      	console.log( window.mapdeck.globals );

        /*
        // controller with events
        const myController = new deck.Controller({


        	handleEvent(event) {
        		console.log( "event" );
        		console.log( event );
        		if( event.type == "zoom") {
        			console.log("zooming");
        		}
        	}
        });

        console.log( myController );
        */

        // INITIAL VIEW
        window[el.id + 'INITIAL_VIEW_STATE'] = {
        	longitude: x.location[0],
        	latitude: x.location[1],
        	zoom: x.zoom,
        	pitch: x.pitch,
        	bearing: x.bearing
        };

       if( x.access_token === null ) {
       	 const deckgl = new deck.DeckGL({
       	 	  map: false,
			      container: el.id,
			      //initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      viewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      layers: [],
			      //onLayerHover: setTooltip
			   });
			   window[el.id + 'map'] = deckgl;
       } else {
        const deckgl = new deck.DeckGL({
          	mapboxApiAccessToken: x.access_token,
          	//map: mapboxgl,
			      container: el.id,
			      mapStyle: x.style,
			      //initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      viewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      layers: [],
			      //controller: myController
			      //onLayerHover: setTooltip
			      onViewStateChange: ({viewState}) => {

							// as per:
							// https://github.com/uber/deck.gl/issues/3344
							// https://github.com/SymbolixAU/mapdeck/issues/211
			      	const viewport = new WebMercatorViewport(viewState);
  						const nw = viewport.unproject([0, 0]);
  						const se = viewport.unproject([viewport.width, viewport.height]);

  						viewState.viewBounds = {
  							north: nw[1],
  							east:  se[0],
  							south: se[1],
  							west:  nw[0]
  						};

			      	if (!HTMLWidgets.shinyMode) {
						    return;
						  }
						  Shiny.onInputChange(el.id + '_view_change', viewState);
			      }
			  });

			  window[el.id + 'map'] = deckgl;

       }
			    md_initialise_map(el, x);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
      }
    };
  }
});


if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler("mapdeckmap-calls", function (data) {

  	console.log( "mapdeckmap-calls" );

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

