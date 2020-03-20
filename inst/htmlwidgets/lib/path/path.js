

function add_path_geo( map_id, map_type, path_data, data_count, start_indices, stride, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, billboard, brush_radius ) {

  console.log( path_data );
  console.log( data_count );
  console.log( start_indices );
  console.log( stride );

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  var extensions = [];
  //extensions.push(
  //	new deck.PathStyleExtension({dash: true})
  //);

  const binaryLocation = new Float32Array(path_data.geometry);
  const binaryDash = new Float32Array(path_data.dash_gap);
  const binaryLineColour = new Uint8Array(path_data.stroke_colour);
  const binaryLineWidth = new Uint8Array(path_data.stroke_width);

  const pathLayer = new deck.PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    //data: path_data,
    pickable: true,
    widthScale: 1,
    widthMinPixels: 1,
    rounded: true,
    billboard: billboard,
    parameters: {
	    depthTest: false
	  },

	  data: {
      length: data_count,
      startIndices: start_indices,
      attributes: {
        getPath: {value: binaryLocation, size: stride},
        //getDashArray: {value: binaryDash, size: 1},
        //getFillColor: {value: binaryFillColour, size: 4},
        getColor: {value: binaryLineColour, size: 4},
        getWidth: {value: binaryLineWidth, size: 1}
      }
    },
    _pathType: 'open',

	  /*
    getPath: d => md_get_line_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getWidth: d => d.properties.stroke_width,
    getDashArray: d => [ d.properties.dash_size, d.properties.dash_gap ],
    */
    onClick: info => md_layer_click( map_id, "path", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'path-'+layer_id, pathLayer );
	} else {
	  md_update_layer( map_id, 'path-'+layer_id, pathLayer );
	}

	if ( legend !== false ) {
	  md_add_legend( map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}

function add_path_polyline( map_id, map_type, path_data, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, billboard, brush_radius ) {

  var extensions = [];

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  var extensions = [];
  extensions.push(
  	new deck.PathStyleExtension({dash: true})
  );

  const pathLayer = new deck.PathLayer({
    map_id: map_id,
    id: 'path-'+layer_id,
    data: path_data,
    pickable: true,
    widthScale: 1,
    widthMinPixels: 1,
    rounded: true,
    parameters: {
	    depthTest: false
	  },
    billboard: billboard,
    getPath: d => md_decode_polyline( d.polyline ),  // needs to be one row per polyline
    getColor: d => md_hexToRGBA( d.stroke_colour ),
    getWidth: d => d.stroke_width,
    getDashArray: d => [ d.dash_size, d.dash_gap ],
    onClick: info => md_layer_click( map_id, "path", info ),
    onHover: md_update_tooltip,
    autoHighlight: auto_highlight,
    highlightColor: md_hexToRGBA( highlight_colour ),
    transitions: js_transition || {},
    brushingRadius: brush_radius,
    extensions: extensions
  });

  if( map_type == "google_map") {
	  md_update_overlay( map_id, 'path-'+layer_id, pathLayer );
	} else {
	  md_update_layer( map_id, 'path-'+layer_id, pathLayer );
	}

	if ( legend !== false ) {
	  md_add_legend( map_id, map_type, layer_id, legend, "hex" );
	}
	md_layer_view( map_id, map_type, layer_id, focus_layer, bbox, update_view );
}
