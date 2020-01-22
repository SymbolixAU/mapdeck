HTMLWidgets.widget({

  name: 'mapdeck',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    return {

      renderValue: function(x) {

        //console.log( "getting mapbox map??" );
        //console.log( mapboxgl );

      	md_setup_window( el.id );

				if( x.show_view_state ) {
      	  md_setup_view_state( el.id );
      	  window[el.id + 'mapViewState'] = document.createElement("div");
      	  window[el.id + 'mapViewState'].setAttribute('id', el.id + 'mapViewState');
      	  window[el.id + 'mapViewState'].setAttribute('class', 'mapViewState');
      	  var mapbox_ctrl = document.getElementById( "mapViewStateContainer"+el.id);
    			mapbox_ctrl.appendChild( window[el.id + 'mapViewState'] );
				}

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
			      initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      //viewState: window[el.id + 'INITIAL_VIEW_STATE'], // no longer supported - deck.gl v8.0.0
			      layers: [],
			      controller: true
			      //onLayerHover: setTooltip
			   });
			   window[el.id + 'map'] = deckgl;
       } else {
        const deckgl = new deck.DeckGL({
          	mapboxApiAccessToken: x.access_token,
          	//map: mapboxgl,
			      container: el.id,
			      mapStyle: x.style,
			      initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      //viewState: window[el.id + 'INITIAL_VIEW_STATE'],
			      layers: [],
			      controller: true,
			      //onLayerHover: setTooltip
			      onViewStateChange: ({viewId, viewState, interactionState}) => {

			      	//console.log("view");
			      	//console.log(view);

							//var lngLat = [144, -37];
							//var pos = [5,2];
							//console.log( deck.WebMercatorViewport.getMapCenterByLngLatPosition({ lngLat, pos }) );
			      	//console.log( deck.getMapCenterByLngLatPosition( viewState ) );
			      	//var vp = new deck.WebMercatorViewport({viewState});
			      	//console.log( vp );
			      	//console.log( deck.WebMercatorViewport );
			      	//console.log( viewId );
			      	//console.log( viewState );
			      	//console.log( interactionState );
			      	//return;

			      	if (!HTMLWidgets.shinyMode && !x.show_view_state ) { return; }
							// as per:
							// https://github.com/uber/deck.gl/issues/3344
							// https://github.com/SymbolixAU/mapdeck/issues/211
							//console.log("viewState");
							//console.log( viewState );
			      	const viewport = new deck.WebMercatorViewport({viewState});
			      	//console.log("viewport");
			      	//console.log( viewport );

			      	//console.log("initialViewState");
			      	//console.log(initialViewState);

			      	//console.log("dimensions: " );
			      	//console.log( getDimensions( 800, 900 ) );

			      	// 'project()' functions take lon/lat inputs
			      	// 'unproject()' functions take x/y (screen) inputs
			      	var lonlat_center = [ viewState.longitude, viewState.latitude ];
			      	var xy_center = viewport.projectFlat( lonlat_center );

							var xy_wh = [ viewState.width, viewState.height ];
							var lonlat_wh = viewport.unprojectFlat( [ viewState.width, viewState.height ] );
			      	//var minX = projected_center[0] - viewport.width;
			      	//var minY = projected_center[1] - viewport.height;

			      	//var projXY = viewport.unprojectFlat( [minX, minY] );

							//var lonlat_wh = viewport.unprojectFlat( [viewState.width, viewState.height, viewState.zoom ]);


							//var maxY = lonlat_wh[1] - xy_center[1];
							//var minY = projected_center[1] - maxY;

  						//const nw = viewport.unproject([0, 0]);
  						//const se = viewport.unproject([viewport.width, viewport.height]);

  						//const nw = viewport.unprojectFlat([0, 0]);
  						//const se = viewport.unprojectFlat([viewState.width, viewState.height]);

  						//console.log( nw );
  						//console.log( se );

  						//const w = nw[0] < -180 ? -180 : ( nw[0] > 180 ? 180 : nw[0] );
  						//const n = nw[1] < -90 ? -90 : ( nw[1] > 90 ? 90 : nw[1] );

  						//const e = se[0] < -180 ? -180 : ( se[0] > 180 ? 180 : se[0] );
  						//const s = se[1] < -90 ? -90 : ( se[1] > 90 ? 90 : se[1] );

							var east = viewState.width - xy_center[0];
							var rightEdgeY = xy_center[1];
							var rigthEdgeLonLat = viewport.unprojectFlat( [rightEdgeX, rightEdgeY] );

							var val;

							val = {
								//lonlat_center: lonlat_center,
								//xy_center: viewport.projectFlat( lonlat_center ),
								//xy_wh: xy_wh,
								//lonlat_wh: lonlat_wh,
								//viewPort: viewport,
								viewState: viewState,
								xyz: viewport.projectFlat( [viewState.longitude, viewState.latitude ]),
								rightEdge: [rightEdgeX, rightEdgeY],
								rigthEdgeLonLat: rigthEdgeLonLat
								//getDistanceScales: viewport.getDistanceScales()
								//getCameraPosition: viewport.getCameraPosition(),
								//getCameraDirection: viewport.getCameraDirection(),
								//getCameraUp: viewport.getCameraUp()
								//maxY: maxY,
								//minY: minY
							};

  						var vs = JSON.stringify( val, null, 2 );
  						window[el.id + 'mapViewState'].innerHTML = vs;

  						return;

/*
  						viewState.viewBounds = {
  							north: n, //nw[1],
  							east:  e, //se[0],
  							south: s, //se[1],
  							west:  w //nw[0]
  						};
  						viewState.interactionState = interactionState;
*/
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
			      	//if( info.layer !== null ) { info.layer = null; }  // dragging a layer;
			      	info.layer = undefined; // in case of dragging a layer
			      	Shiny.onInputChange(el.id +'_drag_start', info);
			      },
			      onDrag(info, event){
			      	if (!HTMLWidgets.shinyMode) { return; }
			      	//if( info.layer !== null ) { info.layer = null; }  // dragging a layer;
			      	info.layer = undefined; // in case of dragging a layer
			      	Shiny.onInputChange(el.id +'_drag', info);
			      },
			      onDragEnd(info, event){
			      	if (!HTMLWidgets.shinyMode) { return; }
			      	//if( info.layer !== null ) { info.layer = null; }  // dragging a layer;
			      	info.layer = undefined; // in case of dragging a layer
			      	Shiny.onInputChange(el.id +'_drag_end', info);
			      },
			      onResize(size) {
			      	if (!HTMLWidgets.shinyMode) { return; }
			      	Shiny.onInputChange(el.id +'_resize', size);
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

