

var myRadius = 10;

function add_scatterplot_geo( map_id, map_type, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, radius_min_pixels, radius_max_pixels ) {

  console.log( myRadius );

  const scatterLayer = new ScatterplotLayer({
    map_id: map_id,
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: radius_min_pixels || 1,
    radiusMaxPixels: radius_max_pixels || Number.MAX_SAFE_INTEGER,
    lineWidthMinPixels: 0,
    stroked: true,  // TODO( make conditional IFF stroke provided?)
    filled: true,
    parameters: {
	    depthTest: false
	  },
    //getRadius: d => d.properties.radius,
    getRadius: Number( myRadius ),
    updateTriggers: {
    	getRadius: Number( myRadius )
    },
    getPosition: d => md_get_point_coordinates( d ),
    getFillColor: d => md_hexToRGBA( d.properties.fill_colour ),
    getLineColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getLineWidth: d => d.properties.stroke_width,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "scatterplot", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });

	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'scatterplot-'+layer_id, scatterLayer );
	} else {
	  md_update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );
	}

	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }

  //md_add_control( map_id, map_type, 'scatterplot-'+layer_id, scatterLayer );

  if( !md_div_exists( 'controlContainer'+map_id ) ) {
  	md_setup_controls( map_id );
  }

  // TODO
  // add the controls to the container
  if( !document.getElementById("myRange") ) {
	  var slider_input = document.createElement("input");
	  slider_input.setAttribute('type', 'range');
	  slider_input.setAttribute('id', 'myRange');
	  slider_input.setAttribute('name', 'width');
	  slider_input.setAttribute('step', '10');
	  slider_input.setAttribute('min', '100');
	  slider_input.setAttribute('max', '1000000');
	  slider_input.setAttribute('value', '100');

	  var slider_input_title  = document.createElement("div");
	  slider_input_title.innerHTML = `test + ${myRadius}` ;

	  var mapbox_ctrl = document.getElementById( "controlContainer"+map_id );
	  mapbox_ctrl.appendChild(slider_input_title);
	  mapbox_ctrl.appendChild(slider_input);

	  // need to add an observer for the control added
	  // querySelector is a css selector
	  // so use # for id, and . for class
	  slider_input.addEventListener('input', function(evt) {
	    // need to hook this up with the updateTrigger{}
	    myRadius = slider_input.value;
	    slider_input_title.innerHTML = `test + ${myRadius}` ;

	    // need to re-draw the layer when this value changes
	    //md_update_layer( map_id, layer_id, layer );
	    // https://github.com/uber/deck.gl/issues/2123#issuecomment-407687152
	    add_scatterplot_geo( map_id, map_type, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, false, focus_layer, js_transition, radius_min_pixels, radius_max_pixels );
	  });

  }

  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function add_scatterplot_polyline( map_id, map_type, scatter_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, radius_min_pixels, radius_max_pixels ) {

  const scatterLayer = new ScatterplotLayer({
    map_id: map_id,
    id: 'scatterplot-'+layer_id,
    data: scatter_data,
    radiusScale: 1,
    radiusMinPixels: radius_min_pixels || 1,
    radiusMaxPixels: radius_max_pixels || Number.MAX_SAFE_INTEGER,
    lineWidthMinPixels: 0,
    stroked: true,
    filled: true,
    parameters: {
	    depthTest: false
	  },
    getRadius: d => d.radius,
    getPosition: d => md_decode_points( d.polyline ),
    getFillColor: d => md_hexToRGBA( d.fill_colour ),
    getLineColor: d => md_hexToRGBA( d.stroke_colour ),
    getLineWidth: d => d.stroke_width,
    pickable: true,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    onClick: info => md_layer_click( map_id, "scatterplot", info ),
    onHover: md_update_tooltip,
    transitions: js_transition || {}
  });

	if( map_type == "google_map") {
	  md_update_overlay( map_id, 'scatterplot-'+layer_id, scatterLayer );
	} else {
	  md_update_layer( map_id, 'scatterplot-'+layer_id, scatterLayer );
	}

	if (legend !== false) {
    md_add_legend(map_id, map_type, layer_id, legend);
  }
  md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
