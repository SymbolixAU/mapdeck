
// issue 357
if( typeof globalThis === 'undefined') {
	var globalThis = window;
}

HTMLWidgets.widget({

  name: 'mapdeck',
  type: 'output',

  factory: function(el, width, height) {

		var deckgl;

    return {

      renderValue: function(x) {

			// issue 349
			/*
			function removeCircular(obj) {
				const seen = new WeakSet();
				const recurse = obj => {
					seen.add(obj,true);
					for( let [k, v] of Object.entries(obj)) {
					  if( typeof v === "object" && v !== null) {
						  if(seen.has(v)) delete obj[k];
						  else recurse(v);
					  } else {
						  continue;
					  }
					}
				}
				recurse(obj);
				return(obj);
			}
			*/

			// issue 364
			function buildDragObject(info) {
				var dragObject = {
      		coordinate: info.coordinate,
      		viewport: info.viewport,
      		x: info.x,
      		y: info.y
      	};

      	return(dragObject);
			}

      	md_setup_window( el.id );

      	if( x.show_view_state ) {
					md_setup_view_state( el.id );
					window[el.id + 'mapViewState'] = document.createElement("div");
					window[el.id + 'mapViewState'].setAttribute('id', el.id + 'mapViewState');
					window[el.id + 'mapViewState'].setAttribute('class', 'mapViewState');
					var mapbox_ctrl = document.getElementById( "mapViewStateContainer"+el.id);
					mapbox_ctrl.appendChild( window[el.id + 'mapViewState'] );
				}

        // INITIAL VIEW
        window[el.id + 'INITIAL_VIEW_STATE'] = {
        	longitude: x.location[0],
        	latitude: x.location[1],
        	zoom: x.zoom,
        	pitch: x.pitch,
        	bearing: x.bearing,
        	maxZoom: x.max_zoom,
       	 	minZoom: x.min_zoom,
       	 	maxPitch: x.max_pitch,
       	 	minPitch: x.min_pitch
        };

       if( x.access_token === null ) {
       	 deckgl = new deck.DeckGL({
       	 	  views: [ new deck.MapView({
       	 	  	id: el.id,
       	 	  	repeat: x.repeat_view,
//       	 	  	width: width,
//		       	 	height: height
       	 	  	}) ],
       	 	  map: false,
			      container: el.id,
			      initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      layers: [],
			      controller: true
			      //onLayerHover: setTooltip
			   });
			   window[el.id + 'map'] = deckgl;
       } else {
        deckgl = new deck.DeckGL({
        	  views: [ new deck.MapView({
        	  	id: el.id,
        	  	repeat: x.repeat_view,
//		       	 	width: width,
//		       	 	height: height
        	  	})
        	  ],
          	mapboxApiAccessToken: x.access_token,
			      container: el.id,
			      mapStyle: x.style,
			      initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      layers: [],
			      controller: true,
			      //onLayerHover: setTooltip
			      onViewStateChange: ({viewId, viewState, interactionState}) => {

			      	if (!HTMLWidgets.shinyMode && !x.show_view_state ) { return; }
							// as per:
							// https://github.com/uber/deck.gl/issues/3344
							// https://github.com/SymbolixAU/mapdeck/issues/211
			      	const viewport = new deck.WebMercatorViewport(viewState);
  						const nw = viewport.unproject([0, 0]);
  						const se = viewport.unproject([viewport.width, viewport.height]);

  						const w = nw[0] < -180 ? -180 : ( nw[0] > 180 ? 180 : nw[0] );
  						const n = nw[1] < -90 ? -90 : ( nw[1] > 90 ? 90 : nw[1] );

  						const e = se[0] < -180 ? -180 : ( se[0] > 180 ? 180 : se[0] );
  						const s = se[1] < -90 ? -90 : ( se[1] > 90 ? 90 : se[1] );

  						viewState.viewId = viewId;

							viewState.viewBounds = {
  							north: n, //nw[1],
  							east:  e, //se[0],
  							south: s, //se[1],
  							west:  w //nw[0]
  						};
  						viewState.interactionState = interactionState;

  						if( x.show_view_state ) {
  							var vs = JSON.stringify( viewState );
  							//console.log( vs );
  							window[el.id + 'mapViewState'].innerHTML = vs;
  						}

  						if (!HTMLWidgets.shinyMode ) { return; }

						  Shiny.onInputChange(el.id + '_view_change', viewState);
			      },

			      onDragStart(info, event){
			      	if (!HTMLWidgets.shinyMode) { return; }
			      	//console.log("drag start");
			      	//if( info.layer !== null ) { info.layer = null; }  // dragging a layer;
			      	info.layer = undefined; // in case of dragging a layer
			      	//console.log( info );
			      	Shiny.onInputChange(el.id +'_drag_start', buildDragObject(info) );
			      },
			      onDrag(info, event){
			      	if (!HTMLWidgets.shinyMode) { return; }
			      	//if( info.layer !== null ) { info.layer = null; }  // dragging a layer;
			      	info.layer = undefined; // in case of dragging a layer
			      	Shiny.onInputChange(el.id +'_drag', buildDragObject(info) );
			      },
			      onDragEnd(info, event){
			      	if (!HTMLWidgets.shinyMode) { return; }
			      	//if( info.layer !== null ) { info.layer = null; }  // dragging a layer;
			      	info.layer = undefined; // in case of dragging a layer
			      	Shiny.onInputChange(el.id +'_drag_end', buildDragObject(info) );
			      },
			      onResize(size) {
			      	if (!HTMLWidgets.shinyMode) { return; }
			      	Shiny.onInputChange(el.id +'_resize', size);
			      }
			      /*
			      */
			  });

			  window[el.id + 'map'] = deckgl;

       } // end if { access_token } else { }
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

  	//console.log( "mapdeckmap-calls" );

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

