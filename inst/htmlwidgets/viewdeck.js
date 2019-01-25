
HTMLWidgets.widget({

  name: 'viewdeck',
  type: 'output',

  factory: function(el, width, height) {

  console.log( "viewdeck" );

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
        mapDiv.className = 'viewdeckview';

				window[el.id + 'INITIAL_VIEW_STATE'] = {
        	lookAt: [0, 0, 0],
				  //distance: OrbitView.getDistance({boundingBox: [3, 3, 3], fov: 50}),
				  distance: 50,
				  up: [0, 0, 0],
				  rotationX: -30,
				  rotationOrbit: 30,
				  orbitAxis: 'Y',
				  fov: 50,
				  minDistance: 1,
				  maxDistance: 20
        };

        const orbitView = new deck.OrbitView();

        const deckgl = new deck.DeckGL({
        	container: el.id,
        	views: orbitView,
        	initialViewState: window[el.id + 'INITIAL_VIEW_STATE'],
        	layers: [],
        	parameters: {
            clearColor: [0.07, 0.14, 0.19, 1],
          //  blendFunc: [GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA]
          }
        });

        console.log( deckgl );

				/*
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
			  */

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
			    md_initialise_view(el, x);
      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }

    };
  }
});


function add_pointcloud_geo_view( map_id, pointcloud_data, radius, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {

  const pointcloudLayer = new deck.PointCloudLayer({
  	map_id: map_id,
    id: 'pointcloud-'+layer_id,
    data: pointcloud_data,
    radiusPixels: radius,
    //getPosition: d => d.geometry.geometry.coordinates,
    getPosition: d => md_get_point_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.fill_colour ),
    lightSettings: light_settings,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "pointcloud", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });
  md_update_layer( map_id, 'pointcloud-'+layer_id, pointcloudLayer );

  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
  md_layer_view( map_id, layer_id, focus_layer, bbox, update_view );
}

function md_initialise_view(el, x) {

	// call initial layers
  if (x.calls !== undefined) {

    for (layerCalls = 0; layerCalls < x.calls.length; layerCalls++) {

      //push the map_id into the call.args
      x.calls[layerCalls].args.unshift(el.id);

      if (window[x.calls[layerCalls].functions]) {

        window[x.calls[layerCalls].functions].apply(window[el.id + 'viewdeck'], x.calls[layerCalls].args);

      } else {
        //console.log("Unknown function " + x.calls[layerCalls]);
      }
    }
  }
}



