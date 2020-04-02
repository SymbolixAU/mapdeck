

function add_path_geo( map_id, map_type, path_data, data_count, start_indices, stride, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, billboard, brush_radius, use_dashes ) {

  var extensions = [];

  console.log( path_data );
  console.log( data_count );

  if ( brush_radius > 0 ) {
  	extensions.push( new deck.BrushingExtension() );
  }

  let hasTooltip = path_data.tooltip !== undefined;

  extensions.push(
  	new deck.PathStyleExtension({dash: true})
  );

  const binaryLocation = new Float32Array( path_data.geometry );
  const binaryLineColour = new Uint8Array( path_data.stroke_colour );
  const binaryLineWidth = new Float32Array( path_data.stroke_width );
  const binaryStartIndices = new Uint32Array( start_indices );

  //const binaryDash = new Float32Array( path_data.dash_array );
  var binaryDash;

  if( use_dashes ) {
  	const n = path_data.dash_size.length * 2;
  	var dashes = [ n ];
  	var counter = 0;
  	for( i = 0; i < n; i++ ) {
  		dashes[ counter ] = path_data.dash_size[ i ];
  		counter = counter + 1;
  		dashes[ counter ] = path_data.dash_gap[ i ];
  		counter = counter + 1;
  	}
  	console.log( dashes );
  	binaryDash = new Float32Array( dashes );
  	//const binaryDash = new Float32Array( dashes );
  } else {
  	//const binaryDash = new Float32Array();
  }


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
      startIndices: binaryStartIndices,
      attributes: {
        getPath: {value: binaryLocation, size: stride},
        getColor: {value: binaryLineColour, size: 4},
        getWidth: {value: binaryLineWidth, size: 1},
        getDashArray: {value: binaryDash, size: 2}
      },
      tooltip: path_data.tooltip
    },
    _pathType: 'open',

	  /*
    getPath: d => md_get_line_coordinates( d ),
    getColor: d => md_hexToRGBA( d.properties.stroke_colour ),
    getWidth: d => d.properties.stroke_width,
    getDashArray: d => [ d.properties.dash_size, d.properties.dash_gap ],
    */
    onClick: info => md_layer_click( map_id, "path", info ),
    onHover: info => hasTooltip ? md_update_binary_tooltip( info.layer, info.index, info.x, info.y ) : null,
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


function add_path_polyline( map_id, map_type, path_data, data_count, start_indices, stride, layer_id, auto_highlight, highlight_colour, legend, bbox, update_view, focus_layer, js_transition, billboard, brush_radius ) {

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
