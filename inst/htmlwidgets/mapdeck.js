HTMLWidgets.widget({

  name: 'mapdeck',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    return {

      renderValue: function(x) {

      	md_setup_window( el.id );

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
			      container: el.id,
			      mapStyle: x.style,
			      //initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      viewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      layers: [],
			      //onLayerHover: setTooltip
			  });
			  //deckgl.setProps({viewState: window[el.id + 'INITIAL_VIEW_STATE']});
			  window[el.id + 'map'] = deckgl;
       }
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
