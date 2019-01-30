
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


function add_plot( view_id, plot_data, radius, layer_id, light_settings, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition ) {


  function equation(x, y) {
  	z = (Math.sin(x * x + y * y) * x ) / Math.PI;
  	return z;
  }

  const plotLayer = new deck.PlotLayer({
    id: 'pointcloud-'+layer_id,
    data: plot_data,
    getPosition: (u, v) => {
    	const x = ( u - 1 / 2 ) * Math.PI * 2;
    	const y = ( v - 1 / 2 ) * Math.PI * 2;
    	return [x, y, equation(x, y)];
    },
    getColor: (x, y, z) => [40, z * 128 + 128, 160],
    axesPadding: 0.25,
    axesColor: [0, 0, 0, 128],
    opacity: 1,
    pickable: true
  });
  md_update_layer( view_id, 'plot-'+layer_id, pointcloudLayer );

/*
  if (legend !== false) {
    add_legend(map_id, layer_id, legend);
  }
*/
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

const md_hexToRGBA = ( hex ) => {
    let parseString = hex;
    if (hex.startsWith('#')) { parseString = hex.slice(1, 9); }

    if ( parseString.length === 6 ) {
    	parseString = parseString + "FF";
    } else if ( parseString.length === 3 ) {
    	parseString = parseString + "F";
    } else if (parseString.length !== 8) {
    	return null;
    }
    const r = parseInt(parseString.slice(0, 2), 16);
    const g = parseInt(parseString.slice(2, 4), 16);
    const b = parseInt(parseString.slice(4, 6), 16);
    const a = parseInt(parseString.slice(6, 8), 16);
    if (isNaN(r) || isNaN(g) || isNaN(b)) {return null;}
    return [r, g, b, a];
    //return `rgba(${r}, ${g}, ${b}, ${alpha})`;
};

// following: https://codepen.io/vis-gl/pen/pLLQpN
// and: https://beta.observablehq.com/@pessimistress/deck-gl-geojsonlayer-example
function md_update_tooltip({x, y, object, layer, index}) {
    // object is the data object sent to the layer function

  const tooltip = document.getElementById('mapdecktooltip'+layer.props.map_id);
  var tt;

  //console.log( tooltip );
  //console.log( object );
  //console.log( x, ", ", y );

  if (object) {
  	//if(object.tooltip === undefined && object.properties.tooltip === undefined ) {
  	//	return;
  	//}
  	if ( object.properties.tooltip !== undefined ) {
	  	tt = object.properties.tooltip;
	  } else if ( object.tooltip !== undefined ) {
	  	tt = object.tooltip;
	  } else {
	  	return;
	  }

    tooltip.style.display = 'block';
    tooltip.style.top = `${y}px`;
    tooltip.style.left = `${x}px`;
    tooltip.innerHTML = `<div>${tt}</div>`;
  } else {
  	tooltip.style.display = 'none';
    tooltip.innerHTML = '';
  }
}

function md_update_layer( map_id, layer_id, layer ) {

  var elem = md_findObjectElementByKey( window[map_id + 'map'].props.layers, 'id', layer_id );
  if ( elem != -1 ) {
  	window[ map_id + 'layers'][elem] = layer;
  } else {
  	window[map_id + 'layers'].push( layer );
  }
  window[map_id + 'map'].setProps({ layers: [...window[map_id + 'layers'] ] });
}

function md_findObjectElementByKey(array, key, value ) {
    for ( var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return i;
        }
    }
    return -1;
}

function md_get_point_coordinates ( obj ) {
	if ( obj.geometry.geometry === null ) {
		return [-179.999,-89.999];
	}
	return obj.geometry.geometry.coordinates;
}

function md_layer_view( map_id, layer_id, focus_layer, bbox, update_view ) {

	if( focus_layer ) {
  	md_clear_bounds( map_id );
  	update_view = true;     // force this
  }

  if( bbox !== undefined && update_view) {
	  md_add_to_bounds( map_id, bbox, layer_id );
	  var loc = md_center_location( window[ map_id + 'globalBox'] );
	  md_change_location( map_id, loc, window[ map_id + 'currentZoomLevel'], null, null, 0, "linear" );
  }
}

function md_add_to_bounds( map_id, bbox, layer_id ) {

  var thisBox = {
  	layer_id: layer_id,
  	bbox: bbox
  };

  var elem = md_findObjectElementByKey( window[ map_id + 'mapdeckBounds'], 'layer_id', layer_id );
	if ( elem != -1 ) {
		window[ map_id + 'mapdeckBounds' ][elem] = thisBox;
	} else {
		window[ map_id + 'mapdeckBounds'].push( thisBox );
	}

	md_calculate_bounds( map_id, window[ map_id + 'mapdeckBounds'] );

	window[ map_id + 'currentZoomLevel'] = md_get_zoom_level( window[ map_id + 'globalBox'] );
}

