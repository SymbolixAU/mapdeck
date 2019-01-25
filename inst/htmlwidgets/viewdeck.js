
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
        mapDiv.className = 'mapdeckmap';

        var legendContainer = document.createElement('div');
        legendContainer.className = "legendContainer";
        legendContainer.id = "legendContainer"+el.id;
        mapDiv.appendChild( legendContainer );

        var tooltipdiv = document.createElement('div');
        tooltipdiv.setAttribute("class", "mapdecktooltip");
        tooltipdiv.setAttribute("id", "mapdecktooltip"+el.id);
        mapDiv.appendChild(tooltipdiv);

				window[el.id + 'INITIAL_VIEW_STATE'] = {
        	lookAt: [0, 0, 0],
				  //distance: OrbitView.getDistance({boundingBox: [3, 3, 3], fov: 50}),
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
        	//parameters: {
          //  clearColor: [0.07, 0.14, 0.19, 1],
          //  blendFunc: [GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA]
          //}
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
			    md_initialise_map(el, x);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
      }

    };
  }
});
