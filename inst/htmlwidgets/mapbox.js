 HTMLWidgets.widget({

  name: 'mapbox',
  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    return {

      renderValue: function(x) {

      	//window.params = [];
      	//window.params.push({ 'map_id' : el.id });

      	window[el.id + 'layers'] = []; // keep track of layers for overlaying multiple
        window[el.id + 'legendPositions'] = [];     // array for keeping a referene to legend positions
        window[el.id + 'mapTitlePositions'] = [];
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

        var mapTitle = document.createElement('div');
        mapTitle.className = "mapTitleContainer";
        mapTitle.id = "mapTitleContainer"+el.id;
        mapDiv.appendChild( mapTitle );

        var tooltipdiv = document.createElement('div');
        tooltipdiv.setAttribute("class", "mapdecktooltip");
        tooltipdiv.setAttribute("id", "mapdecktooltip"+el.id);
        mapDiv.appendChild(tooltipdiv);

        // INITIAL VIEW
        window[el.id + 'INITIAL_VIEW_STATE'] = {
        	longitude: x.location[0],
        	latitude: x.location[1],
        	zoom: x.zoom,
        	pitch: x.pitch,
        	bearing: x.bearing
        };

        mapboxgl.accessToken = x.access_token;

			  var map = new mapboxgl.Map({
					container: el.id,
					style: x.style,
					zoom: x.zoom,
					center: [x.location[0], x.location[1]],
					pitch: x.pitch,
        	bearing: x.bearing
				});

        // TODO make this optional
				//map.addControl(new mapboxgl.NavigationControl());


			  window[el.id + 'map'] = map;
		    md_initialise_mapbox(el, x);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size
      }

    };
  }
});

function add_mapbox_layer( map_id, layer_json ) {
  var map = window[ map_id + 'map'];
  var js = JSON.parse( layer_json );
  map.on('styledata', function() {
    map.addLayer( js );
  });
}

function add_mapbox_source( map_id, id, source_json ) {
	var map = window[ map_id + 'map'];
  var js = JSON.parse( source_json );
  map.on('styledata', function() {
	  var mapLayer = map.getLayer( id );
	  if( typeof mapLayer === 'undefined' ) {
	    map.addSource( id,  js );
	  }
  });
}

if (HTMLWidgets.shinyMode) {

  Shiny.addCustomMessageHandler("mapboxmap-calls", function (data) {

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

function md_initialise_mapbox(el, x) {

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