function md_calculate_bounds( map_id, mapdeckBounds ) {

  var ymin, xmin, ymax, xmax, thisBox;
  for( var i = 0; i < mapdeckBounds.length; i++ ) {
    thisBox = mapdeckBounds[i].bbox;

    if ( i === 0 ) {
      xmin = thisBox[0][0];
      ymin = thisBox[0][1];
      xmax = thisBox[1][0];
      ymax = thisBox[1][1];
    } else {
      xmin = Math.min( xmin, thisBox[0][0] );
      ymin = Math.min( ymin, thisBox[0][1] );
      xmax = Math.max( xmax, thisBox[1][0] );
      ymax = Math.max( ymax, thisBox[1][1] );
    }
  }
  window[ map_id + 'globalBox'] = [[xmin, ymin],[xmax,ymax]];
}

function md_get_zoom_level( globalBox ) {

  var londiff = md_lon_diff( globalBox );
  var latdiff = md_lat_diff( globalBox );

  var lonZoom = md_lon_zoom( londiff );
  var latZoom = md_lat_zoom( latdiff );

  var diff = Math.min( lonZoom, latZoom );

  return diff;
}

function md_lon_diff( globalBox ) {

  xmin = globalBox[0][0];
  xmax = globalBox[1][0];
  xdiff = Math.abs( xmax - xmin );
  return xdiff;
}

function md_lat_diff( globalBox ) {

  ymin = globalBox[0][1];
  ymax = globalBox[1][1];
  ydiff = Math.abs( ymax - ymin );
  return ydiff;
}

function md_lon_zoom( londiff ) {

  var lonZoomLevel = [
    360, 180, 90, 45, 22.5, 11.25, 5.65,2.813, 1.406,
    0.703, 0.352, 0.176, 0.088, 0.044, 0.022, 0.011, 0.005
  ];

  if ( londiff >= lonZoomLevel[0] ) {
    return 0;
  }
  var maxIndex = lonZoomLevel.length - 2;
  var currentValue = lonZoomLevel[0];
  var i;
  var thisZoom, nextZoom;

  for ( i = 0; i < maxIndex; i++ ) {
    thisZoom = lonZoomLevel[ i ];
    nextZoom = lonZoomLevel[ (i+1) ];

    if ( thisZoom >= londiff && londiff > nextZoom ) {
      return i;
    }
  }
  return i;
}

function md_lat_zoom( latdiff ) {

  var latZoomLevel = [
    90, 45, 22.5, 11.25, 5.65,2.813, 1.406,
    0.703, 0.352, 0.176, 0.088, 0.044, 0.022, 0.011, 0.005, 0.0025, 0.000175
  ];

  if ( latdiff >= latZoomLevel[0] ) {
    return 0;
  }
  var maxIndex = latZoomLevel.length - 2;
  var currentValue = latZoomLevel[0];
  var i;
  var thisZoom, nextZoom;

  for ( i = 0; i < maxIndex; i++ ) {
    thisZoom = latZoomLevel[ i ];
    nextZoom = latZoomLevel[ (i+1) ];

    if ( thisZoom >= latdiff && latdiff > nextZoom ) {
      return i;
    }
  }
  return i;
}

function md_center_location( bbox ) {

	cLon = (bbox[0][0] + bbox[1][0]) / 2;
	cLat = (bbox[0][1] + bbox[1][1]) / 2;
	var location = [cLon, cLat];
	return location;
}

function md_change_location( map_id, location, zoom, pitch, bearing, duration, transition ) {

  var currentLon, currentLat, currentPitch, currentBearing, currentZoom;

  if ( window[ map_id + 'map'].viewState["default-view"] !== undefined ) {
  	currentLon = location === null ? window[ map_id + 'map'].viewState["default-view"].longitude : location[0];
  	currentLat = location === null ? window[ map_id + 'map'].viewState["default-view"].latitude : location[1];
    currentPitch = pitch === null ? window[ map_id + 'map'].viewState["default-view"].pitch : pitch;
    currentBearing = bearing === null ? window[ map_id + 'map' ].viewState["default-view"].bearing : bearing;
    currentZoom = zoom === null ? window[ map_id + 'map'].viewState["default-view"].zoom : zoom;
  } else {
  	currentLon = location === null ? window[ map_id + 'map'].viewState.longitude : location[0];
  	currentLat = location === null ? window[ map_id + 'map'].viewState.latitude : location[1];
    currentPitch = pitch === null ? window[ map_id + 'map'].viewState.pitch : pitch;
    currentBearing = bearing === null ? window[ map_id + 'map' ].viewState.bearing : bearing;
    currentZoom = zoom === null ? window[ map_id + 'map'].viewState.zoom : zoom;
  }

	window[map_id + 'map'].setProps({
    viewState: {
      longitude: currentLon,
      latitude: currentLat,
      zoom: currentZoom,
      pitch: currentPitch,
      bearing: currentBearing,
      transitionInterpolator: transition === "fly" ? new deck.FlyToInterpolator() : new deck.LinearInterpolator(),
      transitionDuration: duration
    },
  });
}
